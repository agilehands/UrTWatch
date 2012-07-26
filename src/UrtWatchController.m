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

#import "PlayerMenuItemViewController.h"

#define BUFFER_SIZE 1024*8*10

@implementation NSStatusItem(UrtWatch)
-(void)mouseDown:(NSEvent *)theEvent{
	NSLog(@"Mouse down event in Status Item");
}
@end
@implementation NSMenu(UrtWatch)
-(void)mouseDown:(NSEvent *)theEvent{
	NSLog(@"Mouse down event in Status Item");
}
@end
@implementation NSTextField(UrtWatch)

- (void)mouseEntered:(NSEvent *)theEvent{
	self.backgroundColor = [NSColor grayColor];
}
- (void)mouseExited:(NSEvent *)theEvent{
	self.backgroundColor = [NSColor whiteColor];
}
-(void)mouseDown:(NSEvent *)theEvent{
	NSLog(@"Mouse down event: %@", self.stringValue);
}

@end
@implementation UrtWatchController
@synthesize viewSettings, txtPort, txtServerAddress;
@synthesize menuQuite, menuConnect, connectionIndicator, reconnectTimer;
@synthesize btnConnect, statusMenu, statusItem, statusImage, statusHighlightImage;
@synthesize txtInterval, stickyServer;

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
	//statusItem.target = self;
	//[statusItem setAction:@selector(openWin:)];
		
}
-(void)openWin:(id)sender{
    CGRect rect = [[[NSApp currentEvent] window] frame];
	[self.viewSettings setFrameOrigin:rect.origin];
	[viewSettings makeKeyAndOrderFront:nil];
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
	self.txtInterval = nil;
}

- (void)updateInfo{
	if (!isRunning) {
		NSLog(@"I should not repeat!");
		return;
	}
	
	if (!self.stickyServer) {
		self.stickyServer = [[UrTServer alloc] initWithHost:txtServerAddress.stringValue 
												 portNumber:[txtPort.stringValue intValue]];
	}
//	[btnConnect setHidden:YES];
//	[connectionIndicator setHidden:NO];
//	[connectionIndicator startAnimation:self];
	NSLog(@"%@", txtServerAddress.stringValue);	
	__block UrtWatchController* myself = self;
	dispatch_queue_t queue = dispatch_queue_create("com.xapplab.urtwatcher", 							   0);
	dispatch_async(queue, ^(void){
		if (myself.stickyServer) {
			[myself.stickyServer reload];
		}
		
			dispatch_async(dispatch_get_main_queue(), ^(void){
				// first clear any previous player info	
				for (NSMenuItem* item in statusItem.menu.itemArray) {
					[statusMenu removeItem:item];
				}
				
				// add connect item
				[statusMenu addItem:myself.menuConnect];						
				
				// add players
				NSArray* players = [myself.stickyServer.currentGameRecord getPlayers:YES];
				// add separator
				[statusItem.menu addItem:[NSMenuItem separatorItem]];
				
				if ([players count]) {					
					for (Player* player in players) {
						PlayerMenuItemViewController* vc = [[PlayerMenuItemViewController alloc] initWithNibName:@"PlayerMenuItemViewController" bundle:nil];
						[vc view];
						
						[vc update:player];
						[vc.view needsDisplay];
						[vc.view display];
						
//						NSTextField* textField = [[NSTextField alloc] initWithFrame:NSMakeRect(10, 5, 250, 20)];
//						[textField setBezeled:NO];
//						[textField setAcceptsTouchEvents:YES];
//						[textField setDrawsBackground:NO];
//						[textField setEditable:NO];
//						[textField setSelectable:NO];
//						[textField setEnabled:YES];
//						
//						NSString* rankChange = [player rankChange] > 0 ? @"+" : [player rankChange] == 0 ? @"~" : @"-";
//						
//						textField.stringValue = [NSString stringWithFormat:@"\t %@ [ %d <- %d ] %@ \t %d",rankChange, player.currentRank, player.lastRank,  player.name, player.kill];
//						
						
						NSMenuItem* item = [[NSMenuItem alloc] init];
						item.target  =myself;
						[item setAction:@selector(onPlayerSelect:)];
						item.view = vc.view;
						[statusItem.menu addItem:item];	
					}					
				} else {					
					NSMenuItem* item = [[NSMenuItem alloc] init];
					item.title  =@"No player online";
					[statusItem.menu addItem:item];	
				}
				// add separator
				[statusMenu addItem:[NSMenuItem separatorItem]];
				
				// add quit item
				[statusMenu addItem:myself.menuQuite];
				
//				[btnConnect setHidden:NO];
//				[connectionIndicator setHidden:YES];
				
				double delayInSeconds = delayInSeconds = [txtInterval.stringValue doubleValue];
				if (delayInSeconds < 1) {
					delayInSeconds = 5;
					txtInterval.stringValue = @"5";
				}
				dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
				dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
					[myself updateInfo];
				});
			});			
		//}		
	});
}
- (void)menuNeedsUpdate:(NSMenu *)menu{
	NSLog(@"in menu needs update %@", NSStringFromRect([[[NSApp currentEvent] window] frame]));	
}
- (NSInteger)numberOfItemsInMenu:(NSMenu *)menu{
	NSLog(@"in number of itema");
	return 10;
}
- (BOOL)menu:(NSMenu *)menu updateItem:(NSMenuItem *)item atIndex:(NSInteger)index shouldCancel:(BOOL)shouldCancel{
	NSLog(@"update item");
	return YES;
}
- (void)error:(const char*) msg
{
	isRunning = NO;
//	NSRunAlertPanel(@"Error", [NSString stringWithCString:msg 
//												encoding:NSUTF8StringEncoding]
//					, @"Ok"
//					, nil
//					, nil);
    perror(msg);
}

#pragma mark - IBActions
-(IBAction)onSettings:(id)sender{
}
-(IBAction)onCloseSettings:(id)sender{
	[viewSettings close];
}
-(IBAction)onGo:(id)sender{	
	NSLog(@"Clicked button: %@", btnConnect.title);
	if (isRunning) {
		[btnConnect setTitle:@"Go"];
		
		[txtPort setBezeled:isRunning];
		[txtPort setDrawsBackground:isRunning];
		[txtPort setEditable:isRunning];
		[txtPort setSelectable:isRunning];
		[txtPort setEnabled:isRunning];				
		
		[txtServerAddress setBezeled:isRunning];
		[txtServerAddress setDrawsBackground:isRunning];
		[txtServerAddress setEditable:isRunning];
		[txtServerAddress setSelectable:isRunning];
		[txtServerAddress setEnabled:isRunning];		
		
		[txtInterval setBezeled:isRunning];
		[txtInterval setDrawsBackground:isRunning];
		[txtInterval setEditable:isRunning];
		[txtInterval setSelectable:isRunning];
		[txtInterval setEnabled:isRunning];
		
		
		isRunning = NO;
		[menuConnect.view needsDisplay];
		[menuConnect.view display];
	} else {
		[btnConnect setTitle:@"Edit"];
		[txtPort setBezeled:isRunning];
		[txtPort setDrawsBackground:isRunning];
		[txtPort setEditable:isRunning];
		[txtPort setSelectable:isRunning];
		[txtPort setEnabled:isRunning];
		
		[txtServerAddress setBezeled:isRunning];
		[txtServerAddress setDrawsBackground:isRunning];
		[txtServerAddress setEditable:isRunning];
		[txtServerAddress setSelectable:isRunning];
		[txtServerAddress setEnabled:isRunning];
		
		[txtInterval setBezeled:isRunning];
		[txtInterval setDrawsBackground:isRunning];
		[txtInterval setEditable:isRunning];
		[txtInterval setSelectable:isRunning];
		[txtInterval setEnabled:isRunning];
		
		isRunning = YES;
		[menuConnect.view needsDisplay];
		[menuConnect.view display];	
		self.stickyServer = [[UrTServer alloc] initWithHost:txtServerAddress.stringValue 
												 portNumber:[txtPort.stringValue intValue]];		
		
		[self updateInfo];
	}
	
}
- (void) onPlayerSelect:(id)sender{
	NSMenuItem* item = (NSMenuItem*)sender;
	NSLog(@"Selected Player: %@", item.title);
}
#pragma mark - NSTextFieldDelegate
- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor{
	isRunning = NO;
	return YES;
}
@end
