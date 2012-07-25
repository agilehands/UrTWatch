//
//  UrtWatchController.h
//  UrTWatch
//
//  Created by Shaikh Sonny Aman on 7/25/12.
//  Copyright (c) 2012 Bonn-Rhien-Sieg University of Applied Science. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UrtWatchController : NSObject{

IBOutlet NSMenu *statusMenu;

/* The other stuff :P */
NSStatusItem *statusItem;
NSImage *statusImage;
NSImage *statusHighlightImage;
}
@property (nonatomic, strong) IBOutlet NSPanel* viewSettings;
@property (nonatomic, strong) IBOutlet NSTextField* txtServerAddress;
@property (nonatomic, strong) IBOutlet NSTextField* txtPort;
@property (nonatomic, strong) IBOutlet NSProgressIndicator* connectionIndicator;
@property (nonatomic, strong) IBOutlet NSButton* btnConnect;
@property (nonatomic, strong) IBOutlet NSMenuItem* menuConnect;
@property (nonatomic, strong) IBOutlet NSMenuItem* menuQuite;
@property (nonatomic, strong) NSTimer* reconnectTimer;
-(IBAction) onPlayerSelect:(id)sender;
-(IBAction)onSettings:(id)sender;
-(IBAction)onCloseSettings:(id)sender;
-(IBAction)onGo:(id)sender;
@end
