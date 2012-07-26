//
//  PlayerMenuItemViewController.m
//  UrTWatch
//
//  Created by Shaikh Sonny Aman on 7/26/12.
//  Copyright (c) 2012 Bonn-Rhien-Sieg University of Applied Science. All rights reserved.
//

#import "PlayerMenuItemViewController.h"

@interface PlayerMenuItemViewController ()

@end

@implementation PlayerMenuItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {        
    }
    
    return self;
}

- (void) awakeFromNib{
	[imgBackground setHidden:YES];
}
- (void)update:(Player*) player{
	[imgRankChange setHidden:YES];
	
	txtName.stringValue = player.name;	
	if (player.lastKill < player.kill) {
		txtScore.stringValue = [NSString stringWithFormat:@"%d (+)", player.kill];
	} else {
		txtScore.stringValue = [NSString stringWithFormat:@"%d", player.kill];
		txtScore.textColor  =[NSColor blueColor];
	}
	if ([player rankChange] > 0) {
		imgRankChange.image = [NSImage imageNamed:@"up.png"];
		[imgRankChange setHidden:NO];
	} else if ([player rankChange] < 0) {
		imgRankChange.image = [NSImage imageNamed:@"down.png"];
		[imgRankChange setHidden:NO];
	}	
}
@end
