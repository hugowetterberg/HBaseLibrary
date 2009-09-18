//
//  HMemoryCache.m
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-08-10.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import "HMemoryCache.h"

@interface HACachedData : NSObject {
    NSDate *created;
    NSData *data;
    NSString *key;
}

@property (retain) NSDate *created;
@property (readonly) NSString *key;
@property (readonly) NSData *data;

- (id)initWithKey:(NSString *)theKey andData:(NSData *)theData;

@end


@implementation HACachedData

@synthesize created, data, key;

- (id)initWithKey:(NSString *)theKey andData:(NSData *)theData {
    self = [super init];
    if (self) {
        key = [theKey retain];
        data = [theData retain];
        self.created = [NSDate date];
    }
    return self;
}

- (void)dealloc {
    [key release];
    [data release];
    [super dealloc];
}

@end


@implementation HMemoryCache

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

- (void)storeData:(NSData *)data forKey:(NSString *)key {
    if ([data length] < cacheableLimit) {
        NSLog(@"Small enough to cache");
        HACachedData *cached = [[[HACachedData alloc] initWithKey:key andData:data] autorelease];
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

- (NSData *)getDataForKey:(NSString *)key age:(NSTimeInterval *)age {
    HACachedData *cached = [cache objectForKey:key];
    if (cached) {
        NSLog(@"Cache hit for %@ in memory cache", key);
        *age = [cached.created timeIntervalSinceNow];
    }
    return cached.data;
}

- (UIImage *)getImageForKey:(NSString *)key age:(NSTimeInterval *)age {
    NSData *cachedData = [self getDataForKey:key age:age];
    UIImage *image = nil;
    if (cachedData != nil) {
        NSLog(@"Cache hit for %@ in memory cache", key);
        image = [UIImage imageWithData:cachedData];
    }
    return image;
}

- (void)invalidateKey:(NSString *)key {
    [cache removeObjectForKey:key];
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
