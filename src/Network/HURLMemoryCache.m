//
//  HURLMemoryCache.m
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-08-10.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import "HURLMemoryCache.h"

@interface HACachedData : NSObject {
    NSDate *accessed;
    NSData *data;
    NSString *key;
}

@property (retain) NSDate *accessed;
@property (readonly) NSString *key;
@property (readonly) NSData *data;

- (id)initWithKey:(NSString *)theKey andData:(NSData *)theData;
- (NSComparisonResult)accessedCompareDesc:(HACachedData *)other;

@end


@implementation HACachedData

@synthesize accessed, data, key;

- (id)initWithKey:(NSString *)theKey andData:(NSData *)theData {
    self = [super init];
    if (self) {
        key = [theKey retain];
        data = [theData retain];
        self.accessed = [NSDate date];
    }
    return self;
}

- (NSComparisonResult)accessedCompareDesc:(HACachedData *)other {
    return [other.accessed compare:accessed];
}

- (void)dealloc {
    [key release];
    [data release];
    [super dealloc];
}

@end


@implementation HURLMemoryCache

- (id)initWithMemoryLimit:(int)memoryLimit maxCacheableSize:(int)maxCacheable {
    self = [self init];
    
    if (self) {
        usedMemory = 0;
        memLimit = memoryLimit;
        cacheableLimit = maxCacheable;
        queue = [[NSMutableArray alloc] init];
        cache = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)storeData:(NSData *)data forUrl:(NSURL *)url {
    if ([data length] < cacheableLimit) {
        NSLog(@"Small enough to cache");
        HACachedData *cached = [[[HACachedData alloc] initWithKey:[url absoluteString] andData:data] autorelease];
        usedMemory += [data length];
        
        [cache setObject:cached forKey:cached.key];
        [queue addObject:cached];
        
        NSLog(@"Added %@ to memory cache, %d objects in cache", cached.key, [queue count]);

        // Start popping things off the cache if we are hitting the memory limit
        if (usedMemory > memLimit) {
            NSLog(@"Popping stuff off the memory cache");
            [queue sortUsingSelector:@selector(accessedCompareDesc:)];
            for (int i=[queue count]-1; i>=0 && usedMemory > memLimit; i--) {
                HACachedData *old = [queue objectAtIndex:i];
                usedMemory -= [old.data length];
                [queue removeObjectAtIndex:i];
                [cache removeObjectForKey:old.key];
            }
        }
    }
}

- (NSData *)getDataForUrl:(NSURL *)url {
    HACachedData *cached = [cache objectForKey:[url absoluteString]];
    cached.accessed = [NSDate date];
    return cached.data;
}

- (UIImage *)getImageForUrl:(NSURL *)url {
    NSData *cachedData = [self getDataForUrl:url];
    UIImage *image = nil;
    if (cachedData != nil) {
        image = [UIImage imageWithData:cachedData];
    }
    return image;
}

- (void)invalidateUrl:(NSURL *)url {
    [cache removeObjectForKey:[url absoluteString]];
}

- (void)empty {
    [cache removeAllObjects];
    [queue removeAllObjects];
    usedMemory = 0;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [self empty];
}

@end
