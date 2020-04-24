//
//  NSMutableData+Safe.m
//  FBSnapshotTestCase
//
//  Created by 高洪成 on 2020/4/23.
//

#import "NSMutableData+Safe.h"

#import "NSObject+SafeSwizzle.h"
#import "XYYSafeProtector.h"



@implementation NSMutableData (Safe)
+(void)openSafeProtector
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class dClass=NSClassFromString(@"NSConcreteMutableData");
        [self safe_exchangeInstanceMethod:dClass originalSel:@selector(subdataWithRange:) newSel:@selector(safe_subdataWithRangeMutableConcreteData:)];
        [self safe_exchangeInstanceMethod:dClass originalSel:@selector(rangeOfData:options:range:) newSel:@selector(safe_rangeOfDataMutableConcreteData:options:range:)];
        [self safe_exchangeInstanceMethod:dClass originalSel:@selector(resetBytesInRange:) newSel:@selector(safe_resetBytesInRange:)];
        [self safe_exchangeInstanceMethod:dClass originalSel:@selector(replaceBytesInRange:withBytes:) newSel:@selector(safe_replaceBytesInRange:withBytes:)];
        [self safe_exchangeInstanceMethod:dClass originalSel:@selector(replaceBytesInRange:withBytes:length:) newSel:@selector(safe_replaceBytesInRange:withBytes:length:)];
    });
}
-(NSData *)safe_subdataWithRangeMutableConcreteData:(NSRange)range
{
    id object=nil;
    @try {
        object =  [self safe_subdataWithRangeMutableConcreteData:range];
    }
    @catch (NSException *exception) {
        XYYSafeProtectionCrashLog(exception,XYYSafeProtectorCrashTypeNSMutableData);
    }
    @finally {
        return object;
    }
}

-(NSRange)safe_rangeOfDataMutableConcreteData:(NSData *)dataToFind options:(NSDataSearchOptions)mask range:(NSRange)searchRange
{
    NSRange object;
    @try {
        object =  [self safe_rangeOfDataMutableConcreteData:dataToFind options:mask range:searchRange];
    }
    @catch (NSException *exception) {
        XYYSafeProtectionCrashLog(exception,XYYSafeProtectorCrashTypeNSMutableData);
    }
    @finally {
        return object;
    }
}

- (void)safe_resetBytesInRange:(NSRange)range
{
    @try {
        [self safe_resetBytesInRange:range];
    }
    @catch (NSException *exception) {
        XYYSafeProtectionCrashLog(exception,XYYSafeProtectorCrashTypeNSMutableData);
    }
    @finally {
    }
}


- (void)safe_replaceBytesInRange:(NSRange)range withBytes:(const void *)bytes
{
    @try {
        [self safe_replaceBytesInRange:range withBytes:bytes];
    }
    @catch (NSException *exception) {
        XYYSafeProtectionCrashLog(exception,XYYSafeProtectorCrashTypeNSMutableData);
    }
    @finally {
    }
}

- (void)safe_replaceBytesInRange:(NSRange)range withBytes:(const void *)replacementBytes length:(NSUInteger)replacementLength
{
    @try {
        [self safe_replaceBytesInRange:range withBytes:replacementBytes length:replacementLength];
    }
    @catch (NSException *exception) {
        XYYSafeProtectionCrashLog(exception,XYYSafeProtectorCrashTypeNSMutableData);
    }
    @finally {
    }
}




@end
