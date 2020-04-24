//
//  NSUserDefaults+Safe.m
//  FBSnapshotTestCase
//
//  Created by 高洪成 on 2020/4/23.
//

#import "NSUserDefaults+Safe.h"

#import "NSObject+SafeSwizzle.h"
#import "XYYSafeProtector.h"


@implementation NSUserDefaults (Safe)

+(void)openSafeProtector
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class dClass=NSClassFromString(@"NSUserDefaults");
        
        [self safe_exchangeInstanceMethod:dClass originalSel:@selector(setObject:forKey:) newSel:@selector(safe_setObject:forKey:)];
        
        [self safe_exchangeInstanceMethod:dClass originalSel:@selector(objectForKey:) newSel:@selector(safe_objectForKey:)];
        
        [self safe_exchangeInstanceMethod:dClass originalSel:@selector(stringForKey:) newSel:@selector(safe_stringForKey:)];
        
        [self safe_exchangeInstanceMethod:dClass originalSel:@selector(arrayForKey:) newSel:@selector(safe_arrayForKey:)];
        
        [self safe_exchangeInstanceMethod:dClass originalSel:@selector(dataForKey:) newSel:@selector(safe_dataForKey:)];
        
        [self safe_exchangeInstanceMethod:dClass originalSel:@selector(URLForKey:) newSel:@selector(safe_URLForKey:)];
        
        [self safe_exchangeInstanceMethod:dClass originalSel:@selector(stringArrayForKey:) newSel:@selector(safe_stringArrayForKey:)];
       
        [self safe_exchangeInstanceMethod:dClass originalSel:@selector(floatForKey:) newSel:@selector(safe_floatForKey:)];
        
        [self safe_exchangeInstanceMethod:dClass originalSel:@selector(doubleForKey:) newSel:@selector(safe_doubleForKey:)];
        
        [self safe_exchangeInstanceMethod:dClass originalSel:@selector(integerForKey:) newSel:@selector(safe_integerForKey:)];
        
        [self safe_exchangeInstanceMethod:dClass originalSel:@selector(boolForKey:) newSel:@selector(safe_boolForKey:)];
       
    });
}
-(void)safe_setObject:(id)value forKey:(NSString *)defaultName
{
    if(!defaultName){
        //defaultName空才会崩溃
        NSString *reason=[NSString stringWithFormat:@"NSUserDefaults %@ key  can`t be nil",NSStringFromSelector(_cmd)];
        NSException *exception=[NSException exceptionWithName:reason reason:reason userInfo:nil];
        XYYSafeProtectionCrashLog(exception,XYYSafeProtectorCrashTypeNSUserDefaults);
    }else{
        [self safe_setObject:value forKey:defaultName];
    }
}

-(id)safe_objectForKey:(NSString *)defaultName
{
    id obj=nil;
    if(defaultName){
        obj=[self safe_objectForKey:defaultName];
    }else{
        NSString *reason=[NSString stringWithFormat:@"NSUserDefaults %@ key can`t be nil",NSStringFromSelector(_cmd)];
        NSException *exception=[NSException exceptionWithName:reason reason:reason userInfo:nil];
        XYYSafeProtectionCrashLog(exception,XYYSafeProtectorCrashTypeNSUserDefaults);
    }
    return obj;
}
-(NSString *)safe_stringForKey:(NSString *)defaultName
{
    id obj=nil;
    if(defaultName){
        obj=[self safe_stringForKey:defaultName];
    }else{
        NSString *reason=[NSString stringWithFormat:@"NSUserDefaults %@ key can`t be nil",NSStringFromSelector(_cmd)];
        NSException *exception=[NSException exceptionWithName:reason reason:reason userInfo:nil];
        XYYSafeProtectionCrashLog(exception,XYYSafeProtectorCrashTypeNSUserDefaults);
    }
    return obj;
}
-(NSArray *)safe_arrayForKey:(NSString *)defaultName
{
    id obj=nil;
    if(defaultName){
        obj=[self safe_arrayForKey:defaultName];
    }else{
        NSString *reason=[NSString stringWithFormat:@"NSUserDefaults %@ key can`t be nil",NSStringFromSelector(_cmd)];
        NSException *exception=[NSException exceptionWithName:reason reason:reason userInfo:nil];
        XYYSafeProtectionCrashLog(exception,XYYSafeProtectorCrashTypeNSUserDefaults);
    }
    return obj;
}
-(NSData *)safe_dataForKey:(NSString *)defaultName
{
    id obj=nil;
    if(defaultName){
        obj=[self safe_dataForKey:defaultName];
    }else{
        NSString *reason=[NSString stringWithFormat:@"NSUserDefaults %@ key can`t be nil",NSStringFromSelector(_cmd)];
        NSException *exception=[NSException exceptionWithName:reason reason:reason userInfo:nil];
        XYYSafeProtectionCrashLog(exception,XYYSafeProtectorCrashTypeNSUserDefaults);
    }
    return obj;
}
-(NSURL *)safe_URLForKey:(NSString *)defaultName
{
    id obj=nil;
    if(defaultName){
        obj=[self safe_URLForKey:defaultName];
    }else{
        NSString *reason=[NSString stringWithFormat:@"NSUserDefaults %@ key can`t be nil",NSStringFromSelector(_cmd)];
        NSException *exception=[NSException exceptionWithName:reason reason:reason userInfo:nil];
        XYYSafeProtectionCrashLog(exception,XYYSafeProtectorCrashTypeNSUserDefaults);
    }
    return obj;
}
-(NSArray<NSString *> *)safe_stringArrayForKey:(NSString *)defaultName
{
    id obj=nil;
    if(defaultName){
        obj=[self safe_stringArrayForKey:defaultName];
    }else{
        NSString *reason=[NSString stringWithFormat:@"NSUserDefaults %@ key can`t be nil",NSStringFromSelector(_cmd)];
        NSException *exception=[NSException exceptionWithName:reason reason:reason userInfo:nil];
        XYYSafeProtectionCrashLog(exception,XYYSafeProtectorCrashTypeNSUserDefaults);
    }
    return obj;
}
-(float)safe_floatForKey:(NSString *)defaultName
{
    float obj=0;
    if(defaultName){
        obj=[self safe_floatForKey:defaultName];
    }else{
        NSString *reason=[NSString stringWithFormat:@"NSUserDefaults %@ key can`t be nil",NSStringFromSelector(_cmd)];
        NSException *exception=[NSException exceptionWithName:reason reason:reason userInfo:nil];
        XYYSafeProtectionCrashLog(exception,XYYSafeProtectorCrashTypeNSUserDefaults);
    }
    return obj;
}

-(double)safe_doubleForKey:(NSString *)defaultName
{
    double obj=0;
    if(defaultName){
        obj=[self safe_doubleForKey:defaultName];
    }else{
        NSString *reason=[NSString stringWithFormat:@"NSUserDefaults %@ key can`t be nil",NSStringFromSelector(_cmd)];
        NSException *exception=[NSException exceptionWithName:reason reason:reason userInfo:nil];
        XYYSafeProtectionCrashLog(exception,XYYSafeProtectorCrashTypeNSUserDefaults);
    }
    return obj;
}
-(NSInteger)safe_integerForKey:(NSString *)defaultName
{
    NSInteger obj=0;
    if(defaultName){
        obj=[self safe_integerForKey:defaultName];
    }else{
        NSString *reason=[NSString stringWithFormat:@"NSUserDefaults %@ key can`t be nil",NSStringFromSelector(_cmd)];
        NSException *exception=[NSException exceptionWithName:reason reason:reason userInfo:nil];
        XYYSafeProtectionCrashLog(exception,XYYSafeProtectorCrashTypeNSUserDefaults);
    }
    return obj;
}


-(BOOL)safe_boolForKey:(NSString *)defaultName
{
    BOOL obj=NO;
    if(defaultName){
        obj=[self safe_boolForKey:defaultName];
    }else{
        NSString *reason=[NSString stringWithFormat:@"NSUserDefaults %@ key can`t be nil",NSStringFromSelector(_cmd)];
        NSException *exception=[NSException exceptionWithName:reason reason:reason userInfo:nil];
        XYYSafeProtectionCrashLog(exception,XYYSafeProtectorCrashTypeNSUserDefaults);
    }
    return obj;
}

@end
