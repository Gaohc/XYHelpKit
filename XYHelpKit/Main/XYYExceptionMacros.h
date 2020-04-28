//
//  XYYExceptionMacros.h
//  Pods
//
//  Created by 高洪成 on 2020/4/28.
//

#ifndef XYYExceptionMacros_h
#define XYYExceptionMacros_h

/**
 Add this macro before each category implementation, so we don't have to use
 -all_load or -force_load to load object files from static libraries that only
 contain categories and no classes.
 *******************************************************************************
 Example:
 XYYSYNTH_DUMMY_CLASS(NSObject_DeallocBlock)
 */
#ifndef XYYSYNTH_DUMMY_CLASS
#define XYYSYNTH_DUMMY_CLASS(_name_) \
@interface XYYSYNTH_DUMMY_CLASS_ ## _name_ : NSObject @end \
@implementation XYYSYNTH_DUMMY_CLASS_ ## _name_ @end
#endif

#endif /* XYYExceptionMacros_h */
