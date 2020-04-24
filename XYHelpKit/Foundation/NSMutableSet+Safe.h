//
//  NSMutableSet+Safe.h
//  FBSnapshotTestCase
//
//  Created by 高洪成 on 2020/4/23.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
可避免以下crash
1.setWithObject:
2.(instancetype)initWithObjects:(ObjectType)firstObj
3.setWithObjects:(ObjectType)firstObj
4.addObject:
5.removeObject:
*/

@interface NSMutableSet (Safe)

@end

NS_ASSUME_NONNULL_END
