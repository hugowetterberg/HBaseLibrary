//
//  HSimpleCache.h
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-08-10.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol HSimpleCache <NSObject>
- (void)storeData:(NSData *)data forKey:(NSString *)key;
- (NSData *)getDataForKey:(NSString *)key age:(NSTimeInterval *)age;
- (UIImage *)getImageForKey:(NSString *)key age:(NSTimeInterval *)age;
- (void)invalidateKey:(NSString *)key;
- (void)empty;
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application;
@end
