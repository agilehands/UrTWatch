//
//  PlayerMenuItemViewController.h
//  UrTWatch
//
//  Created by Shaikh Sonny Aman on 7/26/12.
//  Copyright (c) 2012 Bonn-Rhien-Sieg University of Applied Science. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Player.h"

@interface PlayerMenuItemViewController : NSViewController{
	IBOutlet NSImageView* imgRankChange;
	IBOutlet NSImageView* imgBackground;
	IBOutlet NSTextField* txtName;
	IBOutlet NSTextField* txtScore;
}

- (void)update:(Player*) player;
@end
