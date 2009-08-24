//
//  HSimpleCache.h
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-08-10.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol HSimpleURLCache <NSObject>
- (void)storeData:(NSData *)data forUrl:(NSURL *)url;
- (NSData *)getDataForUrl:(NSURL *)url;
- (UIImage *)getImageForUrl:(NSURL *)url;
- (void)invalidateUrl:(NSURL *)url;
- (void)empty;
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application;
@end
