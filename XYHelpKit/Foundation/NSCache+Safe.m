//
//  NSCache+Safe.m
//  FBSnapshotTestCase
//
//  Created by 高洪成 on 2020/4/23.
//

#import "NSCache+Safe.h"
#import "NSObject+SafeSwizzle.h"
#import "XYYSafeProtector.h"


@implementation NSCache (Safe)

+(void)openSafeProtector
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class dClass=NSClassFromString(@"NSCache");
        [self safe_exchangeInstanceMethod:dClass originalSel:@selector(setObject:forKey:) newSel:@selector(safe_setObject:forKey:)];
        
        [self safe_exchangeInstanceMethod:dClass originalSel:@selector(setObject:forKey:cost:) newSel:@selector(safe_setObject:forKey:cost:)];
    });
}

-(void)safe_setObject:(id)obj forKey:(id)key
{
    if(key&&obj){
        [self safe_setObject:obj forKey:key];
    }else{
        NSString *reason=[NSString stringWithFormat:@"NSCache %@ key and value can`t be nil",NSStringFromSelector(_cmd)];
        NSException *exception=[NSException exceptionWithName:reason reason:reason userInfo:nil];
        XYYSafeProtectionCrashLog(exception,XYYSafeProtectorCrashTypeNSCache);
    }
}
-(void)safe_setObject:(id)obj forKey:(id)key cost:(NSUInteger)g
{
    if(key&&obj){
        [self safe_setObject:obj forKey:key cost:g];
    }else{
        NSString *reason=[NSString stringWithFormat:@"NSCache %@ key and value can`t be nil",NSStringFromSelector(_cmd)];
        NSException *exception=[NSException exceptionWithName:reason reason:reason userInfo:nil];
        XYYSafeProtectionCrashLog(exception,XYYSafeProtectorCrashTypeNSCache);
    }
}


@end
