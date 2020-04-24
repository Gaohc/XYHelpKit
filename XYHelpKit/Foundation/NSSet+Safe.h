//
//  NSSet+Safe.h
//  FBSnapshotTestCase
//
//  Created by 高洪成 on 2020/4/23.
//

/*
可避免以下crash
1.setWithObject:
2.(instancetype)initWithObjects:(ObjectType)firstObj
3.setWithObjects:(ObjectType)firstObj
*/


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSSet (Safe)

@end

NS_ASSUME_NONNULL_END
