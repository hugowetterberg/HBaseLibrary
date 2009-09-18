//
//  RESTClientCachePolicy.m
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-09-17.
//  Copyright 2009 Good Old. All rights reserved.
//

#import "RESTClientCachePolicy.h"

@implementation RESTClientCachePolicy

@synthesize useCache, maxAge, serveStale, cacheKey;

+ (RESTClientCachePolicy *)noCaching {
    return [[[RESTClientCachePolicy alloc] initWithUseCache:NO maxAge:0 serveStale:NO] autorelease];
}

- (id)initWithUseCache:(BOOL)shouldUseCache maxAge:(NSTimeInterval)age serveStale:(BOOL)shouldServeStale {
    if (self = [super init]) {
        useCache = shouldUseCache;
        maxAge = age;
        serveStale = shouldServeStale;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    RESTClientCachePolicy *copy = [[RESTClientCachePolicy alloc] initWithUseCache:useCache maxAge:maxAge serveStale:serveStale];
    copy.cacheKey = cacheKey;
    return copy;
}

@end
