//
//  NSObject+Zombie.m
//  XYYException
//
//  Created by 高洪成 on 2020/4/28.
//

#import "NSObject+ZombieHook.h"
#import "NSObject+SwizzleHook.h"
#import <objc/runtime.h>
#import "XYYExceptionProxy.h"

const NSInteger MAX_ARRAY_SIZE = 1024 * 1024 * 5;// MAX Memeory Size 5M

@interface ZombieSelectorHandle : NSObject

@property(nonatomic,readwrite,assign)id fromObject;

@end


@implementation ZombieSelectorHandle

void unrecognizedSelectorZombie(ZombieSelectorHandle* self, SEL _cmd){
    
}

@end

@interface XYYZombieSub : NSObject

@end

@implementation XYYZombieSub

- (id)forwardingTargetForSelector:(SEL)selector{
    NSMethodSignature* sign = [self methodSignatureForSelector:selector];
    if (!sign) {
        id stub = [[ZombieSelectorHandle new] autorelease];
        [stub setFromObject:self];
        class_addMethod([stub class], selector, (IMP)unrecognizedSelectorZombie, "v@:");
        return stub;
    }
    return [super forwardingTargetForSelector:selector];
}

@end

@implementation NSObject (ZombieHook)

+ (void)XYY_swizzleZombie{
    [self XYY_swizzleInstanceMethod:@selector(dealloc) withSwizzleMethod:@selector(hookDealloc)];
}

- (void)hookDealloc{
    Class currentClass = self.class;
    
    //Check black list
    if (![[[XYYExceptionProxy shareExceptionProxy] blackClassesSet] containsObject:currentClass]) {
        [self hookDealloc];
        return;
    }
    
    //Check the array max size
    //TODO:Real remove less than MAX_ARRAY_SIZE
    if ([XYYExceptionProxy shareExceptionProxy].currentClassSize > MAX_ARRAY_SIZE) {
        id object = [[XYYExceptionProxy shareExceptionProxy] objectFromCurrentClassesSet];
        [[XYYExceptionProxy shareExceptionProxy] removeCurrentZombieClass:object_getClass(object)];
        object?free(object):nil;
    }
    
    objc_destructInstance(self);
    object_setClass(self, [XYYZombieSub class]);
    [[XYYExceptionProxy shareExceptionProxy] addCurrentZombieClass:currentClass];
}

@end
