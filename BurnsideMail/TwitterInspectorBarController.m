//
//  TwitterInspectorBarController
//  BurnsideMail
//
//  Created by Wade Cosgrove on 9/21/12.
//  Copyright (c) 2012 Wade Cosgrove. All rights reserved.
//

#import "TwitterInspectorBarController.h"
#import "TwitterCharacterCounterViewController.h"
#import "TwitterUsernameViewController.h"

@implementation TwitterInspectorBarController

@synthesize characterCounterViewController = _characterCounterViewController;
@synthesize usernameViewController = _usernameViewController;


- (void)dealloc
{
	[_characterCounterViewController release];
	[_usernameViewController release];
	
	[super dealloc];
}


- (void)installInspectorIntoWindow:(NSWindow*)window
{
	if ( [window respondsToSelector:@selector(setInspectorBar:)] )
	{
		Class inspectorClass = NSClassFromString(@"MailInspectorBar");
		if ( inspectorClass )
		{
			id inspectorBar = [[inspectorClass alloc] init];

			[inspectorBar performSelector:@selector(setClient:) withObject:self];
			[inspectorBar performSelector:@selector(setDelegate:) withObject:self];
			
			[window performSelector:@selector(setInspectorBar:) withObject:inspectorBar];
			
			[inspectorBar setShowsBaselineSeparator:NO];
			
			// adjust window height to account for new inspector bar
			NSView *inspectorView = [inspectorBar performSelector:@selector(_inspectorBarView)];
			NSRect frame = [window frame];
			
			frame.size.height -= NSHeight([inspectorView frame]);
			frame.origin.y += NSHeight([inspectorView frame]);
			
			[window setFrame:frame display:[window isVisible]];
		}
	}
}


- (id)inspectorBar:(id)bar itemForIdentifier:(NSString*)identifier
{
	id newItem = [[[NSClassFromString(@"NSInspectorBarItem") alloc] initWithIdentifier:identifier controller:self] autorelease];
	
	if ( ![[self inspectorBarItemIdentifiers] containsObject:identifier] )
	{
		newItem = nil;
	}
	
	return newItem;
}


- (id)viewForInspectorBarItem:(id)barItem
{
	NSView *itemView = nil;
	
	if ( [[barItem identifier] isEqualToString:@"CharacterCounter"] )
	{
		if ( self.characterCounterViewController == nil )
		{
			self.characterCounterViewController = [[[TwitterCharacterCounterViewController alloc] initWithNibName:@"TwitterCharacterCounterViewController" bundle:[NSBundle bundleForClass:[self class]]] autorelease];
		}
		
		itemView = [self.characterCounterViewController view];
	}
	else if ( [[barItem identifier] isEqualToString:@"Username"] )
	{
		if ( self.usernameViewController == nil )
		{
			self.usernameViewController = [[[TwitterUsernameViewController alloc] initWithNibName:@"TwitterUsernameViewController" bundle:[NSBundle bundleForClass:[self class]]] autorelease];
		}
		
		itemView = [self.usernameViewController view];
	}
	
	return itemView;
}


- (id)inspectorBarItemIdentifiers
{
	return [NSArray arrayWithObjects:@"CharacterCounter", @"Username", nil];
}

@end