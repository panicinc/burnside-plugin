//
//  TwitterCharacterCounterViewController.m
//  BurnsideMail
//
//  Created by Wade Cosgrove on 9/20/12.
//  Copyright (c) 2012 Wade Cosgrove. All rights reserved.
//

#import "TwitterCharacterCounterViewController.h"
#import "PCCountTextField.h"
#import <objc/objc-class.h>

@implementation TwitterCharacterCounterViewController

@synthesize twitterName = _twitterName;
@synthesize signature = _signature;
@synthesize typedCharacterCount = _typedCharacterCount;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	if ( self )
	{
		[self addObserver:self forKeyPath:@"twitterName" options:0 context:nil];
		[self addObserver:self forKeyPath:@"signature" options:0 context:nil];
		[self addObserver:self forKeyPath:@"typedCharacterCount" options:0 context:nil];
	}
	
	return self;
}


- (void)dealloc
{
	[self removeObserver:self forKeyPath:@"twitterName"];
	[self removeObserver:self forKeyPath:@"signature"];
	[self removeObserver:self forKeyPath:@"typedCharacterCount"];

	[_twitterName release];
	[_signature release];
		
	[super dealloc];
}


- (void)loadView
{
	[super loadView];

	[self willChangeValueForKey:@"twitterName"];
	[self didChangeValueForKey:@"twitterName"];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ( object == self )
	{
		NSInteger characterCount = [self.twitterName length];
		characterCount += [self.signature length];
		characterCount += self.typedCharacterCount;
		
		[characterCountField setStringValue:[[NSNumber numberWithInteger:characterCount] stringValue]];
	}
}


@end
