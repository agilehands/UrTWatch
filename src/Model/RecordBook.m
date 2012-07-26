//
//  PlayerRecord.m
//  UrTWatch
//
//  Created by Shaikh Sonny Aman on 7/26/12.
//  Copyright (c) 2012 Bonn-Rhien-Sieg University of Applied Science. All rights reserved.
//

#import "RecordBook.h"

@implementation RecordBook
@synthesize record, lastRecord;

- (id)init{
	self = [super init];
	if (self) {
		self.record = [NSMutableDictionary new];
		self.lastRecord = [NSMutableDictionary new];
	}
	return self;
}
- (void) reset{
	self.lastRecord = [NSDictionary dictionaryWithDictionary:self.record];
	[self.record removeAllObjects];
}

- (void) addPlayer: (Player*)player{
	Player* playerRecord = [self.lastRecord valueForKey:player.name];
	if (playerRecord) {
		player.lastKill = playerRecord.kill;		
		player.lastRank = playerRecord.currentRank;
	}	
	[record setValue:player forKey:player.name];
}
- (NSArray*) getPlayers:(BOOL)shouldSortByRank{
	NSMutableArray* players = [NSMutableArray new];
	[record enumerateKeysAndObjectsUsingBlock:^(id key, id val, BOOL* stop){
		[players addObject:val];
	}];
	
	if (shouldSortByRank) {
		[players sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
			return [(Player*)obj1 kill] < [(Player*)obj2 kill];
		}];
	}
	int rank = 0;
	for (Player* player in players) {		
		player.currentRank = rank++;
	}
	return players;
}
@end
