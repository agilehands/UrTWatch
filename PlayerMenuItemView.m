//
//  PlayerMenuItemView.m
//  UrTWatch
//
//  Created by Shaikh Sonny Aman on 7/26/12.
//  Copyright (c) 2012 Bonn-Rhien-Sieg University of Applied Science. All rights reserved.
//

#import "PlayerMenuItemView.h"

@implementation PlayerMenuItemView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

#define menuItem ([self enclosingMenuItem])
- (void) drawRect: (NSRect) rect {
    BOOL isHighlighted = [menuItem isHighlighted];
    if (isHighlighted) {
        [[NSColor selectedMenuItemColor] set];
        [NSBezierPath fillRect:rect];
    } else {
        [super drawRect: rect];
    }
}
@end
