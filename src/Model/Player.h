//
//  Player.h
//  UrTWatch
//
//  Created by Shaikh Sonny Aman on 7/26/12.
//  Copyright (c) 2012 Bonn-Rhien-Sieg University of Applied Science. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) int kill;
@property (nonatomic, assign) int ping;
@property (nonatomic, assign) int lastKill;
@property (nonatomic, assign) int currentRank;
@property (nonatomic, assign) int lastRank;


- (id)initWithString:(NSString*) string;
- (int)rankChange;
@end
