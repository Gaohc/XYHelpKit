//
//  NSMutableSet+Safe.m
//  FBSnapshotTestCase
//
//  Created by 高洪成 on 2020/4/23.
//

#import "NSMutableSet+Safe.h"

#import "NSObject+SafeSwizzle.h"
#import "XYYSafeProtector.h"


@implementation NSMutableSet (Safe)

+(void)openSafeProtector
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class dClass=NSClassFromString(@"__NSSetM");
        [self safe_exchangeInstanceMethod:dClass originalSel:@selector(addObject:) newSel:@selector(safe_addObject:)];
        [self safe_exchangeInstanceMethod:dClass originalSel:@selector(removeObject:) newSel:@selector(safe_removeObject:)];
    });
}
- (void)safe_addObject:(id)object
{
    @try {
        [self safe_addObject:object];
    }
    @catch (NSException *exception) {
        XYYSafeProtectionCrashLog(exception,XYYSafeProtectorCrashTypeNSMutableSet);
    }
    @finally {
    }
}
- (void)safe_removeObject:(id)object
{
    @try {
        [self safe_removeObject:object];
    }
    @catch (NSException *exception) {
        XYYSafeProtectionCrashLog(exception,XYYSafeProtectorCrashTypeNSMutableSet);
    }
    @finally {
    }
}




@end
