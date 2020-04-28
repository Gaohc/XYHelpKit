//
//  NSObject+UnrecognizedSelectorHook.h
//  XYYException
//
//  Created by 高洪成 on 2020/4/28.
//

#import <Foundation/Foundation.h>

@interface NSObject (UnrecognizedSelectorHook)

+ (void)XYY_swizzleUnrecognizedSelector;

@end
