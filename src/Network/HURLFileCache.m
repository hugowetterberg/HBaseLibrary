//
//  HURLCache.m
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-08-10.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import "HURLFileCache.h"
#import <CommonCrypto/CommonDigest.h>

@implementation HURLFileCache

+(NSString *)md5:(NSString *)str {
	const char *cStr = [str UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result );
	return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];	
}

- (id)init {
    return [self initWithMemoryCache:nil];
}

- (id)initWithMemoryCache:(id<HSimpleURLCache>)memoryCacheOrNil {
    self = [super init];
    if (self) {
        memoryCache = [memoryCacheOrNil retain];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        cachePath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:@"HURLCache"] retain];
        
        // Create the directory if it doesn't exist
        if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
            if (![[NSFileManager defaultManager] createDirectoryAtPath:cachePath 
                                           withIntermediateDirectories:NO
                                                            attributes:nil 
                                                                 error:nil]) {
                self = nil;
            }
        }
    }
    return self;
}

- (void)storeData:(NSData *)data forUrl:(NSURL *)url {
    [memoryCache storeData:data forUrl:url];
    NSString *filePath = [self pathForUrl:url];
    
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

- (NSData *)getDataForUrl:(NSURL *)url {
    NSData *cached = [memoryCache getDataForUrl:url];
    if (cached == nil) {
        NSString *filePath = [self pathForUrl:url];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            cached = [NSData dataWithContentsOfFile:filePath];
            if (cached) {
                [memoryCache storeData:cached forUrl:url];
            }
        }
    }
    return cached;
}

- (UIImage *)getImageForUrl:(NSURL *)url {
    UIImage *cached = nil;
    NSString *filePath = [self pathForUrl:url];        
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        cached = [UIImage imageWithContentsOfFile:filePath];
    }
    return cached;
}

- (void)invalidateUrl:(NSURL *)url {
    [memoryCache invalidateUrl:url];
    NSString *filePath = [self pathForUrl:url];
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

- (NSString *)pathForUrl:(NSURL *)url {
    NSString *keyMD5 = [HURLFileCache md5:[url absoluteString]];
    return [cachePath stringByAppendingPathComponent:keyMD5];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [memoryCache applicationDidReceiveMemoryWarning:application];
}

@end
