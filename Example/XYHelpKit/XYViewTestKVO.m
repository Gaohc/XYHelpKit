//
//  XYViewTestKVO.m
//  XYHelpKit_Example
//
//  Created by 高洪成 on 2020/4/24.
//  Copyright © 2020 gaohongcheng. All rights reserved.
//

#import "XYViewTestKVO.h"
@implementation XYViewTestKVO

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"11111111");
}
-(void)dealloc
{
    NSLog(@"dealloc   %@",NSStringFromClass([self class]));
//    [self.con removeObserver:self forKeyPath:@"kvoTest"];
//    [self.con removeObserver:self forKeyPath:@"kvoTest111111"];
//    [self.con removeObserver:self forKeyPath:@"kvoTest2"];
}

@end
