//
//  TwitterUsernameViewController.m
//  BurnsideMail
//
//  Created by Wade Cosgrove on 9/25/12.
//  Copyright (c) 2012 Wade Cosgrove. All rights reserved.
//

#import "TwitterUsernameViewController.h"

@interface TwitterUsernameViewController ()

@end

@implementation TwitterUsernameViewController

@synthesize username = _username;

- (void)dealloc
{
	[usernameButton unbind:@"title"];
	[_username release];
	
	[super dealloc];
}


- (void)loadView
{
	[super loadView];

	PCTwitterUsernameValueTransformer *transformer = [[[PCTwitterUsernameValueTransformer alloc] init] autorelease];
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSValidatesImmediatelyBindingOption, transformer, NSValueTransformerBindingOption, nil];
	[usernameButton bind:@"title" toObject:self withKeyPath:@"username" options:options];
}


- (IBAction)jumpToUser:(id)sender
{
	if ( self.username != nil )
	{
		NSString *twitterURL = [NSString stringWithFormat:@"http://www.twitter.com/%@", self.username];
		
		if ( twitterURL != nil )
			[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:twitterURL]];
	}
}

@end


@implementation PCTwitterUsernameValueTransformer


+ (Class)transformedValueClass
{
    return [NSString class];
}


+ (BOOL)allowsReverseTransformation
{
    return NO;
}


- (id)transformedValue:(id)aValue
{
    if ( ![aValue isKindOfClass:[NSString class]] )
		return nil;
	
	return [NSString stringWithFormat:@"@%@", aValue];
}

@end