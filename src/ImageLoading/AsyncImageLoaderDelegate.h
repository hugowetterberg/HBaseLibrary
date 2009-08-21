//
//  AsyncImageLoaderDelegate.h
//  ImageLoading
//
//  Created by Hugo Wetterberg on 2009-08-04.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AsyncImageLoader.h"


@protocol AsyncImageLoaderDelegate <NSObject>
- (void)asyncImageLoader:(AsyncImageLoader *)imageLoader imageDidLoad:(UIImage *)image;
- (void)asyncImageLoader:(AsyncImageLoader *)imageLoader didFailWithError:(NSError *)error;
@end
