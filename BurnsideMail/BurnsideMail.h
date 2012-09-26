//
//  BurnsideMail.h
//  BurnsideMail
//
//  Created by Wade Cosgrove on 9/19/12.
//  Copyright (c) 2012 Wade Cosgrove. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BurnsideMail : NSObject

@end

@interface NSView (PanicMailAdditions)

- (void)pc_logSubviews;
- (NSView*)pc_findSubviewWithClass:(Class)class;

@end


@interface NSObject (TruePreviewObject)

#pragma mark Class methods
/*! @group Class methods */

/*!
 * Adds the methods from this class to the specified class.  This is in essence
 * adding a category, but we do it through the objective-c runtime, because of
 * the "hiding" of classes in >= 10.6.
 * @param inClass
 *   The <code>Class</code> to which this class's methods should be added.
 */
+ (void)truePreviewAddAsCategoryToClass:(Class)inClass;

/*!
 * Swaps ("swizzles") two methods.  Based on
 * <a href="http://www.cocoadev.com/index.pl?MethodSwizzling">http://www.cocoadev.com/index.pl?MethodSwizzling</a>.
 * @param inOriginalSelector
 *   The selector specifying the method being replaced.
 * @param inReplacementSelector
 *   The selector specifying the replacement method.
 * @param inIsClassMethod
 *   The <code>BOOL</code> indicating whether or not the methods being swizzled
 *   are class methods.
 */
+ (void)truePreviewSwizzleMethod:(SEL)inOriginalSelector withMethod:(SEL)inReplacementSelector isClassMethod:(BOOL)inIsClassMethod;

@end