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
    //the URL of openPanel
    NSURL *_fileURL;
    //
    NSMutableArray *_frameArray;
    //all Animation resource list
    NSMutableArray *_animationList;
    //Array of png per Animation
    NSMutableArray *_currentAnimationArray;
    //Result Dictionary
    NSMutableDictionary *_saveDict;
}

- (IBAction)loadPlist:(id)sender;
- (IBAction)savePlist:(id)sender;
- (IBAction)saveJson:(id)sender;
- (IBAction)newAnimation:(id)sender;//Unfinished
- (IBAction)removeItem:(id)sender;

//All Png list
@property (strong) IBOutlet NSTableView *leftTable;
//All Animation list
@property (strong) IBOutlet NSOutlineView *rightTable;

@end
