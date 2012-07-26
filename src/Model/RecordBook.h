//
//  PlayerRecord.h
//  UrTWatch
//
//  Created by Shaikh Sonny Aman on 7/26/12.
//  Copyright (c) 2012 Bonn-Rhien-Sieg University of Applied Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@interface RecordBook : NSObject

@property( nonatomic, strong) NSMutableDictionary* record;
@property( nonatomic, strong) NSDictionary* lastRecord;

- (void) reset;
- (void) addPlayer: (Player*)player;
- (NSArray*) getPlayers:(BOOL)shouldSortByRank;
@end
