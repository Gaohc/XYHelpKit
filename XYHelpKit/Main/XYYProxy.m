//
//  XYYProxy.m
//  FBSnapshotTestCase
//
//  Created by 高洪成 on 2020/4/27.
//

#import "XYYProxy.h"

@implementation XYYProxy
+(instancetype)proxyWithTarget:(id)target{
    // NSProxy对象不需要调用init，因为它本来就没有init方法
    XYYProxy *proxy = [XYYProxy alloc];
    proxy.target = target;
    return proxy;
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    return [self.target methodSignatureForSelector:aSelector];
}
-(void)forwardInvocation:(NSInvocation *)anInvocation{
    [anInvocation invokeWithTarget:self.target];
}

@end
