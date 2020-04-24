//
//  NSAttributedString+Safe.h
//  FBSnapshotTestCase
//
//  Created by 高洪成 on 2020/4/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (Safe)

@end

NS_ASSUME_NONNULL_END
/*

目前可避免以下方法crash
   1.- (instancetype)initWithString:(NSString *)str;
   2.- (instancetype)initWithString:(NSString *)str attributes:(nullable NSDictionary<NSAttributedStringKey, id> *)attrs;
   3.- (instancetype)initWithAttributedString:(NSAttributedString *)attrStr;

*/
