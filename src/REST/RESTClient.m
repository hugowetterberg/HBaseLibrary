//
//  RESTClient.m
//  DrupalREST
//
//  Created by Hugo Wetterberg on 2009-07-24.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import "RESTClient.h"
#import "RESTClientDelegate.h"
#import "JSON.h"
#import "HCache.h"
#import "NSString+URLEncoding.h"

static RESTClient *sharedClient = nil;

@interface RESTClient (Private)

-(id)parseJSONData:(NSData *)data;

@end

@implementation RESTClient

@synthesize delegate;

+ (RESTClient *)sharedClient {
	return sharedClient;
}

+ (void)setSharedClient:(RESTClient *)aSharedClient {
	[sharedClient release];
	sharedClient = [aSharedClient retain];
}

-(id)init {
    self = [super init];
    if (self) {
        activeRequests = [[NSMutableSet alloc] init];
    }
    return self;
}

-(NSDictionary *)performRequest:(RESTClientRequest *)request returningResponse:(NSURLResponse **)response error:(NSError **)error {
    // Alter the request if the delegate supports it
    if ([delegate respondsToSelector:@selector(RESTClient:alterRESTRequest:)]) {
        [delegate RESTClient:self alterRESTRequest:request];
    }

    NSLog(@"Getting %@ (%@)", [request cacheKey], [request fullUrl]);
    
    NSData *responseData = nil;
    // Check of we have a cached version
    if (request.cachePolicy.useCache && [request.method isEqual:@"GET"]) {
        NSLog(@"Checking if %@ exists in cache", [request cacheKey]);
        NSTimeInterval age = 0;
        responseData = [[HCache sharedCache] getDataForKey:[request cacheKey] age:&age];
        if (responseData) {
            NSLog(@"The data was cached and is %f seconds old", age);
        }
        if (responseData && age > request.cachePolicy.maxAge) {
            if (!request.cachePolicy.serveStale) {
                responseData = nil;
            }
            else {
                [self performRequestAsync:request target:nil selector:nil failSelector:nil];
            }
        }
    }
    
    if (responseData == nil) {
        NSMutableURLRequest *query;
        // Prepare a custom NSURLRequest if the delegate supports it
        if ([delegate respondsToSelector:@selector(RESTClient:getURLRequestFor:)]) {
            query = [delegate RESTClient:self getURLRequestFor:request];
        }
        else {
            query = [[[NSMutableURLRequest alloc] initWithURL:[request fullUrl]] autorelease];
            [query setHTTPMethod:request.method];
            [query setHTTPBody:request.body];
        }
        
        responseData = [NSURLConnection sendSynchronousRequest:query 
                                             returningResponse:response error:error];
        if (*error) {
            NSLog(@"Error: %@", [*error localizedDescription]);
        }
        else if (request.cachePolicy.useCache && [request.method isEqual:@"GET"]) {
            [[HCache sharedCache] storeData:responseData forKey:[request cacheKey]];
        }
        
    }
    return [self parseJSONData:responseData];
}

- (id)parseJSONData:(NSData *)data {
    NSString *responseBody = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    id response = [parser objectWithString:responseBody];
    if (!response) {
        NSLog(@"The response might not've been valid JSON:\n%@", responseBody);
    }
    return response;
}

-(void)performRequestAsync:(RESTClientRequest *)request target:(id)aTargetOrNil selector:(SEL)aSelectorOrNil failSelector:(SEL)aFailSelectorOrNil {
    // Alter the request if the delegate supports it
    if ([delegate respondsToSelector:@selector(RESTClient:alterRESTRequest:)]) {
        [delegate RESTClient:self alterRESTRequest:request];
    }
    
    NSLog(@"Getting %@ (%@)", [request cacheKey], [request fullUrl]);
    NSTimeInterval age = 0;
    NSData *cached = nil;
    
    BOOL refresh = NO;
    if (request.cachePolicy.useCache && [request.method isEqual:@"GET"]) {
        cached = [[HCache sharedCache] getDataForKey:[request cacheKey] age:&age];
        if (cached) {
            NSLog(@"The data was cached and is %f seconds old", age);
        }
        if (cached && age > request.cachePolicy.maxAge) {
            if (!request.cachePolicy.serveStale) {
                cached = nil;
            }
            else {
                refresh = YES;
            }
        }
    }
    
    if (cached == nil || refresh) {
        NSMutableURLRequest *query;
        // Prepare a custom NSURLRequest if the delegate supports it
        if ([delegate respondsToSelector:@selector(RESTClient:getURLRequestFor:)]) {
            query = [delegate RESTClient:self getURLRequestFor:request];
        }
        else {
            query = [[[NSMutableURLRequest alloc] initWithURL:[request fullUrl]] autorelease];
            [query setHTTPMethod:request.method];
            [query setHTTPBody:request.body];
			for (NSString *header in request.headers) {
				[query setValue:[request.headers objectForKey:header] forHTTPHeaderField:header];
			}
        }
        
        RESTClientAsyncRequest *asyncRequest = nil;
        if (refresh) {
            // If this is a refresh, don't tell the sender when we're done, they'll recieve the cached data instead
            asyncRequest = [[RESTClientAsyncRequest alloc] initWithRequest:query restRequest:request target:nil selector:nil failSelector:nil delegate:self];
        }
        else {
            asyncRequest = [[RESTClientAsyncRequest alloc] initWithRequest:query restRequest:request target:aTargetOrNil selector:aSelectorOrNil failSelector:aFailSelectorOrNil delegate:self];
        }

        [activeRequests addObject:asyncRequest];
        [asyncRequest release];
    }
    
    if (cached != nil) {
        if ([aTargetOrNil respondsToSelector:aSelectorOrNil]) {
            [aTargetOrNil performSelector:aSelectorOrNil
                               withObject:nil
                               withObject:[self parseJSONData:cached]];
        }
    }
}

-(void)RESTClientAsyncRequestFinished:(RESTClientAsyncRequest *)request {
    [activeRequests removeObject:request];
}

-(void)dealloc {
    [activeRequests release];
    self.delegate = nil;
    
    [super dealloc];
}

@end