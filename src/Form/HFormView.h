//
//  HFormView.h
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-09-29.
//  Copyright 2010 Hugo Wetterberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFormElement.h"

@interface HFormView : UIView<UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *elements;
    NSMutableDictionary *elementDictionary;
    UIScrollView *scroll;
    UITableView *table;
}

- (void)addElement:(id<HFormElement>)aElement;
- (NSString *)stringValue:(NSString *)name;

@end
