//
//  NSMutableString+MutableStringHook.m
//  XYYException
//
//  Created by 高洪成 on 2020/4/28.
//

#import "NSMutableString+MutableStringHook.h"
#import "NSObject+SwizzleHook.h"
#import "XYYExceptionProxy.h"
#import "XYYExceptionMacros.h"

XYYSYNTH_DUMMY_CLASS(NSMutableString_MutableStringHook)

@implementation NSMutableString (MutableStringHook)

+ (void)XYY_swizzleNSMutableString{
    //__NSCFString
    swizzleInstanceMethod(NSClassFromString(@"__NSCFString"), @selector(appendString:), @selector(hookAppendString:));
    swizzleInstanceMethod(NSClassFromString(@"__NSCFString"), @selector(insertString:atIndex:), @selector(hookInsertString:atIndex:));
    swizzleInstanceMethod(NSClassFromString(@"__NSCFString"), @selector(deleteCharactersInRange:), @selector(hookDeleteCharactersInRange:));
    swizzleInstanceMethod(NSClassFromString(@"__NSCFString"), @selector(substringFromIndex:), @selector(hookSubstringFromIndex:));
    swizzleInstanceMethod(NSClassFromString(@"__NSCFString"), @selector(substringToIndex:), @selector(hookSubstringToIndex:));
    swizzleInstanceMethod(NSClassFromString(@"__NSCFString"), @selector(substringWithRange:), @selector(hookSubstringWithRange:));
    
}

- (void) hookAppendString:(NSString *)aString{
    if (aString){
        [self hookAppendString:aString];
    }else{
        handleCrashException(XYYExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSMutableString appendString value:%@ parameter nil",self]);
    }
}

- (void) hookInsertString:(NSString *)aString atIndex:(NSUInteger)loc{
    if (aString && loc <= self.length) {
        [self hookInsertString:aString atIndex:loc];
    }else{
        handleCrashException(XYYExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSMutableString insertString:atIndex: value:%@ paremeter string:%@ atIndex:%tu",self,aString,loc]);
    }
}

- (void) hookDeleteCharactersInRange:(NSRange)range{
    if (range.location + range.length <= self.length){
        [self hookDeleteCharactersInRange:range];
    }else{
        handleCrashException(XYYExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSMutableString deleteCharactersInRange value:%@ range:%@",self,NSStringFromRange(range)]);
    }
}

- (NSString *)hookSubstringFromIndex:(NSUInteger)from{
    if (from <= self.length) {
        return [self hookSubstringFromIndex:from];
    }
    handleCrashException(XYYExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSMutableString substringFromIndex value:%@ from:%tu",self,from]);
    return nil;
}

- (NSString *)hookSubstringToIndex:(NSUInteger)to{
    if (to <= self.length) {
        return [self hookSubstringToIndex:to];
    }
    handleCrashException(XYYExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSMutableString substringToIndex value:%@ to:%tu",self,to]);
    return self;
}

- (NSString *)hookSubstringWithRange:(NSRange)range{
    if (range.location + range.length <= self.length) {
        return [self hookSubstringWithRange:range];
    }
    handleCrashException(XYYExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSMutableString substringWithRange value:%@ range:%@",self,NSStringFromRange(range)]);
    return nil;
}

@end
