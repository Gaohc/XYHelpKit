//
//  NSObject+UnrecognizedSelectorHook.m
//  XYYException
//
//  Created by 高洪成 on 2020/4/28.
//

#import "NSObject+UnrecognizedSelectorHook.h"
#import "NSObject+SwizzleHook.h"
#import <objc/runtime.h>
#import "XYYExceptionProxy.h"
#import "XYYExceptionMacros.h"

XYYSYNTH_DUMMY_CLASS(NSObject_UnrecognizedSelectorHook)


@interface XYYSafeProxy:NSObject
@property (nonatomic,strong) NSException *exception;
@property (nonatomic,weak) id safe_object;
@end
@implementation XYYSafeProxy
-(void)safe_crashLog{
}
@end



@implementation NSObject (UnrecognizedSelectorHook)

+ (void)XYY_swizzleUnrecognizedSelector{
    
    
    if ([NSStringFromClass([NSObject class]) isEqualToString:@"NSObject"]) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                
                    swizzleClassMethod([self class], @selector(methodSignatureForSelector:), @selector(classMethodSignatureForSelectorSwizzled:));
                
                    swizzleClassMethod([self class], @selector(forwardInvocation:), @selector(forwardClassInvocationSwizzled:));
                
                    //Instance Method
                    swizzleInstanceMethod([self class], @selector(methodSignatureForSelector:), @selector(methodSignatureForSelectorSwizzled:));
                    swizzleInstanceMethod([self class], @selector(forwardInvocation:), @selector(forwardInvocationSwizzled:));
                
            });
        }else{
        }
//    //Class Method
//    swizzleClassMethod([self class], @selector(methodSignatureForSelector:), @selector(classMethodSignatureForSelectorSwizzled:));
//    swizzleClassMethod([self class], @selector(forwardInvocation:), @selector(forwardClassInvocationSwizzled:));
//
//    //Instance Method
//    swizzleInstanceMethod([self class], @selector(methodSignatureForSelector:), @selector(methodSignatureForSelectorSwizzled:));
//    swizzleInstanceMethod([self class], @selector(forwardInvocation:), @selector(forwardInvocationSwizzled:));
}

+ (NSMethodSignature*)classMethodSignatureForSelectorSwizzled:(SEL)aSelector {
    NSMethodSignature* methodSignature = [self classMethodSignatureForSelectorSwizzled:aSelector];
    if (methodSignature) {
        return methodSignature;
    }
    return [self.class checkObjectSignatureAndCurrentClass:self.class];
}

- (NSMethodSignature*)methodSignatureForSelectorSwizzled:(SEL)aSelector {
    NSMethodSignature* methodSignature = [self methodSignatureForSelectorSwizzled:aSelector];
    if (methodSignature) {
        return methodSignature;
    }
    return [self.class checkObjectSignatureAndCurrentClass:self.class];
}

/**
 * Check the class method signature to the [NSObject class]
 * If not equals,return nil
 * If equals,return the v@:@ method

 @param currentClass Class
 @return NSMethodSignature
 */
+ (NSMethodSignature *)checkObjectSignatureAndCurrentClass:(Class)currentClass{
    IMP originIMP = class_getMethodImplementation([NSObject class], @selector(methodSignatureForSelector:));
    IMP currentClassIMP = class_getMethodImplementation(currentClass, @selector(methodSignatureForSelector:));
    
    // If current class override methodSignatureForSelector return nil
    if (originIMP != currentClassIMP){
        return nil;
    }
    // Customer method signature
    // void xxx(id,sel,id)
    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
//     return [XYYSafeProxy instanceMethodSignatureForSelector:@selector(safe_crashLog)];
}

/**
 Forward instance object

 @param invocation NSInvocation
 */
- (void)forwardInvocationSwizzled:(NSInvocation*)invocation{
    NSString* message = [NSString stringWithFormat:@"Unrecognized instance class:%@ and selector:%@",NSStringFromClass(self.class),NSStringFromSelector(invocation.selector)];
    handleCrashException(XYYExceptionGuardUnrecognizedSelector,message);
}

/**
 Forward class object

 @param invocation NSInvocation
 */
+ (void)forwardClassInvocationSwizzled:(NSInvocation*)invocation{
    NSString* message = [NSString stringWithFormat:@"Unrecognized static class:%@ and selector:%@",NSStringFromClass(self.class),NSStringFromSelector(invocation.selector)];
    handleCrashException(XYYExceptionGuardUnrecognizedSelector,message);
}


@end
