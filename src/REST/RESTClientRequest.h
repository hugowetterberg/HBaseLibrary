//
//  RESTClientRequest.h
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-09-14.
//  Copyright 2009 Good Old. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RESTClientCachePolicy.h"

@interface RESTClientRequest : NSObject {
    BOOL forceRefresh;
    NSURL *url;
    NSString *method;
    NSMutableDictionary *parameters;
	NSMutableDictionary *headers;
    NSData *body;
    RESTClientCachePolicy *cachePolicy;
	id infoObject;
}

@property (assign) BOOL forceRefresh;
@property (retain, nonatomic) NSURL *url;
@property (retain, nonatomic) NSString *method;
@property (retain, nonatomic) NSMutableDictionary *parameters;
@property (retain, nonatomic) NSMutableDictionary *headers;
@property (retain, nonatomic) NSData *body;
@property (retain, nonatomic) RESTClientCachePolicy *cachePolicy;
@property (retain, nonatomic) id infoObject;


+ (void)setDefaultCachePolicy:(RESTClientCachePolicy *)cachePolicy;
- (id)initWithUrl:(NSURL *)aUrl method:(NSString *)aMethod;
- (NSURL *)fullUrl;
- (NSString *)cacheKey;
- (void)setJSONBody:(id)object;

@end
