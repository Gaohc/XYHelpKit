//
//  NSMutableDictionary+Safe.m
//  FBSnapshotTestCase
//
//  Created by 高洪成 on 2020/4/23.
//

#import "NSMutableDictionary+Safe.h"
#import "NSObject+SafeSwizzle.h"
#import "XYYSafeProtector.h"


@implementation NSMutableDictionary (Safe)
+(void)openSafeProtector
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class dClass=NSClassFromString(@"__NSDictionaryM");
        [self safe_exchangeInstanceMethod:dClass originalSel:@selector(setObject:forKey:) newSel:@selector(safe_setObject:forKey:)];
        [self safe_exchangeInstanceMethod:dClass originalSel:@selector(setObject:forKeyedSubscript:) newSel:@selector(safe_setObject:forKeyedSubscript:)];
        [self safe_exchangeInstanceMethod:dClass originalSel:@selector(removeObjectForKey:) newSel:@selector(safe_removeObjectForKey:)];
        
        
        //__NSCFDictionary
         [self safe_exchangeInstanceMethod:NSClassFromString(@"__NSCFDictionary") originalSel:@selector(setObject:forKey:) newSel:@selector(safe_setObjectCFDictionary:forKey:)];
        
         [self safe_exchangeInstanceMethod:NSClassFromString(@"__NSCFDictionary") originalSel:@selector(removeObjectForKey:) newSel:@selector(safe_removeObjectForKeyCFDictionary:)];
        
    });
}
#pragma mark - __NSCFDictionary
- (void)safe_setObjectCFDictionary:(id)anObject forKey:(id<NSCopying>)aKey {
    
    @try {
        [self safe_setObjectCFDictionary:anObject forKey:aKey];
    }
    @catch (NSException *exception) {
        XYYSafeProtectionCrashLog(exception,XYYSafeProtectorCrashTypeNSMutableDictionary);
    }
    @finally {
    }
}

- (void)safe_removeObjectForKeyCFDictionary:(id)aKey {
    
    @try {
        [self safe_removeObjectForKeyCFDictionary:aKey];
    }
    @catch (NSException *exception) {
        XYYSafeProtectionCrashLog(exception,XYYSafeProtectorCrashTypeNSMutableDictionary);
    }
    @finally {
    }
}

#pragma mark - __NSDictionaryM
- (void)safe_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    
    @try {
        [self safe_setObject:anObject forKey:aKey];
    }
    @catch (NSException *exception) {
        XYYSafeProtectionCrashLog(exception,XYYSafeProtectorCrashTypeNSMutableDictionary);
    }
    @finally {
    }
}

- (void)safe_setObject:(id)anObject forKeyedSubscript:(id<NSCopying>)aKey {
    
    @try {
        [self safe_setObject:anObject forKeyedSubscript:aKey];
    }
    @catch (NSException *exception) {
        XYYSafeProtectionCrashLog(exception,XYYSafeProtectorCrashTypeNSMutableDictionary);
    }
    @finally {
    }
}

- (void)safe_removeObjectForKey:(id)aKey {
    
    @try {
        [self safe_removeObjectForKey:aKey];
    }
    @catch (NSException *exception) {
        XYYSafeProtectionCrashLog(exception,XYYSafeProtectorCrashTypeNSMutableDictionary);
    }
    @finally {
    }
}


@end
