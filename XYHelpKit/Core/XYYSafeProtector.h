//
//  XYYSafeProtector.h
//  FBSnapshotTestCase
//
//  Created by 高洪成 on 2020/4/23.
//

#import <Foundation/Foundation.h>
#import "XYYSafeProtectorDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYYSafeProtector : NSObject


/**
打开目前所支持的所有安全保护(但不包含KVO防护，如果需要开启包含KVO在内的所有防护，需要使用下面的方法，设置types为：XYYSafeProtectorCrashTypeAll)
 
 @param isDebug
 //isDebug=YES 代表测试环境，当捕获到crash时会利用断言闪退， 同时回调block
 //isDebug=NO  代表正式环境，当捕获到crash时不会利用断言闪退，会回调block
 @param block  回调的block
 */
+ (void)openSafeProtectorWithIsDebug:(BOOL)isDebug block:(XYYSafeProtectorBlock)block;

/**
开启防止指定类型的crash

 @param isDebug
 //isDebug=YES 代表测试环境，当捕获到crash时会利用断言闪退， 同时回调block
 //isDebug=NO  代表正式环境，当捕获到crash时不会利用断言闪退，会回调block
 @param types 想防止哪些类crash
 @param block 回调的block
 */
+ (void)openSafeProtectorWithIsDebug:(BOOL)isDebug types:(XYYSafeProtectorCrashType)types block:(XYYSafeProtectorBlock)block;
+ (void)safe_logCrashWithException:(NSException *)exception crashType:(XYYSafeProtectorCrashType)crashType;

//是否开启KVO添加移除日志信息，默认为NO
+ (void)setLogEnable:(BOOL)enable;
//自定义log函数
void safe_KVOCustomLog(NSString *format,...);




@end

NS_ASSUME_NONNULL_END
