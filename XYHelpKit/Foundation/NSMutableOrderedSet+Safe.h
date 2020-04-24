//
//  NSMutableOrderedSet+Safe.h
//  FBSnapshotTestCase
//
//  Created by 高洪成 on 2020/4/23.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableOrderedSet (Safe)

@end

NS_ASSUME_NONNULL_END

/**
可避免以下crash

1. - (void)addObject:(ObjectType)anObject
2. - (void)insertObject:(ObjectType)anObject atIndex:(NSUInteger)index;
3. - (id)objectAtIndex:(NSUInteger)index( 包含   array[index]  形式  )
4. - (void)removeObjectAtIndex:(NSUInteger)index
5. - (void)replaceObjectAtIndex:(NSUInteger)index

*/
