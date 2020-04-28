//
//  XYYException.h
//  FBSnapshotTestCase
//
//  Created by 高洪成 on 2020/4/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Before start XYYException,must config the XYYExceptionGuardCategory
 
 - XYYExceptionGuardNone: Do not guard normal crash exception
 - XYYExceptionGuardUnrecognizedSelector: Unrecognized Selector Exception
 - XYYExceptionGuardDictionaryContainer: NSDictionary,NSMutableDictionary
 - XYYExceptionGuardArrayContainer: NSArray,NSMutableArray
 - XYYExceptionGuardZombie: Zombie
 - XYYExceptionGuardKVOCrash: KVO exception
 - XYYExceptionGuardNSTimer: NSTimer
 - XYYExceptionGuardNSNotificationCenter: NSNotificationCenter
 - XYYExceptionGuardNSStringContainer:NSString,NSMutableString,NSAttributedString,NSMutableAttributedString
 - XYYExceptionGuardAllExceptZombie:Above All except Zombie
 - XYYExceptionGuardAll: Above All
 */
typedef NS_OPTIONS(NSInteger,XYYExceptionGuardCategory){
    XYYExceptionGuardNone = 0,
    XYYExceptionGuardUnrecognizedSelector = 1 << 1,
    XYYExceptionGuardDictionaryContainer = 1 << 2,
    XYYExceptionGuardArrayContainer = 1 << 3,
    XYYExceptionGuardZombie = 1 << 4,
    XYYExceptionGuardKVOCrash = 1 << 5,
    XYYExceptionGuardNSTimer = 1 << 6,
    XYYExceptionGuardNSNotificationCenter = 1 << 7,
    XYYExceptionGuardNSStringContainer = 1 << 8,
    
    XYYExceptionGuardAllExceptZombie = XYYExceptionGuardUnrecognizedSelector | XYYExceptionGuardDictionaryContainer | XYYExceptionGuardArrayContainer | XYYExceptionGuardKVOCrash | XYYExceptionGuardNSTimer | XYYExceptionGuardNSNotificationCenter | XYYExceptionGuardNSStringContainer,
    
    XYYExceptionGuardAll = XYYExceptionGuardUnrecognizedSelector | XYYExceptionGuardDictionaryContainer | XYYExceptionGuardArrayContainer | XYYExceptionGuardZombie | XYYExceptionGuardKVOCrash | XYYExceptionGuardNSTimer | XYYExceptionGuardNSNotificationCenter | XYYExceptionGuardNSStringContainer,
};

/**
 Exception interface
 */
@protocol XYYExceptionHandle<NSObject>

/**
 Crash message and extra info from current thread
 
 @param exceptionMessage crash message
 @param info extraInfo,key and value
 */
- (void)handleCrashException:(NSString*)exceptionMessage extraInfo:(nullable NSDictionary*)info;

@optional

/**
 Crash message,exceptionCategory, extra info from current thread
 
 @param exceptionMessage crash message
 @param exceptionCategory XYYExceptionGuardCategory
 @param info extra info
 */
- (void)handleCrashException:(NSString*)exceptionMessage exceptionCategory:(XYYExceptionGuardCategory)exceptionCategory extraInfo:(nullable NSDictionary*)info;

@end

/**
 Exception main
 */
@interface XYYException : NSObject


/**
 If exceptionWhenTerminate YES,the exception will stop application
 If exceptionWhenTerminate NO,the exception only show log on the console, will not stop the application
 Default value:NO
 */
@property(class,nonatomic,readwrite,assign)BOOL exceptionWhenTerminate;

/**
 XYYException guard exception status,default is NO
 */
@property(class,nonatomic,readonly,assign)BOOL isGuardException;

/**
 Config the guard exception category,default:XYYExceptionGuardNone
 
 @param exceptionGuardCategory XYYExceptionGuardCategory
 */
+ (void)configExceptionCategory:(XYYExceptionGuardCategory)exceptionGuardCategory;

/**
 Start the exception protect
 */
+ (void)startGuardException;

/**
 Stop the exception protect
 
 * Why deprecated this method:
 */
+ (void)stopGuardException __attribute__((deprecated("Stop invoke this method,If invoke this,Maybe occur the infinite loop and then CRASH")));

/**
 Register exception interface

 @param exceptionHandle XYYExceptionHandle
 */
+ (void)registerExceptionHandle:(id<XYYExceptionHandle>)exceptionHandle;

/**
 Only handle the black list zombie object
 
 Sample Code:
 
    [XYYException addZombieObjectArray:@[TestZombie.class]];

 @param objects Class Array
 */
+ (void)addZombieObjectArray:(NSArray*)objects;

@end

NS_ASSUME_NONNULL_END
