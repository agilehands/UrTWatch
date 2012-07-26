//
//  UrtWatchController.m
//  UrTWatch
//
//  Created by Shaikh Sonny Aman on 7/25/12.
//  Copyright (c) 2012 Bonn-Rhien-Sieg University of Applied Science. All rights reserved.
//

#import "UrtWatchController.h"
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#define BUFFER_SIZE 1024*8*10

@implementation UrtWatchController
@synthesize viewSettings, txtPort, txtServerAddress;
@synthesize menuQuite, menuConnect, connectionIndicator, reconnectTimer;
@synthesize btnConnect, statusMenu, statusItem, statusImage, statusHighlightImage;

- (void) awakeFromNib{
	
	//Create the NSStatusBar and set its length
	statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
	
	//Used to detect where our files are
	NSBundle *bundle = [NSBundle mainBundle];
	
	//Allocates and loads the images into the application which will be used for our NSStatusItem
	statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"urbanterror" ofType:@"png"]];
	statusHighlightImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"urbanterror" ofType:@"png"]];
	
	//Sets the images in our NSStatusItem
	[statusItem setImage:statusImage];
	[statusItem setAlternateImage:statusHighlightImage];
	
	//Tells the NSStatusItem what menu to load
	[statusItem setMenu:statusMenu];
	//Sets the tooptip for our item
	[statusItem setToolTip:@"UrT Watcher"];
	//Enables highlighting
	[statusItem setHighlightMode:YES];
		
}

- (void) dealloc {
	//Releases the 2 images we loaded into memory
	statusItem = nil;
	self.viewSettings = nil;
	self.txtServerAddress = nil;
	self.txtPort = nil;
	self.menuQuite = nil;
	self.menuConnect = nil;
	self.connectionIndicator = nil;
	self.btnConnect = nil;
	self.statusMenu = nil;
	self.statusItem = nil;
	self.statusImage  =nil;
	self.statusHighlightImage  =nil;
}

- (void)updateInfo{
	[btnConnect setHidden:YES];
	[connectionIndicator setHidden:NO];
	
	dispatch_async(dispatch_queue_create("com.xapplab.urtwatcher", 
										 0), ^(void){
		NSLog(@"Connecting to server...");
		int sock, n;
		unsigned int length;
		struct sockaddr_in server, from;
		struct hostent *hp;
		char buffer[BUFFER_SIZE];
		sock= socket(AF_INET, SOCK_DGRAM, 0);
		if (sock < 0){
			dispatch_async(dispatch_get_main_queue(), ^(void){
				[btnConnect setHidden:NO];
				[connectionIndicator setHidden:YES];
			});			
			[self error:"Failed to create socket"];
			return;
		}
		
		server.sin_family = AF_INET;
		hp = gethostbyname([[txtServerAddress stringValue] cStringUsingEncoding:NSASCIIStringEncoding]);	
		if (hp==0){ 
			dispatch_async(dispatch_get_main_queue(), ^(void){
				[btnConnect setHidden:NO];
				[connectionIndicator setHidden:YES];
			});	
			[self error:"Unknown host"];
			return;
		}
		
		bcopy((char *)hp->h_addr, 
			  (char *)&server.sin_addr,
			  hp->h_length);
		server.sin_port = htons([[txtPort stringValue] intValue]);
		length=sizeof(struct sockaddr_in);
		///printf("Please enter the message: ");
		bzero(buffer,256);
		//fgets(buffer,255,stdin);
		n=sendto(sock,"\377\377\377\377getstatus",
				 13,0,(const struct sockaddr *)&server,length);
		if (n < 0) {
			[self error:"Failed to send message"];;
			return;
		}
		n = recvfrom(sock,buffer,BUFFER_SIZE,0,(struct sockaddr *)&from, &length);
		if (n < 0){
			[self error:"Nothing received from host"];
			return ;
		}
		write(1,"Got an ack: ",12);
		write(1,buffer,n);
		close(sock);
		
		__block NSString* result = [NSString stringWithCString:buffer encoding:NSASCIIStringEncoding];
		dispatch_async(dispatch_get_main_queue(), ^(void){
			// first clear any previous player info	
			for (NSMenuItem* item in statusItem.menu.itemArray) {
				NSLog(@"Deleting menu item: %@", item.title);
				[statusMenu removeItem:item];
			}
			
			// add connect item
			[statusMenu addItem:self.menuConnect];									
			NSArray* arr = [result componentsSeparatedByString:@"\n"];
			NSString* serverInfo;
			if ([arr count] > 1) {
				serverInfo = [arr objectAtIndex:1];
			}
			
			if ([arr count] > 2) {
				// add separator
				[statusItem.menu addItem:[NSMenuItem separatorItem]];
				
				int i = 2;
				for (; i< [arr count]; i++) {
					NSString* playerInfo = [arr objectAtIndex:i];
					if (playerInfo.length > 3) {
						playerInfo = [playerInfo stringByReplacingOccurrencesOfString:@"\"" withString:@""];						
//						NSArray* stats = [playerInfo componentsSeparatedByString:@" "];
//						NSString* menuTitle = [NSString stringWithFormat:@"%@ \t\t\t Kill: %@  \t\t\t (%@)", [stats objectAtIndex:2], [stats objectAtIndex:0], [stats objectAtIndex:1]];
						NSMenuItem* item = [[NSMenuItem alloc] initWithTitle:playerInfo 
																	  action:@selector(onPlayerSelect:) 
															   keyEquivalent:@""];
						item.target  =self;
						[statusItem.menu addItem:item];
					}
				}
				
				// add separator
				[statusMenu addItem:[NSMenuItem separatorItem]];
			}
			
			// add quit item
			// add connect item
			[statusMenu addItem:self.menuQuite];
			
			[btnConnect setHidden:NO];
			[connectionIndicator setHidden:YES];			
		});			
	});
}
- (void)error:(const char*) msg
{
	NSRunAlertPanel(@"Error", [NSString stringWithCString:msg 
												encoding:NSUTF8StringEncoding]
					, @"Ok"
					, nil
					, nil);
    perror(msg);
}

#pragma mark - IBActions
-(IBAction)onSettings:(id)sender{
}
-(IBAction)onCloseSettings:(id)sender{
	[viewSettings close];
}
-(IBAction)onGo:(id)sender{	
	
	if (self.reconnectTimer) {
		if (self.reconnectTimer.isValid) {
			[self.reconnectTimer invalidate];
		}
	}
	
//	self.reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:1 
//														   target:self 
//														 selector:@selector(updateInfo) 
//														 userInfo:nil 
//														  repeats:YES];
	
	[self performSelectorInBackground:@selector(updateInfo) withObject:nil];
		
}
-(BOOL)validateMenuItem:(NSMenuItem*)item{	
	return YES;
}

- (void) onPlayerSelect:(id)sender{
	NSMenuItem* item = (NSMenuItem*)sender;
	NSLog(@"Selected Player: %@", item.title);
}
@end
