//
//  RESTClientAsyncRequest.m
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-09-14.
//  Copyright 2009 Good Old. All rights reserved.
//

#import "RESTClientAsyncRequest.h"
#import "SBJSON.h"
#import "HCache.h"

@implementation RESTClientAsyncRequest

@synthesize target, selector, data, failSelector, restRequest;

- (id)initWithRequest:(NSURLRequest *)aRequest restRequest:(RESTClientRequest *)aRESTRequest target:(id)targetOrNil selector:(SEL)selectorOrNil failSelector:(SEL)failSelectorOrNil delegate:(id)aDelegate {
    if (self = [super init]) {
        target = [targetOrNil retain];
        selector = selectorOrNil;
        failSelector = failSelectorOrNil;
        delegate = [aDelegate retain];
        request = [aRequest retain];
        restRequest = [aRESTRequest retain];
        
        data = [[NSMutableData alloc] initWithCapacity:2048];
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)urlResponse {
    [data setLength:0];
}

//the URL connection calls this repeatedly as data arrives
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
    [data appendData:incrementalData];
}

//the URL connection calls this once all the data has downloaded
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    //NSLog(@"%@", responseBody);
    NSDictionary *parsedData = (NSDictionary *)[parser objectWithString:responseBody];
    
    if (restRequest.cachePolicy.useCache) {
        NSString *cacheKey = restRequest.cachePolicy.cacheKey;
        if (!cacheKey) {
            cacheKey = [[restRequest fullUrl] absoluteString];
        }
        [[HCache sharedCache] storeData:data forKey:cacheKey];
    }
    [target performSelector:selector withObject:self withObject:parsedData];
    
    [responseBody release];
    [parser release];
    
    if ([delegate respondsToSelector:@selector(RESTClientAsyncRequestFinished:)]) {
        [delegate performSelector:@selector(RESTClientAsyncRequestFinished:) withObject:self];
    }
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [target performSelector:failSelector withObject:self withObject:error];
}

-(void)dealloc {
    [target release];
    [delegate release];
    [data release];
    [connection release];
    [request release];
    [restRequest release];
    [super dealloc];
}

@end
