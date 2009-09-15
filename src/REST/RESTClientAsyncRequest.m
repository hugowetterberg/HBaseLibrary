//
//  RESTClientAsyncRequest.m
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-09-14.
//  Copyright 2009 Good Old. All rights reserved.
//

#import "RESTClientAsyncRequest.h"
#import "SBJSON.h"
#import "HURLCache.h"

@implementation RESTClientAsyncRequest

@synthesize target, selector, data, failSelector;

- (id)initWithRequest:(NSURLRequest *)aRequest target:(id)targetOrNil selector:(SEL)selectorOrNil failSelector:(SEL)failSelectorOrNil delegate:(id)aDelegate {
    if (self = [super init]) {
        target = [targetOrNil retain];
        selector = selectorOrNil;
        failSelector = failSelectorOrNil;
        delegate = [aDelegate retain];
        request = [aRequest retain];
        
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
    
    [[HURLCache sharedCache] storeData:data forUrl:[request URL]];
    [target performSelector:selector withObject:self withObject:parsedData];
    
    [responseBody release];
    [parser release];
    
    [delegate RESTClientAsyncRequestFinished:self];
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
    [super dealloc];
}

@end
