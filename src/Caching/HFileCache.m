//
//  HCache.m
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-08-10.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import "HFileCache.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString+MD5.h"

@implementation HFileCache

- (id)init {
    return [self initWithMemoryCache:nil];
}

- (id)initWithMemoryCache:(id<HSimpleCache>)memoryCacheOrNil {
    self = [super init];
    if (self) {
        memoryCache = [memoryCacheOrNil retain];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        cachePath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:@"HCache"] retain];
        
        // Create the directory if it doesn't exist
        if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
            if (![[NSFileManager defaultManager] createDirectoryAtPath:cachePath 
                                           withIntermediateDirectories:NO
                                                            attributes:nil 
                                                                 error:nil]) {
                self = nil;
            }
        }
        
        // Delete the old directory if it exists
        NSString *oldCachePath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:@"HURLCache"] retain];
        if ([[NSFileManager defaultManager] fileExistsAtPath:oldCachePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:oldCachePath error:nil];
        }
    }
    return self;
}

- (void)storeData:(NSData *)data forKey:(NSString *)key {
    [memoryCache storeData:data forKey:key];
    NSString *filePath = [self pathForKey:key];
    
    NSLog(@"Storing %@ in file cache", key);
    
    // Delete the cached data if it exists
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error = nil;
        if (![[NSFileManager defaultManager] removeItemAtPath:filePath error:&error]) {
            NSLog(@"Error when removing cache file %@: %@", filePath, error);
        }
    }
    
    // Write data to file
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        if (![[NSFileManager defaultManager] createFileAtPath:filePath 
                                                     contents:data 
                                                   attributes:nil]) {
            NSLog(@"Error when creating cache file %@", filePath);
        }
    }
}

- (NSData *)getDataForKey:(NSString *)key age:(NSTimeInterval *)age {
    NSData *cached = [memoryCache getDataForKey:key age:age];
    if (cached == nil) {
        NSString *filePath = [self pathForKey:key];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            // Get the age of the file
            if (age) {
                NSDictionary *attr = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
                NSDate *modified = [attr objectForKey:NSFileModificationDate];
                *age = [modified timeIntervalSinceNow];
            }
            
            cached = [NSData dataWithContentsOfFile:filePath];
            if (cached) {
                NSLog(@"Cache hit for %@ in file cache", key);
                [memoryCache storeData:cached forKey:key];
            }
        }
    }
    return cached;
}

- (UIImage *)getImageForKey:(NSString *)key age:(NSTimeInterval *)age {
    UIImage *cached = nil;
    NSString *filePath = [self pathForKey:key];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        // Get the age of the file
        if (age) {
            NSDictionary *attr = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            NSDate *modified = [attr objectForKey:NSFileModificationDate];
            *age = [modified timeIntervalSinceNow];
        }
        
        cached = [UIImage imageWithContentsOfFile:filePath];
    }
    return cached;
}

- (void)invalidateKey:(NSString *)key {
    [memoryCache invalidateKey:key];
    NSString *filePath = [self pathForKey:key];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

- (void)empty {
    [memoryCache empty];
    // Remove and re-create cache directory
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath attributes:nil];
    }
}

- (void)dealloc {
    [cachePath release];
    [memoryCache release];
    [super dealloc];
}

- (NSString *)pathForKey:(NSString *)key {
    return [cachePath stringByAppendingPathComponent:[key MD5]];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [memoryCache applicationDidReceiveMemoryWarning:application];
}

@end
