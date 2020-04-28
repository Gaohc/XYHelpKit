//
//  NSSet+SetHook.m
//  XYYException
//
//  Created by 高洪成 on 2020/4/28.
//

#import "NSSet+SetHook.h"
#import "NSObject+SwizzleHook.h"
#import "XYYExceptionProxy.h"
#import "XYYExceptionMacros.h"

XYYSYNTH_DUMMY_CLASS(NSSet_SetHook)

@implementation NSSet (SetHook)

+ (void)XYY_swizzleNSSet{
    [NSSet XYY_swizzleClassMethod:@selector(setWithObject:) withSwizzleMethod:@selector(hookSetWithObject:)];
}

+ (instancetype)hookSetWithObject:(id)object{
    if (object){
        return [self hookSetWithObject:object];
    }
    handleCrashException(XYYExceptionGuardArrayContainer,@"NSSet setWithObject nil object");
    return nil;
}

@end
