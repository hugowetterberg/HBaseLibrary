//
//  AsyncImageView.h
//  ImageLoading
//
//  Created by Hugo Wetterberg on 2009-08-06.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageLoader.h"
#import "AsyncImageLoaderDelegate.h"

@interface AsyncImageView : UIImageView <AsyncImageLoaderDelegate> {
    NSURL *imageUrl;
    BOOL loadNeeded;
    AsyncImageLoader *loader;
    UIActivityIndicatorView *activity;
}

- (void)loadImageIfNeeded;
- (void)setURL:(NSURL *)url;
- (void)imageFromUrl:(NSURL *)url;
- (void)setShowActivity:(BOOL)showActivity;

@end
