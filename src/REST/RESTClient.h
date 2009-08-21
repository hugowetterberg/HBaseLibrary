//
//  RESTClient.h
//  DrupalREST
//
//  Created by Hugo Wetterberg on 2009-07-24.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AuthorizationManager.h"

@protocol RESTClientDelegate;

@interface RESTClient : NSObject {
    NSMutableSet *activeRequests;
    id <RESTClientDelegate> delegate;
}

@property (retain) id <RESTClientDelegate> delegate;

-(id)init;
-(NSString *)queryStringFromDictionary:(NSDictionary *)dictionary;
-(NSDictionary *)getResource:(NSURL *)resourceUrl method:(NSString *)method parameters:(NSDictionary *)dictionaryOrNil returningResponse:(NSURLResponse **)response error:(NSError **)error;
-(void)getResourceAsync:(NSURL *)resourceUrl method:(NSString *)method parameters:(NSDictionary *)dictionaryOrNil target:(id)aTargetOrNil selector:(SEL)aSelectorOrNil failSelector:(SEL)aFailSelectorOrNil;
-(id)parseJSONData:(NSData *)data;

@end

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

