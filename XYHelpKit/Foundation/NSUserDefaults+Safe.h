//
//  NSUserDefaults+Safe.h
//  FBSnapshotTestCase
//
//  Created by 高洪成 on 2020/4/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
可避免以下方法  key=nil时的crash
    1.objectForKey:
    2.stringForKey:
    3.arrayForKey:
    4.dataForKey:
    5.URLForKey:
    6.stringArrayForKey:
    7.floatForKey:
    8.doubleForKey:
    9.integerForKey:
    10.boolForKey:
    11.setObject:forKey:
*/

@interface NSUserDefaults (Safe)

@end

NS_ASSUME_NONNULL_END
