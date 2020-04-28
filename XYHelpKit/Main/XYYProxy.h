//
//  XYYProxy.h
//  FBSnapshotTestCase
//
//  Created by 高洪成 on 2020/4/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYYProxy : NSProxy
@property(nonatomic,weak)id target;
+(instancetype)proxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
