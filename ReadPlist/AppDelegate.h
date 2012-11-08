//
//  AppDelegate.h
//  ReadPlist
//
//  Created by shin on 11/8/12.
//  Copyright (c) 2012 shin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ParseDict.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet ParseDict *window;

@end
