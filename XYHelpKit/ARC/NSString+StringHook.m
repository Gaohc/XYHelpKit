//
//  NSString+StringHook.m
//  XYYException
//
//  Created by 高洪成 on 2020/4/28.
//

#import "NSString+StringHook.h"
#import "NSObject+SwizzleHook.h"
#import "XYYExceptionProxy.h"
#import "XYYExceptionMacros.h"

XYYSYNTH_DUMMY_CLASS(NSString_StringHook)

@implementation NSString (StringHook)

+ (void)XYY_swizzleNSString{
    [NSString XYY_swizzleClassMethod:@selector(stringWithUTF8String:) withSwizzleMethod:@selector(hookStringWithUTF8String:)];
    [NSString XYY_swizzleClassMethod:@selector(stringWithCString:encoding:) withSwizzleMethod:@selector(hookStringWithCString:encoding:)];
    
    //NSPlaceholderString
    swizzleInstanceMethod(NSClassFromString(@"NSPlaceholderString"), @selector(initWithCString:encoding:), @selector(hookInitWithCString:encoding:));
    swizzleInstanceMethod(NSClassFromString(@"NSPlaceholderString"), @selector(initWithString:), @selector(hookInitWithString:));
    
    //_NSCFConstantString
    swizzleInstanceMethod(NSClassFromString(@"__NSCFConstantString"), @selector(substringFromIndex:), @selector(hookSubstringFromIndex:));
    swizzleInstanceMethod(NSClassFromString(@"__NSCFConstantString"), @selector(substringToIndex:), @selector(hookSubstringToIndex:));
    swizzleInstanceMethod(NSClassFromString(@"__NSCFConstantString"), @selector(substringWithRange:), @selector(hookSubstringWithRange:));
    swizzleInstanceMethod(NSClassFromString(@"__NSCFConstantString"), @selector(rangeOfString:options:range:locale:), @selector(hookRangeOfString:options:range:locale:));
    
    //NSTaggedPointerString
    swizzleInstanceMethod(NSClassFromString(@"NSTaggedPointerString"), @selector(substringFromIndex:), @selector(hookSubstringFromIndex:));
    swizzleInstanceMethod(NSClassFromString(@"NSTaggedPointerString"), @selector(substringToIndex:), @selector(hookSubstringToIndex:));
    swizzleInstanceMethod(NSClassFromString(@"NSTaggedPointerString"), @selector(substringWithRange:), @selector(hookSubstringWithRange:));
    swizzleInstanceMethod(NSClassFromString(@"NSTaggedPointerString"), @selector(rangeOfString:options:range:locale:), @selector(hookRangeOfString:options:range:locale:));
}

+ (NSString*) hookStringWithUTF8String:(const char *)nullTerminatedCString{
    if (NULL != nullTerminatedCString) {
        return [self hookStringWithUTF8String:nullTerminatedCString];
    }
    handleCrashException(XYYExceptionGuardNSStringContainer,@"NSString stringWithUTF8String NULL char pointer");
    return nil;
}

+ (nullable instancetype) hookStringWithCString:(const char *)cString encoding:(NSStringEncoding)enc
{
    if (NULL != cString){
        return [self hookStringWithCString:cString encoding:enc];
    }
    handleCrashException(XYYExceptionGuardNSStringContainer,@"NSString stringWithCString:encoding: NULL char pointer");
    return nil;
}

- (nullable instancetype) hookInitWithString:(id)cString{
    if (nil != cString){
        return [self hookInitWithString:cString];
    }
    handleCrashException(XYYExceptionGuardNSStringContainer,@"NSString initWithString nil parameter");
    return nil;
}

- (nullable instancetype) hookInitWithCString:(const char *)nullTerminatedCString encoding:(NSStringEncoding)encoding{
    if (NULL != nullTerminatedCString){
        return [self hookInitWithCString:nullTerminatedCString encoding:encoding];
    }
    handleCrashException(XYYExceptionGuardNSStringContainer,@"NSString initWithCString:encoding NULL char pointer");
    return nil;
}

- (NSString *)hookSubstringFromIndex:(NSUInteger)from{
    if (from <= self.length) {
        return [self hookSubstringFromIndex:from];
    }
    handleCrashException(XYYExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSString substringFromIndex value:%@ from:%tu",self,from]);
    return nil;
}

- (NSString *)hookSubstringToIndex:(NSUInteger)to{
    if (to <= self.length) {
        return [self hookSubstringToIndex:to];
    }
    handleCrashException(XYYExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSString substringToIndex value:%@ from:%tu",self,to]);
    return self;
}

- (NSString *)hookSubstringWithRange:(NSRange)range{
    if (range.location + range.length <= self.length) {
        return [self hookSubstringWithRange:range];
    }
    handleCrashException(XYYExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSString substringWithRange value:%@ range:%@",self,NSStringFromRange(range)]);
    return nil;
}
- (NSRange)hookRangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask range:(NSRange)range locale:(nullable NSLocale *)locale{
    if (searchString){
        if (range.location + range.length <= self.length) {
            return [self hookRangeOfString:searchString options:mask range:range locale:locale];
        }
        handleCrashException(XYYExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSString rangeOfString:options:range:locale: value:%@ range:%@",self,NSStringFromRange(range)]);
        return NSMakeRange(NSNotFound, 0);
    }else{
        handleCrashException(XYYExceptionGuardNSStringContainer,[NSString stringWithFormat:@"NSString rangeOfString:options:range:locale: searchString nil value:%@ range:%@",self,NSStringFromRange(range)]);
        return NSMakeRange(NSNotFound, 0);
    }
}

@end
