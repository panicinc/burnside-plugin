//
//  BurnsideDocumentEditor.m
//  BurnsideMail
//
//  Created by Wade Cosgrove on 9/21/12.
//  Copyright (c) 2012 Wade Cosgrove. All rights reserved.
//

#import "BurnsideDocumentEditor.h"
#import "BurnsideMail.h"
#import "TwitterInspectorBarController.h"
#import "TwitterCharacterCounterViewController.h"
#import "TwitterUsernameViewController.h"

static NSMutableDictionary *sEditorToViewControllerMap = nil;


@interface BurnsideDocumentEditor ()
- (NSString*)pc_contentString;
- (TwitterInspectorBarController*)pc_installTwitterInspector;
- (NSArray*)pc_toRecipients;
- (TwitterInspectorBarController*)pc_twitterInspectorController;
@end


@implementation BurnsideDocumentEditor

+ (void)installSwizzles
{
	[BurnsideDocumentEditor truePreviewAddAsCategoryToClass:NSClassFromString(@"DocumentEditor")];
	
	[NSClassFromString(@"DocumentEditor") truePreviewSwizzleMethod:@selector(webViewDidChange:) withMethod:@selector(swizzledWebViewDidChange:) isClassMethod:NO];
	[NSClassFromString(@"DocumentEditor") truePreviewSwizzleMethod:@selector(finishLoadingEditor) withMethod:@selector(swizzledFinishLoadingEditor) isClassMethod:NO];
	[NSClassFromString(@"DocumentEditor") truePreviewSwizzleMethod:@selector(windowWillClose:) withMethod:@selector(swizzledWindowWillClose:) isClassMethod:NO];
		
	sEditorToViewControllerMap = [[NSMutableDictionary alloc] initWithCapacity:2];
}


- (void)swizzledWebViewDidChange:(id)aNotification
{
	[self swizzledWebViewDidChange:aNotification];
	
	TwitterInspectorBarController *inspectorBar = [self pc_twitterInspectorController];
	
	if ( inspectorBar != nil )
	{
		NSString *messageString = [self pc_contentString];
		NSRange range = [messageString rangeOfString:@"(.*)(On.*wrote:.*)" options:NSRegularExpressionSearch];
		
		if ( range.location != NSNotFound )
		{
			NSString *outgoingString = [[messageString substringToIndex:range.location] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			
			TwitterCharacterCounterViewController *composeViewController = [inspectorBar characterCounterViewController];
						
			[composeViewController setTypedCharacterCount:[outgoingString length]];
		}
	}
}


- (NSString*)pc_contentString
{
	// Be safe kids
	
	NSString *contentString = nil;
	
	if ( [self respondsToSelector:@selector(backEnd)] )
	{
		id backEnd = [self performSelector:@selector(backEnd)];
		
		if ( [backEnd respondsToSelector:@selector(content)] )
		{
			NSObject *content = [backEnd performSelector:@selector(content)];
	
			if ( [content respondsToSelector:@selector(string)] )
			{
				contentString = [content performSelector:@selector(string)];
			}
		}
	}
	
	return contentString;
}


- (NSArray*)pc_toRecipients
{
	// Be safe kids
	
	NSArray *addressees = nil;
	
	if ( [self respondsToSelector:@selector(backEnd)] )
	{
		id backEnd = [self performSelector:@selector(backEnd)];
		
		if ( [backEnd respondsToSelector:@selector(toRecipients)] )
		{
			addressees = [backEnd performSelector:@selector(toRecipients)];
		}
	}
	
	return addressees;
}

- (TwitterInspectorBarController*)pc_twitterInspectorController
{
	return [sEditorToViewControllerMap objectForKey:[NSValue valueWithPointer:self]];
}


- (TwitterInspectorBarController*)pc_installTwitterInspector
{
	TwitterInspectorBarController *inspectorBar = [[TwitterInspectorBarController alloc] init];
	[inspectorBar installInspectorIntoWindow:[self performSelector:@selector(window)]];
	
	[sEditorToViewControllerMap setObject:inspectorBar forKey:[NSValue valueWithPointer:self]];
	[inspectorBar release];
	
	return inspectorBar;
}


- (void)swizzledFinishLoadingEditor
{
	[self swizzledFinishLoadingEditor];

	NSArray *addressees = [self pc_toRecipients];

	for ( NSObject *curAddressee in addressees )
	{
		NSString *addressString = [curAddressee performSelector:@selector(address)];
		
		if ( [addressString hasPrefix:@"twitter+"] )
		{
			NSRange twitterHandleRange = NSMakeRange(8, [addressString rangeOfString:@"@"].location - 8);
			
			TwitterInspectorBarController *inspectorBar = [self pc_installTwitterInspector];
			NSString *twitterName = [addressString substringWithRange:twitterHandleRange];
			
			[[inspectorBar usernameViewController] setUsername:twitterName];
			
			[[inspectorBar characterCounterViewController] setTwitterName:[NSString stringWithFormat:@"@%@", twitterName]];
			
			NSString *defaultsSignature = [[NSUserDefaults standardUserDefaults] objectForKey:@"Burnside.signature.server"];
			if ( defaultsSignature != nil )
				[[inspectorBar characterCounterViewController] setSignature:defaultsSignature];
			else
				[[inspectorBar characterCounterViewController] setSignature:@" -C"];
			
			break;
		}
	}
}


- (void)swizzledWindowWillClose:(id)notification
{
	TwitterInspectorBarController *inspectorBar = [self pc_twitterInspectorController];
	
	if ( [[notification object] performSelector:@selector(inspectorBar)] == inspectorBar )
	{
		[[notification object] performSelector:@selector(setInspectorBar:) withObject:nil];
	}
	
	[sEditorToViewControllerMap removeObjectForKey:[NSValue valueWithPointer:self]];
			
	[self swizzledWindowWillClose:notification];
}


@end
