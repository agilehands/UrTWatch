//
//  Player.m
//  UrTWatch
//
//  Created by Shaikh Sonny Aman on 7/26/12.
//  Copyright (c) 2012 Bonn-Rhien-Sieg University of Applied Science. All rights reserved.
//

#import "Player.h"

@implementation Player
@synthesize name, ping, kill, lastKill, currentRank, lastRank;

- (id)initWithString:(NSString*) string{
	self = [super init];
	if (self) {
		NSArray* arr = [string componentsSeparatedByString:@" "];
		
		if ([arr count] < 3) {
			return nil;
		}
		
		self.kill = [[arr objectAtIndex:0] intValue];
		self.lastKill = self.kill;
		self.ping = [[arr objectAtIndex:1] intValue];		
		
		if ([arr count] > 3) {
			arr = [arr subarrayWithRange:NSMakeRange(2, [arr count]-2)];
			self.name = [arr componentsJoinedByString:@" "];
		} else {
			self.name = [arr objectAtIndex:2];
		}
		//NSLog(@"Player name= %@", self.name);
		
		self.currentRank = 0;
		self.lastRank = 0;
	}		
	return self;
}
- (int)rankChange{
	return lastRank - currentRank;
}
@end
