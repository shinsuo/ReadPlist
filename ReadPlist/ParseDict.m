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
        _frameArray = [[[tempDict2 allKeys] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd, nil]] mutableCopy];
        
        [_leftTable reloadData];
        [_leftTable setAllowsMultipleSelection:YES];
        
    }else{
        NSLog(@"Cancel");
    }
}

- (IBAction)savePlist:(id)sender {
}

- (IBAction)saveJson:(id)sender {
    
}

- (IBAction)newAnimation:(id)sender {
    NSIndexSet *indexSet = [_leftTable selectedRowIndexes];

    _currentAnimationArray = [[_frameArray objectsAtIndexes:indexSet] mutableCopy];
    
//    [_leftTable beginUpdates];
//    [_leftTable removeRowsAtIndexes:indexSet withAnimation:NSTableViewAnimationEffectFade];
//    [_leftTable insertRowsAtIndexes:indexSet withAnimation:NSTableViewAnimationEffectFade];
//    [_leftTable endUpdates];
    
//    if (!_animationDict) {
//        _animationDict = [[NSMutableDictionary alloc] initWithCapacity:1];
//    }
//    
//    
//    
//    [_animationDict setObject:_currentAnimationArray forKey:[NSString stringWithFormat:@"animation%li",[_animationDict count]]];
    
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [NSString stringWithFormat:@"animation%li",[_animationList count]],@"parent",
                                     _currentAnimationArray,@"children",
                                     nil];
    
    if (!_animationList) {
        _animationList = [[NSMutableArray alloc] initWithCapacity:1] ;
    }
    
    [_animationList addObject:tempDict];
    
    
    
//    [_rightTable reloadData];
    [_rightTable reloadItem:_animationList];
    [_rightTable reloadData];
}

- (void)deleteParent:(id)item
{
    if ([_animationList containsObject:item]) {
        
        NSUInteger index = [_animationList indexOfObject:item];
        [_animationList removeObject:item];
        
        for (; index < [_animationList count]; index++) {
            NSMutableDictionary *temp = [_animationList objectAtIndex:index];
            [temp setObject:[NSString stringWithFormat:@"animation%li",index] forKey:@"parent"];
        }
        
    }
}

- (IBAction)removeItem:(id)sender {

    id item = [_rightTable itemAtRow:_rightTable.selectedRow];
    if ([item isKindOfClass:[NSDictionary class]]) {
        NSLog(@"NSDictionary:{%@}",item);
        
//        NSDictionary *temp = [_rightTable parentForItem:[_rightTable itemAtRow:_rightTable.selectedRow]];
//        if ([_animationList containsObject:temp]) {
//            NSLog(@"fdsf{%@}",[_rightTable itemAtRow:_rightTable.selectedRow]);
//        }else{
//            NSLog(@"abc{%@}",[_rightTable itemAtRow:_rightTable.selectedRow]);
//        }
        [self deleteParent:item];
    }else if ([item isKindOfClass:[NSString class]]){
        NSMutableDictionary *tempDict = nil;
        NSMutableArray *tempArray = nil;
        for (tempDict in _animationList) {
            tempArray = [tempDict objectForKey:@"children"];
            if ([tempArray containsObject:item]) {
                [tempArray removeObject:item];
            }
        }
        
        if ([tempArray count] < 1) {
            NSMutableDictionary *temp = [_rightTable parentForItem:item];
            [self deleteParent:temp];
        }
    }
    
    
    [_rightTable reloadData];
    
}

- (void)deleteItemFromList:(NSUInteger)index
{
    NSUInteger currentCount = 0;
    for(id item in _animationList)
    {
        currentCount += [[item objectForKey:@"children"] count] + 1;
        if (index > currentCount)
        {
            continue;
        }else{
            
        }
            
        
    }
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
    
    
}

#pragma mark NSOutlineViewDataSource Method
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [_animationList count];
    }
    
    if ([item isKindOfClass:[NSDictionary class]]) {
        return [[item objectForKey:@"children"] count];
    }
    
    return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (item == nil) {
        return [_animationList objectAtIndex:index];
    }
    
    if ([item isKindOfClass:[NSDictionary class]]) {
        return [[item objectForKey:@"children"] objectAtIndex:index];
    }
    
    return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if ([item isKindOfClass:[NSDictionary class]]) {
        return YES;
    }else{
        return NO;
    }
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{   
    
    if ([item isKindOfClass:[NSDictionary class]]) {
        return [item objectForKey:@"parent"];
    }
    
    
    return item;
    
    
//    return [item objectForKey:@"children"];
    
//    if ([outlineView isItemExpanded:item]) {
//        return [item objectForKey:@"parent"];
//    }else{
//        return @"fds";
//    }
}

//- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
//{
//    NSLog(@"shouldSelectItem");
//}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    
    
    if ([_rightTable isExpandable:[_rightTable itemAtRow:_rightTable.selectedRow]]) {
//        NSLog(@"parent:%li",_rightTable.selectedRow);
    }else{
//        NSLog(@"children:%li",_rightTable.selectedRow);
    };
    
    

}


#pragma mark NSOutlineViewDelegate Method


@end
