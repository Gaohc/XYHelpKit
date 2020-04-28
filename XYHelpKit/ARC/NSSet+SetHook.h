//
//  NSSet+SetHook.h
//  XYYException
//
//  Created by 高洪成 on 2020/4/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSSet (SetHook)

+ (void)XYY_swizzleNSSet;

@end

NS_ASSUME_NONNULL_END
