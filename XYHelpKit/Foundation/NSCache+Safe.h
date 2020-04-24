//
//  NSCache+Safe.h
//  FBSnapshotTestCase
//
//  Created by 高洪成 on 2020/4/23.
//

/*
可避免以下crash
setObject:forKey:
setObject:forKey:cost:

*/


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSCache (Safe)

@end

NS_ASSUME_NONNULL_END
