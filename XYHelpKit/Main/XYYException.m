//
//  XYYException.m
//  FBSnapshotTestCase
//
//  Created by 高洪成 on 2020/4/28.
//

#import "XYYException.h"
#import "XYYExceptionProxy.h"

@implementation XYYException

+ (BOOL)isGuardException {
    return [XYYExceptionProxy shareExceptionProxy].isProtectException;
}

+ (BOOL)exceptionWhenTerminate{
    return [XYYExceptionProxy shareExceptionProxy].exceptionWhenTerminate;
}

+ (void)setExceptionWhenTerminate:(BOOL)exceptionWhenTerminate{
    [XYYExceptionProxy shareExceptionProxy].exceptionWhenTerminate = exceptionWhenTerminate;
}

+ (void)startGuardException{
    [XYYExceptionProxy shareExceptionProxy].isProtectException =YES;
}

+ (void)stopGuardException{
    [XYYExceptionProxy shareExceptionProxy].isProtectException = NO;
}

+ (void)configExceptionCategory:(XYYExceptionGuardCategory)exceptionGuardCategory{
    [XYYExceptionProxy shareExceptionProxy].exceptionGuardCategory = exceptionGuardCategory;
}

+ (void)registerExceptionHandle:(id<XYYExceptionHandle>)exceptionHandle{
    [XYYExceptionProxy shareExceptionProxy].delegate = exceptionHandle;
}

+ (void)addZombieObjectArray:(NSArray*)objects{
    [[XYYExceptionProxy shareExceptionProxy] addZombieObjectArray:objects];
}

@end
