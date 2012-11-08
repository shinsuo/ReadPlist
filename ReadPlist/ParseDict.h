//
//  ParseDict.h
//  ReadPlist
//
//  Created by shin on 11/8/12.
//  Copyright (c) 2012 shin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ParseDict : NSWindow <NSOpenSavePanelDelegate>
{
    NSMutableArray *_frameArray;
    NSMutableDictionary *_animationArray;
}

- (IBAction)loadPlist:(id)sender;
- (IBAction)savePlist:(id)sender;
- (IBAction)saveJson:(id)sender;

@end
