//
//  HCache.m
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-08-10.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import "HCache.h"

static id<HSimpleCache> sharedCache = nil;

@implementation HCache

+ (id<HSimpleCache>)sharedCache {
    return sharedCache;
}

+ (void)setSharedCache:(id<HSimpleCache>)cache {
    [sharedCache release];
    sharedCache = [cache retain];
}

@end
