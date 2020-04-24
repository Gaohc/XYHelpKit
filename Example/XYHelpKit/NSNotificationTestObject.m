//
//  NSNotificationTestObject.m
//  XYHelpKit_Example
//
//  Created by 高洪成 on 2020/4/24.
//  Copyright © 2020 gaohongcheng. All rights reserved.
//

#import "NSNotificationTestObject.h"

@implementation NSNotificationTestObject
-(void)handle:(NSNotification*)note
{
    NSLog(@"11111111");
}
-(void)dealloc
{
    NSLog(@"%@  dealloc",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"name"];
//    [self removeObserver:self.kvo forKeyPath:@"name"];
    [self removeObserver:self forKeyPath:@"kvoTest"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    id con=(__bridge id)(context);
    NSLog(@"11111111%@",con);
}

@end
