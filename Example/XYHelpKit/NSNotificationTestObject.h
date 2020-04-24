//
//  NSNotificationTestObject.h
//  XYHelpKit_Example
//
//  Created by 高洪成 on 2020/4/24.
//  Copyright © 2020 gaohongcheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYViewTestKVO.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSNotificationTestObject : NSObject
@property (nonatomic,weak) XYViewTestKVO *kvo;
@property (nonatomic,copy)NSString *name;

@end

NS_ASSUME_NONNULL_END
