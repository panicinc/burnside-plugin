//
//  TwitterInspectorBarController.h
//  BurnsideMail
//
//  Created by Wade Cosgrove on 9/21/12.
//  Copyright (c) 2012 Wade Cosgrove. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TwitterCharacterCounterViewController;
@class TwitterUsernameViewController;


@interface TwitterInspectorBarController : NSObject
{
	TwitterCharacterCounterViewController *_characterCounterViewController;
	TwitterUsernameViewController *_usernameViewController;
}

- (void)installInspectorIntoWindow:(NSWindow*)window;

@property (readwrite, retain) TwitterCharacterCounterViewController *characterCounterViewController;
@property (readwrite, retain) TwitterUsernameViewController *usernameViewController;

@end
