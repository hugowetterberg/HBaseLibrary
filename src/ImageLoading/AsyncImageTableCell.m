//
//  AsyncImageViewTableCell.m
//  Kalendariet
//
//  Created by Hugo Wetterberg on 2009-07-23.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import "AsyncImageTableCell.h"


@implementation AsyncImageTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imageLoader = [[AsyncImageLoader alloc] init];
        imageLoader.delegate = self;
    }
    return self;
}

- (void)loadImageFromURL:(NSURL*)aUrl {
    [imageLoader loadImageFromURL:aUrl];
}

-(void)asyncImageLoader:(AsyncImageLoader *)imageLoader imageDidLoad:(UIImage *)image {
    self.imageView.image = image;
    [self setNeedsLayout];
}

-(void) asyncImageLoader:(AsyncImageLoader *)imageLoader didFailWithError:(NSError *)error {
}

- (void)dealloc {
    [imageLoader release];
    [super dealloc];
}

@end
