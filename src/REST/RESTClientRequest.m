//
//  RESTClientRequest.m
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-09-14.
//  Copyright 2009 Good Old. All rights reserved.
//

#import "RESTClientRequest.h"
#import "NSMutableDictionary+HTTPParameters.h"

static RESTClientCachePolicy *defaultCachePolicy = nil;

@implementation RESTClientRequest

@synthesize forceRefresh, url, method, parameters, body, cachePolicy;

+ (void)setDefaultCachePolicy:(RESTClientCachePolicy *)cachePolicy {
    [defaultCachePolicy release];
    defaultCachePolicy = [cachePolicy retain];
}

- (id)initWithUrl:(NSURL *)aUrl method:(NSString *)aMethod {
    if (self = [super init]) {
        self.url = aUrl;
        self.method = aMethod;
        self.parameters = [[[NSMutableDictionary alloc] init] autorelease];
        self.cachePolicy = [[defaultCachePolicy copy] autorelease];
    }
    return self;
}

- (void)dealloc {
    self.url = nil;
    self.method = nil;
    self.parameters = nil;
    self.cachePolicy = nil;
    self.body = nil;
    
    [super dealloc];
}

- (NSURL *)fullUrl {
    NSURL *fullUrl;
    
    if ([self.parameters count] == 0) {
        fullUrl = self.url;
    }
    else {
        fullUrl = [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@",
                                                  [self.url absoluteURL],
                                                  [self.parameters asHTTPParameters]]] autorelease];
    }
    
    return fullUrl;
}

- (NSString *)cacheKey {
    NSString *cacheKey = self.cachePolicy.cacheKey;
    if (!cacheKey) {
        cacheKey = [url absoluteString];
    }
    return cacheKey;
}

@end
