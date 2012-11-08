//
//  ParseDict.m
//  ReadPlist
//
//  Created by shin on 11/8/12.
//  Copyright (c) 2012 shin. All rights reserved.
//

#import "ParseDict.h"

@implementation ParseDict

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
}

- (IBAction)savePlist:(id)sender {
}

- (IBAction)saveJson:(id)sender {
    
}

#pragma mark NSOpenSavePanelDelegate Method


@end
