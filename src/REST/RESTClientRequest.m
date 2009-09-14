//
//  RESTClientRequest.m
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-09-14.
//  Copyright 2009 Good Old. All rights reserved.
//

#import "RESTClientRequest.h"
#import "NSMutableDictionary+HTTPParameters.h"

@implementation RESTClientRequest

@synthesize forceRefresh, url, method, parameters, body;

- (id)initWithUrl:(NSURL *)aUrl method:(NSString *)aMethod {
    if (self = [super init]) {
        self.url = aUrl;
        self.method = aMethod;
    }
    return self;
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

@end
