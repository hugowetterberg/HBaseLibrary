//
//  HFormElement.h
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-09-29.
//  Copyright 2010 Hugo Wetterberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HFormElement <NSObject>

- (id)initWithName:(NSString *)aName label:(NSString *)aLabel value:(id)aValue;
- (BOOL)willSelectCell;
- (NSString *)stringValue;

@property (readonly) NSString *name;
@property (readonly) NSString *label;
@property (readonly) UITableViewCell *cell;
@property (retain, nonatomic) id value;

@end
