//
//  NSData+Safe.h
//  FBSnapshotTestCase
//
//  Created by 高洪成 on 2020/4/23.
//

#import <AppKit/AppKit.h>


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Safe)

@end

NS_ASSUME_NONNULL_END

/*
1. _NSZeroData
   [NSData data]空data
 
2.NSConcreteMutableData
   [NSMutableData data];
 
3.NSConcreteData
   [NSJSONSerialization dataWithJSONObject:[NSMutableDictionary dictionary] options:0 error:nil]
 
4._NSInlineData
     [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:@"https://www.baidu.com/"]]
 
5.__NSCFData
*/

/*
 可防止以下crash
 1.subdataWithRange
 2.rangeOfData:options:range:
 
 */
