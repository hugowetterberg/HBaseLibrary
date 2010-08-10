//
//  HFormView.m
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-09-29.
//  Copyright 2010 Hugo Wetterberg. All rights reserved.
//

#import "HFormView.h"

@interface HFormView (Private)

- (void)initialize;

@end

@implementation HFormView

- (id)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    elements = [[NSMutableArray alloc] init];
    elementDictionary = [[NSMutableDictionary alloc] init];
    
    scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:scroll];
    
    table = [[UITableView alloc] initWithFrame:scroll.bounds style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    [scroll addSubview:table];
}

- (void)dealloc {
    [table release];
    [elements release];
    [elementDictionary release];
    
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"Telling the table that we've got %d sections", [elements count]);
    return [elements count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSLog(@"Telling the table that section %d is called '%@'", section, [[elements objectAtIndex:section] label]);
    return [[elements objectAtIndex:section] label];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Asking %@ for it's cell", [[elements objectAtIndex:indexPath.row] name]);
    return [[elements objectAtIndex:indexPath.section] cell];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

- (NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL allowSelect = [[elements objectAtIndex:indexPath.section] willSelectCell];
    if (!allowSelect) {
        indexPath = nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
}

-(void) addElement:(id<HFormElement>)aElement {
    [elements addObject:aElement];
    [elementDictionary setObject:aElement forKey:aElement.name];
    NSLog(@"Added the element %@, we now have %d elements", aElement.name, [elements count]);
    [table reloadData];
    
    CGSize csize = table.contentSize;
    table.frame = CGRectMake(0, 0, csize.width, csize.height);
    scroll.contentSize = CGSizeMake(csize.width, csize.height + 300);
}

- (NSString *)stringValue:(NSString *)name {
    return [[elementDictionary objectForKey:name] stringValue];
}

@end
