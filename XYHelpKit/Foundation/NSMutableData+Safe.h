//
//  NSMutableData+Safe.h
//  FBSnapshotTestCase
//
//  Created by 高洪成 on 2020/4/23.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/*
可防止以下crash
 1.subdataWithRange:
 2.rangeOfData:options:range:
 3.resetBytesInRange:
 4.replaceBytesInRange:withBytes:
 5.replaceBytesInRange:withBytes:length:
 
 */

@interface NSMutableData (Safe)

@end

NS_ASSUME_NONNULL_END
