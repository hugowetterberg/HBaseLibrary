//
//  HFormTextField.h
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-09-29.
//  Copyright 2009 Good Old. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFormElement.h"

@interface HFormTextField : NSObject<HFormElement> {
    NSString *name;
    NSString *label;
    UITableViewCell *cell;
    UITextField *textField;
}

@property (retain, nonatomic) IBOutlet UITextField *textField;

@end
