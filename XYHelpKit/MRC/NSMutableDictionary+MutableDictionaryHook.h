//
//  NSMutableDictionary+MutableDictionaryHook.h
//  XYYException
//
//  Created by 高洪成 on 2020/4/28.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (MutableDictionaryHook)

+ (void)XYY_swizzleNSMutableDictionary;

@end
