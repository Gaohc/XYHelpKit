//
//  NSMutableString+Safe.h
//  FBSnapshotTestCase
//
//  Created by 高洪成 on 2020/4/23.
//

#import <AppKit/AppKit.h>


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 
除NSString的一些方法外又额外避免了一些方法crash
 
 1.- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)aString;
 2.- (NSUInteger)replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange;
 3.- (void)insertString:(NSString *)aString atIndex:(NSUInteger)loc;
 4.- (void)deleteCharactersInRange:(NSRange)range;
 5.- (void)appendString:(NSString *)aString;
 6.- (void)setString:(NSString *)aString;
 
*/

@interface NSMutableString (Safe)

@end

NS_ASSUME_NONNULL_END
