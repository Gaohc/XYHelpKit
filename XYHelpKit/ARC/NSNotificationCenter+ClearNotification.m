//
//  NSNotificationCenter+ClearNotification.m
//  XYYException
//
//  Created by 高洪成 on 2020/4/28.
//

#import "NSNotificationCenter+ClearNotification.h"
#import "NSObject+SwizzleHook.h"
#import "NSObject+DeallocBlock.h"
#import "XYYExceptionMacros.h"
#import <objc/runtime.h>

XYYSYNTH_DUMMY_CLASS(NSNotificationCenter_ClearNotification)

@implementation NSNotificationCenter (ClearNotification)

+ (void)XYY_swizzleNSNotificationCenter{
    [self XYY_swizzleInstanceMethod:@selector(addObserver:selector:name:object:) withSwizzledBlock:^id(XYYSwizzleObject *swizzleInfo) {
        return ^(__unsafe_unretained id self,id observer,SEL aSelector,NSString* aName,id anObject){
            [self processAddObserver:observer selector:aSelector name:aName object:anObject swizzleInfo:swizzleInfo];
        };
    }];
}

- (void)processAddObserver:(id)observer selector:(SEL)aSelector name:(NSNotificationName)aName object:(id)anObject swizzleInfo:(XYYSwizzleObject*)swizzleInfo{
    
    if (!observer) {
        return;
    }
    
    if ([observer isKindOfClass:NSObject.class]) {
        __unsafe_unretained typeof(observer) unsafeObject = observer;
        [observer XYY_deallocBlock:^{
            [[NSNotificationCenter defaultCenter] removeObserver:unsafeObject];
        }];
    }
    
    void(*originIMP)(__unsafe_unretained id,SEL,id,SEL,NSString*,id);
    originIMP = (__typeof(originIMP))[swizzleInfo getOriginalImplementation];
    if (originIMP != NULL) {
        originIMP(self,swizzleInfo.selector,observer,aSelector,aName,anObject);
    }
}

@end

