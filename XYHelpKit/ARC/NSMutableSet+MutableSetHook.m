//
//  NSMutableSet+MutableSetHook.m
//  XYYException
//
//  Created by 高洪成 on 2020/4/28.
//

#import "NSMutableSet+MutableSetHook.h"
#import "NSObject+SwizzleHook.h"
#import <objc/runtime.h>
#import "XYYExceptionProxy.h"
#import "XYYExceptionMacros.h"

XYYSYNTH_DUMMY_CLASS(NSMutableSet_MutableSetHook)

@implementation NSMutableSet (MutableSetHook)

+ (void)XYY_swizzleNSMutableSet{
    NSMutableSet* instanceObject = [NSMutableSet new];
    Class cls =  object_getClass(instanceObject);
    
    swizzleInstanceMethod(cls,@selector(addObject:), @selector(hookAddObject:));
    swizzleInstanceMethod(cls,@selector(removeObject:), @selector(hookRemoveObject:));
}

- (void) hookAddObject:(id)object {
    if (object) {
        [self hookAddObject:object];
    } else {
        handleCrashException(XYYExceptionGuardArrayContainer,@"NSSet addObject nil object");
    }
}

- (void) hookRemoveObject:(id)object {
    if (object) {
        [self hookRemoveObject:object];
    } else {
        handleCrashException(XYYExceptionGuardArrayContainer,@"NSSet removeObject nil object");
    }
}

@end
