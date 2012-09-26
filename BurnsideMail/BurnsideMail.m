//
//  BurnsideMail.m
//  BurnsideMail
//
//  Created by Wade Cosgrove on 9/19/12.
//  Copyright (c) 2012 Wade Cosgrove. All rights reserved.
//

#import "BurnsideMail.h"
#import "BurnsideDocumentEditor.h"
#import "TwitterCharacterCounterViewController.h"

#import <WebKit/WebKit.h>
#import <objc/objc-class.h>

@implementation BurnsideMail

+ (void)initialize
{
	[super initialize];
	
	if (self == [BurnsideMail class])
	{
		class_setSuperclass(self, NSClassFromString(@"MVMailBundle"));
	}

	[self performSelector:@selector(registerBundle)];
  
	[BurnsideDocumentEditor installSwizzles];
}


#pragma mark MVMailBundle class methods

+ (BOOL)hasPreferencesPanel
{
	return NO;
}

/*
- (void)messageWillBeDisplayedInView:(id)arg1
{
	//NSLog(@"message will be displayed %@", arg1);
}


+ (id)composeAccessoryViewOwnerClassName
{
	NSLog(@"composeAccessoryViewOwnerClassName");
	
	return @"TwitterComposeViewController";
}


+ (id)composeAccessoryViewOwners
{
	NSLog(@"composeAccessoryViewOwners");
	
	return nil;// [TwitterComposeViewController owners];
}
*/

+ (BOOL)hasComposeAccessoryViewOwner
{
	return NO;
}

/*
- (BOOL)showComposeAccessoryView
{
	NSLog(@"showComposeAccessoryView");
	return YES;
}
*/

/*
@interface MVComposeAccessoryViewOwner : NSObject
{
    NSView *_accessoryView;
}

+ (id)composeAccessoryViewNibName;
+ (id)composeAccessoryViewOwner;
- (BOOL)messageWillBeSaved:(id)arg1;
- (BOOL)messageWillBeDelivered:(id)arg1;
- (id)composeAccessoryView;
- (void)setupUIForMessage:(id)arg1;

@end
*/

@end

@implementation NSView (LogSubviews)

- (void)pc_logSubviews
{
	static NSInteger indentLevel = 0;
	
	for ( NSView *view in [self subviews] )
	{
		NSMutableString *indentedString = [NSMutableString stringWithString:[view description]];
		NSUInteger i;
		
		for ( i = 0; i < indentLevel; i++ )
			[indentedString insertString:@" " atIndex:0];
		
		indentLevel++;
		
		[view pc_logSubviews];
	}
	
	indentLevel--;
}


- (NSView*)pc_findSubviewWithClass:(Class)class
{
	NSView *outView = nil;
	
	for ( NSView *view in [self subviews] )
	{
		if ( [view isKindOfClass:class] )
			outView = view;

		if ( outView == nil )
			outView = [view pc_findSubviewWithClass:class];
		
		if ( outView != nil )
			break;
	}
	
	return outView;
}

@end


@implementation NSObject (TruePreviewObject)

#pragma mark Class methods

+ (void)truePreviewAddAsCategoryToClass:(Class)inClass
{
  unsigned int theCount = 0;
  Method* theMethods = class_copyMethodList(object_getClass([self class]), &theCount);
  Class theClass = object_getClass(inClass);
  unsigned int i = 0;
  
  while (YES) {
    for (i = 0; i < theCount; i++) {
      if (
        !class_addMethod(
          theClass,
          method_getName(theMethods[i]),
          method_getImplementation(theMethods[i]),
          method_getTypeEncoding(theMethods[i])
        )
      ) {
        NSLog(
          @"truePreviewAddAsCategoryToClass: could not add %@ to %@",
          NSStringFromSelector(method_getName(theMethods[i])),
          inClass
        );
      }
    }
    
    if (theMethods != nil) {
      free(theMethods);
    }
    
    if (theClass != inClass) {
      theClass = inClass;
      theMethods = class_copyMethodList([self class], &theCount);
    }
    else {
      break;
    }
  }
}

+ (void)truePreviewSwizzleMethod:(SEL)inOriginalSelector withMethod:(SEL)inReplacementSelector isClassMethod:(BOOL)inIsClassMethod {
  Method theOriginalMethod = (!inIsClassMethod
    ? class_getInstanceMethod([self class], inOriginalSelector)
    : class_getClassMethod([self class], inOriginalSelector)
  );
  Method theReplacementMethod = (!inIsClassMethod
    ? class_getInstanceMethod([self class], inReplacementSelector)
    : class_getClassMethod([self class], inReplacementSelector)
  );

  method_exchangeImplementations(theOriginalMethod, theReplacementMethod);
}

@end
