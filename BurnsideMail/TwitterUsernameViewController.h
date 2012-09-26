//
//  TwitterUsernameViewController.h
//  BurnsideMail
//
//  Created by Wade Cosgrove on 9/25/12.
//  Copyright (c) 2012 Wade Cosgrove. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TwitterUsernameViewController : NSViewController
{
	NSString *_username;
	IBOutlet NSButton *usernameButton;
}

@property (readwrite, copy) NSString *username;

- (IBAction)jumpToUser:(id)sender;

@end

@interface PCTwitterUsernameValueTransformer : NSValueTransformer
@end