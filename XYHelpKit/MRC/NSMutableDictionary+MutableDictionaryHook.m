//
//  NSMutableDictionary+MutableDictionaryHook.m
//  XYYException
//
//  Created by 高洪成 on 2020/4/28.
//

#import "NSMutableDictionary+MutableDictionaryHook.h"
#import "NSObject+SwizzleHook.h"
#import "XYYExceptionProxy.h"
#import "XYYExceptionMacros.h"

XYYSYNTH_DUMMY_CLASS(NSMutableDictionary_MutableDictionaryHook)

@implementation NSMutableDictionary (MutableDictionaryHook)

+ (void)XYY_swizzleNSMutableDictionary{
    swizzleInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKey:), @selector(hookSetObject:forKey:));
    swizzleInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(removeObjectForKey:), @selector(hookRemoveObjectForKey:));
    swizzleInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKeyedSubscript:), @selector(hookSetObject:forKeyedSubscript:));
}

- (void) hookSetObject:(id)object forKey:(id)key {
    if (object && key) {
        [self hookSetObject:object forKey:key];
    } else {
        handleCrashException(XYYExceptionGuardDictionaryContainer,[NSString stringWithFormat:@"NSMutableDictionary setObject invalid object:%@ and key:%@",object,key],self);
    }
}

- (void) hookRemoveObjectForKey:(id)key {
    if (key) {
        [self hookRemoveObjectForKey:key];
    } else {
        handleCrashException(XYYExceptionGuardDictionaryContainer,@"NSMutableDictionary removeObjectForKey nil key",self);
    }
}

- (void) hookSetObject:(id)object forKeyedSubscript:(id<NSCopying>)key {
    if (key) {
        [self hookSetObject:object forKeyedSubscript:key];
    } else {
        handleCrashException(XYYExceptionGuardDictionaryContainer,[NSString stringWithFormat:@"NSMutableDictionary setObject object:%@ and forKeyedSubscript:%@",object,key],self);
    }
}

@end
