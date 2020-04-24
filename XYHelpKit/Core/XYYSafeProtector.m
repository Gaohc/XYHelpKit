//
//  XYYSafeProtector.m
//  FBSnapshotTestCase
//
//  Created by 高洪成 on 2020/4/23.
//

#import "XYYSafeProtector.h"

static  XYYSafeProtectorLogType XYY_safe_logType=XYYSafeProtectorLogTypeAll;
static  XYYSafeProtectorBlock xyySafeProtectorBlock;
static  BOOL XYYSafeProtectorKVODebugInfoEnable=NO;

@interface NSObject (XYYSafeProtector)
//打开当前类安全保护
+ (void)openSafeProtector;
+ (void)openKVOSafeProtector;
+(void)openMRCSafeProtector;
@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation NSObject (LSSafeProtector)
@end

#pragma clang diagnostic pop


@implementation XYYSafeProtector

+(void)openSafeProtectorWithIsDebug:(BOOL)isDebug block:(XYYSafeProtectorBlock)block
{
    [self openSafeProtectorWithIsDebug:isDebug types: XYYSafeProtectorCrashTypeSelector
     |XYYSafeProtectorCrashTypeNSNotificationCenter
     |XYYSafeProtectorCrashTypeNSUserDefaults
     |XYYSafeProtectorCrashTypeNSCache
     |XYYSafeProtectorCrashTypeNSArrayContainer
     |XYYSafeProtectorCrashTypeNSDictionaryContainer
     |XYYSafeProtectorCrashTypeNSStringContainer
     |XYYSafeProtectorCrashTypeNSAttributedStringContainer
     |XYYSafeProtectorCrashTypeNSSetContainer
     |XYYSafeProtectorCrashTypeNSDataContainer
     |XYYSafeProtectorCrashTypeNSOrderedSetContainer block:block];
}

+(void)openSafeProtectorWithIsDebug:(BOOL)isDebug types:(XYYSafeProtectorCrashType)types block:(XYYSafeProtectorBlock)block
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (types & XYYSafeProtectorCrashTypeSelector) {
            //开启防止selecetor crash
            [NSObject openSafeProtector];
        }
        if (types & XYYSafeProtectorCrashTypeNSArray) {
            [NSArray openSafeProtector];
        }
        
        if (types & XYYSafeProtectorCrashTypeNSMutableArray) {
            [NSMutableArray openSafeProtector];
            [NSMutableArray openMRCSafeProtector];
        }
        
        if (types & XYYSafeProtectorCrashTypeNSDictionary) {
            [NSDictionary openSafeProtector];
        }
        
        if (types & XYYSafeProtectorCrashTypeNSMutableDictionary) {
            [NSMutableDictionary openSafeProtector];
        }
        
        if (types & XYYSafeProtectorCrashTypeNSStirng) {
            [NSString openSafeProtector];
        }
        
        if (types & XYYSafeProtectorCrashTypeNSMutableString) {
            [NSMutableString openSafeProtector];
        }
        
        if (types & XYYSafeProtectorCrashTypeNSAttributedString) {
            [NSAttributedString openSafeProtector];
        }
        
        if (types & XYYSafeProtectorCrashTypeNSMutableAttributedString) {
            [NSMutableAttributedString openSafeProtector];
        }
        
        if (types & XYYSafeProtectorCrashTypeNSNotificationCenter) {
            [NSNotificationCenter openSafeProtector];
        }
    
        if (types & XYYSafeProtectorCrashTypeKVO) {
            [NSObject openKVOSafeProtector];
        }
        
        if (types & XYYSafeProtectorCrashTypeNSUserDefaults) {
            [NSUserDefaults openSafeProtector];
        }
        
        if (types & XYYSafeProtectorCrashTypeNSCache) {
            [NSCache openSafeProtector];
        }
        
        if (types & XYYSafeProtectorCrashTypeNSSet) {
            [NSSet openSafeProtector];
        }
        
        if (types & XYYSafeProtectorCrashTypeNSMutableSet) {
            [NSMutableSet openSafeProtector];
        }
        
        if (types & XYYSafeProtectorCrashTypeNSOrderedSet) {
            [NSOrderedSet openSafeProtector];
        }
        
        if (types & XYYSafeProtectorCrashTypeNSMutableOrderedSet) {
            [NSMutableOrderedSet openSafeProtector];
        }
        
        if (types & XYYSafeProtectorCrashTypeNSData) {
            [NSData openSafeProtector];
        }
        
        if (types & XYYSafeProtectorCrashTypeNSMutableData) {
            [NSMutableData openSafeProtector];
        }
        
        if (isDebug) {
            XYY_safe_logType=XYYSafeProtectorLogTypeAll;
        }else{
            XYY_safe_logType=XYYSafeProtectorLogTypeNone;
        }
        xyySafeProtectorBlock=block;
    });
}


+ (void)safe_logCrashWithException:(NSException *)exception crashType:(XYYSafeProtectorCrashType)crashType
{
    // 堆栈数据
    NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
    
    //获取在哪个类的哪个方法中实例化的数组
    NSString *mainMessage = [self safe_getMainCallStackSymbolMessageWithCallStackSymbolArray: callStackSymbolsArr index:2 first:YES];
    
    if (mainMessage == nil) {
        mainMessage = @"崩溃方法定位失败,请您查看函数调用栈来查找crash原因";
    }
    
    NSString *crashName = [NSString stringWithFormat:@"\t\t[Crash Type]: %@",exception.name];
    
    NSString *crashReason = [NSString stringWithFormat:@"\t\t[Crash Reason]: %@",exception.reason];;
    NSString *crashLocation = [NSString stringWithFormat:@"\t\t[Crash Location]: %@",mainMessage];
    
    NSString *fullMessage = [NSString stringWithFormat:@"\n------------------------------------  Crash START -------------------------------------\n%@\n%@\n%@\n函数堆栈:\n%@\n------------------------------------   Crash END  -----------------------------------------", crashName, crashReason, crashLocation, exception.callStackSymbols];
    
    NSMutableDictionary *userInfo=[NSMutableDictionary dictionary];
    userInfo[@"callStackSymbols"]=[NSString stringWithFormat:@"%@",exception.callStackSymbols];
    userInfo[@"location"]=mainMessage;
    NSException *newException = [NSException exceptionWithName:exception.name reason:exception.reason userInfo:userInfo];
    if (xyySafeProtectorBlock) {
        xyySafeProtectorBlock(newException,crashType);
    }
    XYYSafeProtectorLogType logType=XYY_safe_logType;
    if (logType==XYYSafeProtectorLogTypeNone) {
    }
    else if (logType==XYYSafeProtectorLogTypeAll) {
        XYYSafeLog(@"%@", fullMessage);
        assert(NO&&"检测到崩溃，详情请查看上面信息");
    }
}

#pragma mark -   获取堆栈主要崩溃精简化的信息<根据正则表达式匹配出来
+ (NSString *)safe_getMainCallStackSymbolMessageWithCallStackSymbolArray:(NSArray *)callStackSymbolArray index:(NSInteger)index first:(BOOL)first
{
    NSString *  callStackSymbolString;
    if (callStackSymbolArray.count<=0) {
        return nil;
    }
    if (index<callStackSymbolArray.count) {
        callStackSymbolString=callStackSymbolArray[index];
    }
    //正则表达式
    //http://www.jianshu.com/p/b25b05ef170d
    
    //mainCallStackSymbolMsg 的格式为   +[类名 方法名]  或者 -[类名 方法名]
    __block NSString *mainCallStackSymbolMsg = nil;
    
    //匹配出来的格式为 +[类名 方法名]  或者 -[类名 方法名]
    NSString *regularExpStr = @"[-\\+]\\[.+\\]";
    
    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    [regularExp enumerateMatchesInString:callStackSymbolString options:NSMatchingReportProgress range:NSMakeRange(0, callStackSymbolString.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result) {
            mainCallStackSymbolMsg = [callStackSymbolString substringWithRange:result.range];
            *stop = YES;
        }
    }];
    if (index==0) {
        return mainCallStackSymbolMsg;
    }
    if (mainCallStackSymbolMsg==nil) {
        NSInteger newIndex=0;
        if (first) {
            newIndex=callStackSymbolArray.count-1;
        }else{
            newIndex=index-1;
        }
        mainCallStackSymbolMsg = [self safe_getMainCallStackSymbolMessageWithCallStackSymbolArray:callStackSymbolArray index:newIndex first:NO];
    }
    return mainCallStackSymbolMsg;
}
void safe_KVOCustomLog(NSString *format,...)
{
    if (XYYSafeProtectorKVODebugInfoEnable) {
        va_list args;
        va_start(args, format);
        NSString *string = [[NSString alloc] initWithFormat:format arguments:args];
        NSString *strFormat = [NSString stringWithFormat:@"%@",string];
        NSLogv(strFormat, args);
        va_end(args);
    }
}
+(void)setLogEnable:(BOOL)enable
{
    XYYSafeProtectorKVODebugInfoEnable=enable;
}
@end
