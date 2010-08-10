//
//  HFormTextField.m
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-09-29.
//  Copyright 2010 Hugo Wetterberg. All rights reserved.
//

#import "HFormTextField.h"

@interface HFormTextField (Private)

- (void)textFieldChanged:(UITextField *)textField;

@end


@implementation HFormTextField

@synthesize name, label, textField;

- (id)initWithName:(NSString *)aName label:(NSString *)aLabel value:(id)aValue {
    if (self = [super init]) {
        name = [aName retain];
        label = [aLabel retain];
        self.value = aValue;
    }
    return self;
}

- (void)dealloc {
    [name release];
    [label release];
    [textField release];
    textField = nil;
    [cell release];
    cell = nil;
    self.value = nil;
    
    [super dealloc];
}

- (UITextField *)textField {
    if (!textField) {
        self.textField = [[[UITextField alloc] init] autorelease];
    }
    return textField;
}

- (BOOL)willSelectCell {
    [self.textField becomeFirstResponder];
    return NO;
}

- (void)setTextField:(UITextField *)aTextField {
    [textField release];
    
    textField = [aTextField retain];
    textField.text = self.value;
}

- (id)value {
    return self.textField.text;
}

- (void)setValue:(id)aValue {
    if (aValue) {
        self.textField.text = [aValue description];
    }
    else {
        self.textField.text = @"";
    }   
}

- (NSString *)stringValue {
    return self.textField.text;
}

- (UITableViewCell *)cell {
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        self.textField.frame = cell.bounds;
        [cell.contentView addSubview:self.textField];
        
        CGRect frame = cell.contentView.bounds; 
        float heightDiff = cell.contentView.bounds.size.height - 31;
        frame.origin.x += heightDiff/2;
        frame.origin.y += heightDiff/2;
        frame.size.width -= heightDiff;
        frame.size.height = 31;
        self.textField.frame = frame;
        self.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    
    return cell;
}

@end
