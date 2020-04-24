//
//  NSMutableDictionary+Safe.h
//  FBSnapshotTestCase
//
//  Created by 高洪成 on 2020/4/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (Safe)

@end

NS_ASSUME_NONNULL_END

/*
目前可避免以下crash

1.直接调用 setObject:forKey
2.通过下标方式赋值的时候，value为nil不会崩溃
   iOS11之前会调用 setObject:forKey
   iOS11之后（含11)  setObject:forKeyedSubscript:
3.removeObjectForKey


*/
