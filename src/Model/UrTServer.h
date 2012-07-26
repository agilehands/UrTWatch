//
//  Server.h
//  UrTWatch
//
//  Created by Shaikh Sonny Aman on 7/26/12.
//  Copyright (c) 2012 Bonn-Rhien-Sieg University of Applied Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecordBook.h"

@interface UrTServer : NSObject

@property (nonatomic, strong) NSString* host;
@property (nonatomic, strong) NSString* serverInfoString;
@property (nonatomic, strong) RecordBook* currentGameRecord;
@property (nonatomic, assign) int port;
@property (nonatomic, assign) BOOL connected;


- (id)initWithHost:(NSString*) host portNumber:(int)port;
- (void)reload;
@end
