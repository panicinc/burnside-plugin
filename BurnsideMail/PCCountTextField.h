//
//  PCCountTextField.h
//  BurnsideMail
//
//  Created by Wade Cosgrove on 9/24/12.
//  Copyright (c) 2012 Wade Cosgrove. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PCCountTextField : NSTextField

@end

@interface PCCountTextFieldCell : NSTextFieldCell
{
	NSInteger _warningValue;	// yellow
	NSInteger _criticalValue;	// red
}

@property (readwrite, assign) NSInteger warningValue;
@property (readwrite, assign) NSInteger criticalValue;


@end


@interface NSColor (PCAdditions)

- (NSColor*)pc_colorByAdjustingBrightness:(CGFloat)brightnessDelta minimum:(CGFloat)minimum;

@end

void PCAppendRoundedRectangle(NSBezierPath *newPath, NSRect aRect, CGFloat cornerRadius, CGFloat lineWidth);