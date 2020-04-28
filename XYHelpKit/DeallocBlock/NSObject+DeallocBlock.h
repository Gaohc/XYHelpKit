//
//  NSObject+DeallocBlock.h
//  XYYException
//
//  Created by 高洪成 on 2020/4/28.
//

#import <Foundation/Foundation.h>

@interface NSObject (DeallocBlock)

/**
 Observer current instance class dealloc action

 @param block dealloc callback
 */
- (void)XYY_deallocBlock:(void(^)(void))block;

@end
