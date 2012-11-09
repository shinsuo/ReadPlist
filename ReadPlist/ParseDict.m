//
//  ParseDict.m
//  ReadPlist
//
//  Created by shin on 11/8/12.
//  Copyright (c) 2012 shin. All rights reserved.
//

#import "ParseDict.h"

@implementation ParseDict
@synthesize leftTable = _leftTable;
@synthesize rightTable = _rightTable;

- (IBAction)loadPlist:(id)sender {
    NSLog(@"loading Plist");
    
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    
    [openPanel setAllowsMultipleSelection:NO];
    openPanel.delegate = self;
    NSArray *fileType = [NSArray arrayWithObjects:@"plist", nil];
    [openPanel setAllowedFileTypes:fileType];
    [openPanel setAllowsOtherFileTypes:NO];
    [openPanel beginSheetModalForWindow:self completionHandler:^(NSInteger result){
        
    }];
    
    if (openPanel.runModal == NSOKButton) {
        _fileURL = openPanel.URL;
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithContentsOfURL:openPanel.URL];
        NSMutableDictionary *tempDict2 = [tempDict objectForKey:@"frames"];

        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
        _frameArray = [[tempDict2 allKeys] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd, nil]];
        
        [_leftTable reloadData];
        [_leftTable setAllowsMultipleSelection:YES];
        [_leftTable setDraggingDestinationFeedbackStyle:NSTableViewDraggingDestinationFeedbackStyleRegular];
        
    }else{
        NSLog(@"Cancel");
    }
}

- (IBAction)savePlist:(id)sender {
}

- (IBAction)saveJson:(id)sender {
    
}

- (IBAction)newAnimation:(id)sender {
    
}

#pragma mark NSOpenSavePanelDelegate Method

#pragma mark NSTableViewDataSource Method
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [_frameArray count];
}


- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    
    return [_frameArray objectAtIndex:row];
}

#pragma mark NSTableViewDelegate Method

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSIndexSet *indexSet = [_leftTable selectedRowIndexes];
    
    NSLog(@"indexSet:%@",indexSet);
    
}


@end
