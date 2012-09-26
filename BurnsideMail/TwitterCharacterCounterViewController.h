//
//  TwitterCharacterCounterViewController.h
//  BurnsideMail
//
//  Created by Wade Cosgrove on 9/20/12.
//  Copyright (c) 2012 Wade Cosgrove. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PCCountTextField;

@interface TwitterCharacterCounterViewController : NSViewController
{
	NSString *_twitterName;
	NSString *_signature;
	NSUInteger _typedCharacterCount;
	
	IBOutlet PCCountTextField *characterCountField;
}

@property (readwrite, copy) NSString* twitterName;
@property (readwrite, copy) NSString* signature;
@property (readwrite, assign) NSUInteger typedCharacterCount;

@end
