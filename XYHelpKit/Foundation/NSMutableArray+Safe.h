//
//  NSMutableArray+Safe.h
//  XYHelpKit_Example
//
//  Created by 高洪成 on 2020/4/23.
//  Copyright © 2020 gaohongcheng. All rights reserved.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (Safe)

@end

NS_ASSUME_NONNULL_END
/**
   可避免以下crash
 
   1. - (void)addObject:(ObjectType)anObject(实际调用insertObject:)
   2. - (void)insertObject:(ObjectType)anObject atIndex:(NSUInteger)index;
   3. - (id)objectAtIndex:(NSUInteger)index( 包含   array[index]  形式  )
   4. - (void)removeObjectAtIndex:(NSUInteger)index
   5. - (void)replaceObjectAtIndex:(NSUInteger)index
   6. - (void)removeObjectsInRange:(NSRange)range
   7. - (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray*)otherArray;
 
*/
