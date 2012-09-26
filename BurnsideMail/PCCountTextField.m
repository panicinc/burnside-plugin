//
//  PCCountTextField.m
//  BurnsideMail
//
//  Created by Wade Cosgrove on 9/24/12.
//  Copyright (c) 2012 Wade Cosgrove. All rights reserved.
//

#import "PCCountTextField.h"
#import <tgmath.h>

@implementation PCCountTextField

+ (void)initialize
{
    if (self == [PCCountTextField class]) {
        [self setCellClass:[PCCountTextFieldCell class]];
    }
}

@end


@interface PCCountTextFieldCell ()
- (NSGradient*)fillGradient;
@end


@implementation PCCountTextFieldCell

@synthesize warningValue = _warningValue;
@synthesize criticalValue = _criticalValue;


- (id)initTextCell:(NSString *)aString
{
	self = [super initTextCell:aString];
	
	if ( self )
	{
		[self configure];
		[self setFont:[NSFont systemFontOfSize:[NSFont smallSystemFontSize]]];
	}
	
	return self;
}


- (id)initWithCoder:(NSCoder*)aCoder
{
	self = [super initWithCoder:aCoder];
	
	if ( self )
	{
		[self configure];
	}
	
	return self;
}


- (id)copyWithZone:(NSZone *)zone
{
	PCCountTextFieldCell *cell = [super copyWithZone:zone];
	
	[cell setCriticalValue:self.criticalValue];
	[cell setWarningValue:self.warningValue];
	
	return cell;
}


- (void)configure
{
	self.warningValue = 110;
	self.criticalValue = 132;

	[self setLineBreakMode:NSLineBreakByTruncatingTail];
	[self setSelectable:NO];
	[self setEditable:NO];
	[self setDrawsBackground:NO];
	[self setBackgroundStyle:NSBackgroundStyleRaised];
}


- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	[self drawBezelWithFrame:cellFrame inView:controlView];

	// center the text frame vertically
	
	NSSize stringSize = [[self attributedStringValue] size];
	cellFrame.origin.y = floor((cellFrame.size.height - stringSize.height) / 2.0) + cellFrame.origin.y;
	
	[super drawInteriorWithFrame:cellFrame inView:controlView];
}


- (void)drawBezelWithFrame:(NSRect)cellFrame inView:(NSView*)controlView
{
//	the gradient is 73% white to 0% white
//	the stroke is 41% black, no gradient to it
//	inner shadow is 26% white
//	drop shadow is 30% white

	NSBezierPath *strokePath = [NSBezierPath bezierPath];
	PCAppendRoundedRectangle(strokePath, cellFrame, 3.0, 1.0);

	NSBezierPath *innerStrokePath = [NSBezierPath bezierPath];
	PCAppendRoundedRectangle(innerStrokePath, NSInsetRect(cellFrame, 1., 1.), 2.0, .0);

	NSBezierPath *fillPath = [NSBezierPath bezierPath];
	PCAppendRoundedRectangle(fillPath, NSInsetRect(cellFrame, 1., 1.), 2.0, .0);


	CGFloat percentage = [self stringValue].floatValue / self.criticalValue;
	
	CGFloat fillWidth = floor(percentage * (cellFrame.size.width - 2.0));
	if ( fillWidth > 0 )
	{
		NSBezierPath *progressFill = [NSBezierPath bezierPath];
		PCAppendRoundedRectangle(progressFill, NSMakeRect(cellFrame.origin.x + 1., cellFrame.origin.y + 1.0, fillWidth, cellFrame.size.height - 2.0), 2.0, .0);
		
		NSGradient *progressGradient = [self fillGradient];
		[progressGradient drawInBezierPath:progressFill angle:90.0];
	}


	NSGradient *overlayGradient = [[[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:1.0 alpha:.73] endingColor:[NSColor colorWithCalibratedWhite:1.0 alpha:0]] autorelease];
	[overlayGradient drawInBezierPath:fillPath angle:90.0];

	[[NSColor colorWithCalibratedWhite:1.0 alpha:.26] set];
	[innerStrokePath stroke];

	[[NSColor colorWithCalibratedWhite:0. alpha:.41] set];
	[strokePath stroke];
}


- (void)setDrawsBackground:(BOOL)flag
{
	[super setDrawsBackground:NO];
}

- (void)setSelectable:(BOOL)flag
{
	[super setSelectable:NO];
}


- (void)setEditable:(BOOL)flag
{
	[super setEditable:NO];
}


- (NSGradient*)fillGradient
{
	NSColor *color = nil;
	
	if ( self.integerValue >= self.criticalValue )
		color = [NSColor colorWithCalibratedRed:0.988 green:0.301 blue:0.328 alpha:1.000]; //[NSColor redColor];
	else if ( self.integerValue >= self.warningValue )
		color = [NSColor colorWithCalibratedRed:1.000 green:1.000 blue:0.150 alpha:1.000]; //[NSColor yellowColor];
	else
		color = [NSColor colorWithCalibratedRed:0.356 green:0.837 blue:0.322 alpha:1.000]; //[NSColor greenColor];
	
	NSColor *startColor = color;
	NSColor *endColor = [color pc_colorByAdjustingBrightness:-.25 minimum:0];
	
	return [[[NSGradient alloc] initWithStartingColor:startColor endingColor:endColor] autorelease];
}

@end


@implementation NSColor (PCAdditions)

- (NSColor*)pc_colorByAdjustingBrightness:(CGFloat)brightnessDelta minimum:(CGFloat)minimum
{
	NSColor *adjustedColor = nil;
	NSColor *tempColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	
	if ( tempColor != nil )
	{
		CGFloat hue = 0.0;
		CGFloat saturation = 0.0;
		CGFloat brightness = 0.0;
		CGFloat alpha = 0.0;
		
		// sanity check
		if ( minimum < 0.0 )
			minimum = 0.0;
		
		[tempColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
		
		brightness += brightnessDelta;
		
		if ( 1.0 < brightness )
			brightness = 1.0;
		else if ( brightness < minimum )
			brightness = minimum;
		
		adjustedColor = [NSColor colorWithCalibratedHue:hue saturation:saturation brightness:brightness alpha:alpha];
	}
	
	return adjustedColor;	
}

@end


void PCAppendRoundedRectangle(NSBezierPath *newPath, NSRect aRect, CGFloat cornerRadius, CGFloat lineWidth)
{
	CGFloat offset = (lineWidth / 2.0);
	
	cornerRadius -= offset;
	
	[newPath setLineWidth:lineWidth];
	
	[newPath moveToPoint:NSMakePoint( 0 + offset, cornerRadius + offset)];
	
	// left edge
	[newPath lineToPoint:NSMakePoint( 0 + offset, aRect.size.height - cornerRadius - offset)];
	
	// upper left corner
	[newPath appendBezierPathWithArcWithCenter:NSMakePoint(cornerRadius + offset, aRect.size.height - cornerRadius - offset)
									radius:cornerRadius
									startAngle:180
									endAngle:90
									clockwise:YES];
		
	// upper right coner
	[newPath appendBezierPathWithArcWithCenter:NSMakePoint(aRect.size.width - cornerRadius - offset, aRect.size.height - cornerRadius - offset)
									radius:cornerRadius
									startAngle:90
									endAngle:0
									clockwise:YES];
	// bottom right corner
	[newPath appendBezierPathWithArcWithCenter:NSMakePoint(aRect.size.width - cornerRadius - offset, cornerRadius + offset)
									radius:cornerRadius
									startAngle:0
									endAngle:270
									clockwise:YES];
	// bottom left corner
	[newPath appendBezierPathWithArcWithCenter:NSMakePoint(cornerRadius + offset, cornerRadius + offset)
									radius:cornerRadius
									startAngle:270
									endAngle:180
									clockwise:YES];
	[newPath closePath];
	
	
	if ( !NSEqualPoints(aRect.origin, NSZeroPoint) )
	{
		NSAffineTransform *transform = [NSAffineTransform transform];
		[transform translateXBy:aRect.origin.x yBy:aRect.origin.y];
		
		[newPath transformUsingAffineTransform:transform];
	}
}

