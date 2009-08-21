//
//  AsyncImageViewTableCell.h
//  Kalendariet
//
//  Created by Hugo Wetterberg on 2009-07-23.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncImageLoaderDelegate.h"


@interface AsyncImageTableCell : UITableViewCell <AsyncImageLoaderDelegate> {
    AsyncImageLoader *imageLoader;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)loadImageFromURL:(NSURL*)url;

@end