//
//  UrtWatchController.h
//  UrTWatch
//
//  Created by Shaikh Sonny Aman on 7/25/12.
//  Copyright (c) 2012 Bonn-Rhien-Sieg University of Applied Science. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UrTServer.h"

@interface UrtWatchController : NSObject<NSTextFieldDelegate>{
	BOOL isRunning;
}

@property (nonatomic, strong) IBOutlet NSPanel* viewSettings;

@property (nonatomic, strong) IBOutlet NSTextField* txtServerAddress;
@property (nonatomic, strong) IBOutlet NSTextField* txtPort;
@property (nonatomic, strong) IBOutlet NSTextField* txtInterval;
@property (nonatomic, strong) IBOutlet NSProgressIndicator* connectionIndicator;
@property (nonatomic, strong) IBOutlet NSButton* btnConnect;

@property (nonatomic, strong) NSTimer* reconnectTimer;
@property (nonatomic, strong) UrTServer* stickyServer;

@property (nonatomic, strong) IBOutlet NSMenuItem* menuConnect;
@property (nonatomic, strong) IBOutlet NSMenuItem* menuQuite;
@property (nonatomic, strong) IBOutlet NSMenu *statusMenu;
@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) NSImage *statusImage;
@property (nonatomic, strong) NSImage *statusHighlightImage;


-(IBAction)onSettings:(id)sender;
-(IBAction)onGo:(id)sender;
@end
