//
//  XYYExceptionProxy.m
//  FBSnapshotTestCase
//
//  Created by 高洪成 on 2020/4/28.
//

#import "XYYExceptionProxy.h"
#import <mach-o/dyld.h>
#import <objc/runtime.h>

__attribute__((overloadable)) void handleCrashException(NSString* exceptionMessage){
    [[XYYExceptionProxy shareExceptionProxy] handleCrashException:exceptionMessage extraInfo:@{}];
}

__attribute__((overloadable)) void handleCrashException(NSString* exceptionMessage,NSDictionary* extraInfo){
    [[XYYExceptionProxy shareExceptionProxy] handleCrashException:exceptionMessage extraInfo:extraInfo];
}

__attribute__((overloadable)) void handleCrashException(XYYExceptionGuardCategory exceptionCategory, NSString* exceptionMessage,NSDictionary* extraInfo){
    [[XYYExceptionProxy shareExceptionProxy] handleCrashException:exceptionMessage exceptionCategory:exceptionCategory extraInfo:extraInfo];
}

__attribute__((overloadable)) void handleCrashException(XYYExceptionGuardCategory exceptionCategory, NSString* exceptionMessage){
    [[XYYExceptionProxy shareExceptionProxy] handleCrashException:exceptionMessage exceptionCategory:exceptionCategory extraInfo:nil];
}

/**
 Get application base address,the application different base address after started
 
 @return base address
 */
uintptr_t get_load_address(void) {
    const struct mach_header *exe_header = NULL;
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        const struct mach_header *header = _dyld_get_image_header(i);
        if (header->filetype == MH_EXECUTE) {
            exe_header = header;
            break;
        }
    }
    return (uintptr_t)exe_header;
}

/**
 Address Offset

 @return slide address
 */
uintptr_t get_slide_address(void) {
    uintptr_t vmaddr_slide = 0;
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        const struct mach_header *header = _dyld_get_image_header(i);
        if (header->filetype == MH_EXECUTE) {
            vmaddr_slide = _dyld_get_image_vmaddr_slide(i);
            break;
        }
    }
    
    return (uintptr_t)vmaddr_slide;
}

@interface XYYExceptionProxy(){
    NSMutableSet* _currentClassesSet;
    NSMutableSet* _blackClassesSet;
    NSInteger _currentClassSize;
    dispatch_semaphore_t _classArrayLock;//Protect _blackClassesSet and _currentClassesSet atomic
    dispatch_semaphore_t _swizzleLock;//Protect swizzle atomic
}

@end

@implementation XYYExceptionProxy

+(instancetype)shareExceptionProxy{
    static dispatch_once_t onceToken;
    static id exceptionProxy;
    dispatch_once(&onceToken, ^{
        exceptionProxy = [[self alloc] init];
    });
    return exceptionProxy;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _blackClassesSet = [NSMutableSet new];
        _currentClassesSet = [NSMutableSet new];
        _currentClassSize = 0;
        _classArrayLock = dispatch_semaphore_create(1);
        _swizzleLock = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)handleCrashException:(NSString *)exceptionMessage exceptionCategory:(XYYExceptionGuardCategory)exceptionCategory extraInfo:(NSDictionary *)info{
    if (!exceptionMessage) {
        return;
    }
    
    NSArray* callStack = [NSThread callStackSymbols];
    NSString* callStackString = [NSString stringWithFormat:@"%@",callStack];
    
    uintptr_t loadAddress =  get_load_address();
    uintptr_t slideAddress =  get_slide_address();
    
    NSString* exceptionResult = [NSString stringWithFormat:@"%ld\n%ld\n%@\n%@",loadAddress,slideAddress,exceptionMessage,callStackString];
    
    
    if ([self.delegate respondsToSelector:@selector(handleCrashException:extraInfo:)]){
        [self.delegate handleCrashException:exceptionResult extraInfo:info];
    }
    
    if ([self.delegate respondsToSelector:@selector(handleCrashException:exceptionCategory:extraInfo:)]) {
        [self.delegate handleCrashException:exceptionResult exceptionCategory:exceptionCategory extraInfo:info];
    }
    
#ifdef DEBUG
    NSLog(@"================================XYYException Start==================================");
    NSLog(@"XYYException Type:%ld",(long)exceptionCategory);
    NSLog(@"XYYException Description:%@",exceptionMessage);
    NSLog(@"XYYException Extra info:%@",info);
    NSLog(@"XYYException CallStack:%@",callStack);
    NSLog(@"================================XYYException End====================================");
    if (self.exceptionWhenTerminate) {
        NSAssert(NO, @"");
    }
#endif
}

- (void)handleCrashException:(NSString *)exceptionMessage extraInfo:(nullable NSDictionary *)info{
    [self handleCrashException:exceptionMessage exceptionCategory:XYYExceptionGuardNone extraInfo:info];
}

- (void)setIsProtectException:(BOOL)isProtectException{
    dispatch_semaphore_wait(_swizzleLock, DISPATCH_TIME_FOREVER);
    if (_isProtectException != isProtectException) {
        _isProtectException = isProtectException;
        
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wundeclared-selector"
        
        if(self.exceptionGuardCategory & XYYExceptionGuardArrayContainer){
            [NSArray performSelector:@selector(XYY_swizzleNSArray)];
            [NSMutableArray performSelector:@selector(XYY_swizzleNSMutableArray)];
            [NSSet performSelector:@selector(XYY_swizzleNSSet)];
            [NSMutableSet performSelector:@selector(XYY_swizzleNSMutableSet)];
        }
        if(self.exceptionGuardCategory & XYYExceptionGuardDictionaryContainer){
            [NSDictionary performSelector:@selector(XYY_swizzleNSDictionary)];
            [NSMutableDictionary performSelector:@selector(XYY_swizzleNSMutableDictionary)];
        }
        if(self.exceptionGuardCategory & XYYExceptionGuardUnrecognizedSelector){
            [NSObject performSelector:@selector(XYY_swizzleUnrecognizedSelector)];
        }
        
        if (self.exceptionGuardCategory & XYYExceptionGuardZombie) {
            [NSObject performSelector:@selector(XYY_swizzleZombie)];
        }
        
        if (self.exceptionGuardCategory & XYYExceptionGuardKVOCrash) {
            [NSObject performSelector:@selector(XYY_swizzleKVOCrash)];
        }
        
        if (self.exceptionGuardCategory & XYYExceptionGuardNSTimer) {
            [NSTimer performSelector:@selector(XYY_swizzleNSTimer)];
        }
        
        if (self.exceptionGuardCategory & XYYExceptionGuardNSNotificationCenter) {
            [NSNotificationCenter performSelector:@selector(XYY_swizzleNSNotificationCenter)];
        }
        
        if (self.exceptionGuardCategory & XYYExceptionGuardNSStringContainer) {
            [NSString performSelector:@selector(XYY_swizzleNSString)];
            [NSMutableString performSelector:@selector(XYY_swizzleNSMutableString)];
            [NSAttributedString performSelector:@selector(XYY_swizzleNSAttributedString)];
            [NSMutableAttributedString performSelector:@selector(XYY_swizzleNSMutableAttributedString)];
        }
        #pragma clang diagnostic pop
    }
    dispatch_semaphore_signal(_swizzleLock);
}

- (void)setExceptionGuardCategory:(XYYExceptionGuardCategory)exceptionGuardCategory{
    if (_exceptionGuardCategory != exceptionGuardCategory) {
        _exceptionGuardCategory = exceptionGuardCategory;
    }
}



- (void)addZombieObjectArray:(NSArray*)objects{
    if (!objects) {
        return;
    }
    dispatch_semaphore_wait(_classArrayLock, DISPATCH_TIME_FOREVER);
    [_blackClassesSet addObjectsFromArray:objects];
    dispatch_semaphore_signal(_classArrayLock);
}

- (NSSet*)blackClassesSet{
    return _blackClassesSet;
}

- (void)addCurrentZombieClass:(Class)object{
    if (object) {
        dispatch_semaphore_wait(_classArrayLock, DISPATCH_TIME_FOREVER);
        _currentClassSize = _currentClassSize + class_getInstanceSize(object);
        [_currentClassesSet addObject:object];
        dispatch_semaphore_signal(_classArrayLock);
    }
}

- (void)removeCurrentZombieClass:(Class)object{
    if (object) {
        dispatch_semaphore_wait(_classArrayLock, DISPATCH_TIME_FOREVER);
        _currentClassSize = _currentClassSize - class_getInstanceSize(object);
        [_currentClassesSet removeObject:object];
        dispatch_semaphore_signal(_classArrayLock);
    }
}

- (NSSet*)currentClassesSet{
    return _currentClassesSet;
}

- (NSInteger)currentClassSize{
    return _currentClassSize;
}

- (nullable id)objectFromCurrentClassesSet{
    NSEnumerator* objectEnum = [_currentClassesSet objectEnumerator];
    for (id object in objectEnum) {
        return object;
    }
    return nil;
}

@end
