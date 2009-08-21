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
#import "HURLCache.h"

@implementation RESTClient

@synthesize delegate;

-(id)init {
    self = [super init];
    if (self) {
        activeRequests = [[NSMutableSet alloc] init];
        
    }
    return self;
}

-(NSString *)queryStringFromDictionary:(NSDictionary *)dictionary {
    NSArray *keys = [dictionary allKeys];
    if (keys && keys.count) {
        NSMutableString *query = [[NSMutableString alloc] initWithString:@"?"];
        for (int i=0; i<keys.count; i++) {
            NSString *key = [keys objectAtIndex:i];
            if (i) {
                [query appendFormat:@"&%@=%@", [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [(NSString *)[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
            else {
                [query appendFormat:@"%@=%@", [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [(NSString *)[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        return [query autorelease];
    }
    return @"";
}

-(NSDictionary *)getResource:(NSURL *)resourceUrl method:(NSString *)method parameters:(NSDictionary *)dictionaryOrNil returningResponse:(NSURLResponse **)response error:(NSError **)error {
    NSURL *url = [[[NSURL alloc] initWithString:[NSString 
                                                stringWithFormat:@"%@%@",
                                                [resourceUrl absoluteURL],
                                                [self queryStringFromDictionary:dictionaryOrNil]]] autorelease];
    NSLog(@"Getting %@", [url absoluteString]);
    NSData *responseData = [[HURLCache sharedCache] getDataForUrl:url];
    if (responseData == nil) {
        NSURLRequest *query;
        if ([delegate respondsToSelector:@selector(RESTClient:getRequestForUrl:method:)]) {
            query = [delegate RESTClient:self getRequestForUrl:url method:method];        
        }
        else {
            query = [[NSURLRequest alloc] initWithURL:url];
        }
	
        responseData = [NSURLConnection sendSynchronousRequest:query 
                                             returningResponse:response error:error];
        [[HURLCache sharedCache] storeData:responseData forUrl:url];
    }
    return [self parseJSONData:responseData];
}

- (id)parseJSONData:(NSData *)data {
    NSString *responseBody = [[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] autorelease];
    
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    
    return [parser objectWithString:responseBody];
}

-(void)getResourceAsync:(NSURL *)resourceUrl method:(NSString *)method parameters:(NSDictionary *)dictionaryOrNil target:(id)aTargetOrNil selector:(SEL)aSelectorOrNil failSelector:(SEL)aFailSelectorOrNil {
    // Alter the parameters if the delegate supports it
    if ([delegate respondsToSelector:@selector(RESTClient:alterParamters:)]) {
        dictionaryOrNil = [[dictionaryOrNil mutableCopy] autorelease];
        [delegate RESTClient:self alterParamters:(NSMutableDictionary *)dictionaryOrNil];
    }

    NSURL *url = [[[NSURL alloc] initWithString:[NSString 
                                                stringWithFormat:@"%@%@",
                                                [resourceUrl absoluteURL],
                                                [self queryStringFromDictionary:dictionaryOrNil]]] autorelease];
    NSLog(@"Getting %@", [url absoluteString]);
    NSData *cached = [[HURLCache sharedCache] getDataForUrl:url];
    if (cached == nil) {
        NSURLRequest *query;
        // Prepare a custom NSURLRequest if the delegate supports it
        if ([delegate respondsToSelector:@selector(RESTClient:getRequestForUrl:method:)]) {
            query = [delegate RESTClient:self getRequestForUrl:url method:method];        
        }
        else {
            query = [[[NSURLRequest alloc] initWithURL:url] autorelease];
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

-(void)asyncRequestFinished:(RESTClientAsyncRequest *)request {
    [activeRequests removeObject:request];
}

-(void)dealloc {
    [activeRequests release];
    [super dealloc];
}

@end


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
    
    [delegate asyncRequestFinished:self];
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