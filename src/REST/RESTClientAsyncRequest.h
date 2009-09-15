//
//  RESTClientAsyncRequest.h
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-09-14.
//  Copyright 2009 Good Old. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RESTClientAsyncRequest : NSObject
{
    id delegate;
    id target;
    SEL selector;
    SEL failSelector;
    NSMutableData *data;
    NSURLRequest *request;
    NSURLConnection *connection;
}

-(id)initWithRequest:(NSURLRequest *)request target:(id)targetOrNil selector:(SEL)selectorOrNil failSelector:(SEL)failSelectorOrNil delegate:(id)aDelegate;

@property (readonly) id target;
@property (readonly) SEL selector;
@property (readonly) SEL failSelector;
@property (readonly) NSMutableData *data;

@end
