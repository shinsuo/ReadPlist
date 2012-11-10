//
//  ParseDict.m
//  ReadPlist
//
//  Created by shin on 11/8/12.
//  Copyright (c) 2012 shin. All rights reserved.
//

#import "ParseDict.h"


#define CHILD       @"children"
#define PARENT      @"parent"
#define ANIMATION   @"animation"
#define NAME        @"name"
#define COUNT       @"count"

//AnimationFile Formate
/*
    Example:
        Load    girl.plist
        Generat girl-ani.plist/girl-ani.json
 */
#define ANIMATIONPLIST  @"-ani.plist"
#define ANIMATIONJSON   @"-ani.json"


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
    if (!_saveDict) {
        _saveDict = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    for (id tempDict in _animationList) {
        NSMutableArray *tempArray = [tempDict objectForKey:CHILD];
        NSString *tempString = [tempArray objectAtIndex:0];
        NSDictionary *animationName = [NSDictionary dictionaryWithObject:[tempString substringToIndex:tempString.length-5]
                                                                  forKey:NAME];
        NSDictionary *animationCount = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%lu",[tempArray count]]
                                                                   forKey:COUNT];
        
        NSDictionary *animationObject = [NSDictionary dictionaryWithObjectsAndKeys:[tempString substringToIndex:tempString.length-5],
                                         NAME,
                                         [NSString stringWithFormat:@"%lu",[tempArray count]],
                                         COUNT, nil];
        
        [_saveDict setObject:animationObject
                      forKey:[tempDict objectForKey:PARENT]];
    }
    NSURL *newFileURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[_fileURL.absoluteString substringToIndex:_fileURL.absoluteString.length-6],ANIMATIONPLIST]];
    [_saveDict writeToURL:newFileURL atomically:YES];
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
                                     [NSString stringWithFormat:@"%@%li",ANIMATION,[_animationList count]],PARENT,
                                     _currentAnimationArray,CHILD,
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
        
        /*更改animation序列的名字
        for (; index < [_animationList count]; index++) {
            NSMutableDictionary *temp = [_animationList objectAtIndex:index];
            [temp setObject:[NSString stringWithFormat:@"%@%li",ANIMATION,index] forKey:PARENT];
        }
        // */
        
    }
}

- (IBAction)removeItem:(id)sender {

    id item = [_rightTable itemAtRow:_rightTable.selectedRow];
    if ([item isKindOfClass:[NSDictionary class]]) {
        
        [self deleteParent:item];
    }else if ([item isKindOfClass:[NSString class]]){
        NSMutableDictionary *tempDict = nil;
        NSMutableArray *tempArray = nil;
        for (tempDict in _animationList) {
            tempArray = [tempDict objectForKey:CHILD];
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
        currentCount += [[item objectForKey:CHILD] count] + 1;
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
        return [[item objectForKey:CHILD] count];
    }
    
    return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (item == nil) {
        return [_animationList objectAtIndex:index];
    }
    
    if ([item isKindOfClass:[NSDictionary class]]) {
        return [[item objectForKey:CHILD] objectAtIndex:index];
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
        return [item objectForKey:PARENT];
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
