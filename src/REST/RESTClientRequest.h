//
//  RESTClientRequest.h
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-09-14.
//  Copyright 2009 Good Old. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RESTClientRequest : NSObject {
    BOOL forceRefresh;
    NSURL *url;
    NSString *method;
    NSMutableDictionary *parameters;
    NSData *body;
}

@property (assign) BOOL forceRefresh;
@property (retain, nonatomic) NSURL *url;
@property (retain, nonatomic) NSString *method;
@property (retain, nonatomic) NSMutableDictionary *parameters;
@property (retain, nonatomic) NSData *body;

- (id)initWithUrl:(NSURL *)aUrl method:(NSString *)aMethod;
- (NSURL *)fullUrl;

@end
