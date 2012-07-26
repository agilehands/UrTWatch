//
//  Server.m
//  UrTWatch
//
//  Created by Shaikh Sonny Aman on 7/26/12.
//  Copyright (c) 2012 Bonn-Rhien-Sieg University of Applied Science. All rights reserved.
//

#import "UrTServer.h"
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#import <Cocoa/Cocoa.h>

#define BUFFER_SIZE 1024*8*10
#define URT_MSG_GET_STATUS "\377\377\377\377getstatus"

@implementation UrTServer
@synthesize host, port, connected, currentGameRecord, serverInfoString;

- (id)initWithHost:(NSString*) hostName portNumber:(int)portNumber{
	self = [super init];
	if(self){
		self.host = hostName;
		self.port = portNumber;
		self.connected = NO;
		self.currentGameRecord = [RecordBook new];
	}
	return self;
}

- (void)reload{
	connected = NO;
	int sock, n;
	unsigned int length;
	struct sockaddr_in server, from;
	struct hostent *hp;
	char buffer[BUFFER_SIZE];
	sock= socket(AF_INET, SOCK_DGRAM, 0);
	if (sock < 0){
		return;
	}
	
	server.sin_family = AF_INET;
	hp = gethostbyname([host cStringUsingEncoding:NSASCIIStringEncoding]);	
	if (hp==0){		
		return;				
	}
	
	bcopy((char *)hp->h_addr, 
		  (char *)&server.sin_addr,
		  hp->h_length);
	server.sin_port = htons(port);
	length=sizeof(struct sockaddr_in);
	bzero(buffer,BUFFER_SIZE);
	n=sendto(sock,URT_MSG_GET_STATUS,
			 strlen(URT_MSG_GET_STATUS),0,(const struct sockaddr *)&server,length);
	if (n < 0) {		
		return;
	}
	n = recvfrom(sock,buffer,BUFFER_SIZE,0,(struct sockaddr *)&from, &length);
	if (n < 0){		
		return ;
	}
	write(1,"Got an ack: ",12);
	write(1,buffer,n);
	close(sock);
	connected = YES;
	
	
	[currentGameRecord reset];
	NSString* result = [NSString stringWithCString:buffer encoding:NSASCIIStringEncoding];
	NSArray* arr = [result componentsSeparatedByString:@"\n"];
	if ([arr count] > 1) {
		self.serverInfoString = [arr objectAtIndex:1];
	}	
	if ([arr count] > 2) {
		// add separator
		
		int i = 2;
		for (; i< [arr count]; i++) {
			NSString* playerInfo = [arr objectAtIndex:i];
			if (playerInfo.length > 3) {
				playerInfo = [playerInfo stringByReplacingOccurrencesOfString:@"\"" withString:@""];
				Player* player = [[Player alloc] initWithString:playerInfo];
				[self.currentGameRecord addPlayer:player];				
			}
		}
	}
}
@end
