//
//  ParseDict.h
//  ReadPlist
//
//  Created by shin on 11/8/12.
//  Copyright (c) 2012 shin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ParseDict : NSWindow <NSOpenSavePanelDelegate,
                                    NSTableViewDataSource,
                                    NSTableViewDelegate,
                                    NSOutlineViewDataSource,
                                    NSOutlineViewDelegate>
{
    NSURL *_fileURL;
    NSArray *_frameArray;
    NSMutableDictionary *_animationDict;
    NSArray *_currentAnimationArray;
}

- (IBAction)loadPlist:(id)sender;
- (IBAction)savePlist:(id)sender;
- (IBAction)saveJson:(id)sender;
- (IBAction)newAnimation:(id)sender;

@property (strong) IBOutlet NSTableView *leftTable;
@property (strong) IBOutlet NSOutlineView *rightTable;

@end
