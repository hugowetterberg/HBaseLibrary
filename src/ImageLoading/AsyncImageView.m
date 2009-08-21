//
//  AsyncImageView.m
//  ImageLoading
//
//  Created by Hugo Wetterberg on 2009-08-06.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface AsyncImageView (Private)

@property (readonly) AsyncImageLoader *loader;

@end

@implementation AsyncImageView

-(AsyncImageLoader *) loader {
    if (!loader) {
        loader = [[AsyncImageLoader alloc] init];
        loader.delegate = self;
    }
    return loader;
}

- (void)setURL:(NSURL *)url {
    imageUrl = [url retain];
    loadNeeded = YES;
}

-(void) setFrame:(CGRect)aRect {
    CGRect activityRect = activity.frame;
    activityRect.origin.x = aRect.size.width / 2 - activityRect.size.width / 2;
    activityRect.origin.y = aRect.size.height / 2 - activityRect.size.height / 2;
    activity.frame = activityRect;
    super.frame = aRect;
}

- (void)setShowActivity:(BOOL)showActivity {
    if (showActivity && !activity) {
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activity.hidesWhenStopped = YES;
        [self addSubview:activity];
    }
    else if (!showActivity) {
        [activity removeFromSuperview];
        [activity release];
        activity = nil;
    }

}

- (void)loadImageIfNeeded {
    if (loadNeeded) {
        loadNeeded = NO;
        [activity startAnimating];
        [self.loader loadImageFromURL:imageUrl targetSize:self.bounds.size];
    }
}

- (void)imageFromUrl:(NSURL *)url {
    [self setURL:url];
    [self loadImageIfNeeded];
}

- (void)asyncImageLoader:(AsyncImageLoader *)imageLoader didFailWithError:(NSError *)error {
    if ([activity isAnimating]) {
        [activity stopAnimating];
    }
}

- (void)asyncImageLoader:(AsyncImageLoader *)imageLoader imageDidLoad:(UIImage *)image {
    if ([activity isAnimating]) {
        [activity stopAnimating];
    }
    self.image = image;
}

- (void)dealloc {
    [loader release];
    [activity release];
    [super dealloc];
}


@end
