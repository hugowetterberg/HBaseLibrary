//
//  HURLCache.m
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-08-10.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import "HURLCache.h"

static id<HSimpleURLCache> sharedCache = nil;

@implementation HURLCache

+ (id<HSimpleURLCache>)sharedCache {
    return sharedCache;
}

+ (void)setSharedCache:(id<HSimpleURLCache>)cache {
    [sharedCache release];
    sharedCache = [cache retain];
}

@end
