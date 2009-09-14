//
//  RESTClient.m
//  DrupalREST
//
//  Created by Hugo Wetterberg on 2009-07-24.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import "RESTClient.h"
#import "RESTClientDelegate.h"
#import "RESTClientAsyncRequest.h"
#import "JSON.h"
#import "HURLCache.h"
#import "NSString+URLEncoding.h"

@interface RESTClient (Private) 

-(id)parseJSONData:(NSData *)data;

@end

@implementation RESTClient

@synthesize delegate;

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

    NSURL *url = [request fullUrl];
    NSLog(@"Getting %@", [url absoluteString]);
    NSData *responseData = [[HURLCache sharedCache] getDataForUrl:url];
    if (responseData == nil) {
        NSMutableURLRequest *query;
        // Prepare a custom NSURLRequest if the delegate supports it
        if ([delegate respondsToSelector:@selector(RESTClient:getURLRequestFor:)]) {
            query = [delegate RESTClient:self getURLRequestFor:request];
        }
        else {
            query = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
            [query setHTTPMethod:request.method];
            [query setHTTPBody:request.body];
        }
	
        responseData = [NSURLConnection sendSynchronousRequest:query 
                                             returningResponse:response error:error];
        if (*error) {
             NSLog(@"Error: %@", [*error localizedDescription]);
        }
        else {
            [[HURLCache sharedCache] storeData:responseData forUrl:url];
        }
    }
    return [self parseJSONData:responseData];
}

- (id)parseJSONData:(NSData *)data {
    NSString *responseBody = [[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] autorelease];
    
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    
    return [parser objectWithString:responseBody];
}

-(void)performRequestAsync:(RESTClientRequest *)request target:(id)aTargetOrNil selector:(SEL)aSelectorOrNil failSelector:(SEL)aFailSelectorOrNil {
    // Alter the request if the delegate supports it
    if ([delegate respondsToSelector:@selector(RESTClient:alterRESTRequest:)]) {
        [delegate RESTClient:self alterRESTRequest:request];
    }
    
    NSURL *url = [request fullUrl];
    NSLog(@"Getting %@", [url absoluteString]);
    NSData *cached = [[HURLCache sharedCache] getDataForUrl:url];
    if (cached == nil) {
        NSMutableURLRequest *query;
        // Prepare a custom NSURLRequest if the delegate supports it
        if ([delegate respondsToSelector:@selector(RESTClient:getURLRequestFor:)]) {
            query = [delegate RESTClient:self getURLRequestFor:request];
        }
        else {
            query = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
            [query setHTTPMethod:request.method];
            [query setHTTPBody:request.body];
        }
        
        RESTClientAsyncRequest *asyncRequest = [[RESTClientAsyncRequest alloc] initWithRequest:query target:aTargetOrNil selector:aSelectorOrNil failSelector:aFailSelectorOrNil delegate:self];
        [activeRequests addObject:asyncRequest];
        [asyncRequest release];
    }
    else {
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
    [super dealloc];
}

@end