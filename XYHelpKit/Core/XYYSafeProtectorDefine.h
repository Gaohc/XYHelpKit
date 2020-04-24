//
//  XYYSafeProtectorDefine.h
//  Pods
//
//  Created by 高洪成 on 2020/4/23.
//

#ifndef XYYSafeProtectorDefine_h
#define XYYSafeProtectorDefine_h
@class XYYSafeProtector;

#define  XYYSafeLog(fmt, ...)  NSLog(fmt, ##__VA_ARGS__)
#define  XYYSafeProtectionCrashLog(exception,crash)   [XYYSafeProtector safe_logCrashWithException:exception crashType:crash]

typedef enum: NSInteger{
    XYYSafeProtectorLogTypeNone,//所有log都不打印
    XYYSafeProtectorLogTypeAll,//打印所有log
}XYYSafeProtectorLogType;

//哪个类型的crash
typedef NS_OPTIONS(NSInteger,XYYSafeProtectorCrashType){
    
      XYYSafeProtectorCrashTypeSelector                  = 1 << 0,
      XYYSafeProtectorCrashTypeKVO                       = 1 << 1,
      XYYSafeProtectorCrashTypeNSNotificationCenter      = 1 << 2,
      XYYSafeProtectorCrashTypeNSUserDefaults            = 1 << 3,
      XYYSafeProtectorCrashTypeNSCache                   = 1 << 4,
      
      XYYSafeProtectorCrashTypeNSArray                   = 1 << 5,
      XYYSafeProtectorCrashTypeNSMutableArray            = 1 << 6,
      
      XYYSafeProtectorCrashTypeNSDictionary              = 1 << 7,
      XYYSafeProtectorCrashTypeNSMutableDictionary       = 1 << 8,
      
      XYYSafeProtectorCrashTypeNSStirng                  = 1 << 9,
      XYYSafeProtectorCrashTypeNSMutableString           = 1 << 10,
      
      XYYSafeProtectorCrashTypeNSAttributedString        = 1 << 11,
      XYYSafeProtectorCrashTypeNSMutableAttributedString = 1 << 12,
      
      XYYSafeProtectorCrashTypeNSSet                     = 1 << 13,
      XYYSafeProtectorCrashTypeNSMutableSet              = 1 << 14,
      
      XYYSafeProtectorCrashTypeNSData                    = 1 << 15,
      XYYSafeProtectorCrashTypeNSMutableData             = 1 << 16,
      
      XYYSafeProtectorCrashTypeNSOrderedSet              = 1 << 17,
      XYYSafeProtectorCrashTypeNSMutableOrderedSet       = 1 << 18,
      
      XYYSafeProtectorCrashTypeNSArrayContainer = XYYSafeProtectorCrashTypeNSArray|XYYSafeProtectorCrashTypeNSMutableArray,
      
      XYYSafeProtectorCrashTypeNSDictionaryContainer = XYYSafeProtectorCrashTypeNSDictionary| XYYSafeProtectorCrashTypeNSMutableDictionary,
      
      XYYSafeProtectorCrashTypeNSStringContainer = XYYSafeProtectorCrashTypeNSStirng|XYYSafeProtectorCrashTypeNSMutableString,
      
      XYYSafeProtectorCrashTypeNSAttributedStringContainer = XYYSafeProtectorCrashTypeNSAttributedString|XYYSafeProtectorCrashTypeNSMutableAttributedString,
      
      XYYSafeProtectorCrashTypeNSSetContainer = XYYSafeProtectorCrashTypeNSSet|XYYSafeProtectorCrashTypeNSMutableSet,
      
      XYYSafeProtectorCrashTypeNSDataContainer = XYYSafeProtectorCrashTypeNSData|XYYSafeProtectorCrashTypeNSMutableData,
      
      XYYSafeProtectorCrashTypeNSOrderedSetContainer = XYYSafeProtectorCrashTypeNSOrderedSet|XYYSafeProtectorCrashTypeNSMutableOrderedSet,
      
      XYYSafeProtectorCrashTypeAll =
           //支持所有类型的crash
       XYYSafeProtectorCrashTypeSelector
       |XYYSafeProtectorCrashTypeKVO
       |XYYSafeProtectorCrashTypeNSNotificationCenter
       |XYYSafeProtectorCrashTypeNSUserDefaults
       |XYYSafeProtectorCrashTypeNSCache
       |XYYSafeProtectorCrashTypeNSArrayContainer
       |XYYSafeProtectorCrashTypeNSDictionaryContainer
       |XYYSafeProtectorCrashTypeNSStringContainer
       |XYYSafeProtectorCrashTypeNSAttributedStringContainer
       |XYYSafeProtectorCrashTypeNSSetContainer
       |XYYSafeProtectorCrashTypeNSDataContainer
       |XYYSafeProtectorCrashTypeNSOrderedSetContainer
    
};

typedef void(^XYYSafeProtectorBlock)(NSException *exception,XYYSafeProtectorCrashType crashType);

#endif /* XYYSafeProtectorDefine_h */
