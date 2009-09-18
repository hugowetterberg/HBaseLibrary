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
#import "RESTClientRequest.h"
#import "RESTClientAsyncRequest.h"
#import "RESTClientCachePolicy.h"

@protocol RESTClientDelegate;
@protocol RESTClientAsyncRequestDelegate;

@interface RESTClient : NSObject {
    NSMutableSet *activeRequests;
    id<RESTClientDelegate> delegate;
}

@property (retain) id <RESTClientDelegate> delegate;

-(id)init;

-(NSDictionary *)performRequest:(RESTClientRequest *)request returningResponse:(NSURLResponse **)response error:(NSError **)error;
-(void)performRequestAsync:(RESTClientRequest *)request target:(id)aTargetOrNil selector:(SEL)aSelectorOrNil failSelector:(SEL)aFailSelectorOrNil;
-(void)RESTClientAsyncRequestFinished:(RESTClientAsyncRequest *)request;

@end
