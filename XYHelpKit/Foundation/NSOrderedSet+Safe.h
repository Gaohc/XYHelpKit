//
//  NSOrderedSet+Safe.h
//  FBSnapshotTestCase
//
//  Created by 高洪成 on 2020/4/23.
//

#import <AppKit/AppKit.h>


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
可避免以下crash

1.orderedSetWithSet
2.initWithObjects:count:
3.objectAtIndex:

*/

@interface NSOrderedSet (Safe)

@end

NS_ASSUME_NONNULL_END
