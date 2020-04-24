//
//  NSObject+SafeSwizzle.h
//  FBSnapshotTestCase
//
//  Created by 高洪成 on 2020/4/23.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SafeSwizzle)

//交换对象方法
+ (void)safe_exchangeInstanceMethod:(Class)dClass originalSel:(SEL)originalSelector newSel: (SEL)newSelector;

@end

NS_ASSUME_NONNULL_END
