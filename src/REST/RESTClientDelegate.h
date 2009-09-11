//
//  RESTClientDelegate.h
//  DrupalREST
//
//  Created by Hugo Wetterberg on 2009-08-03.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RESTClient.h"

@protocol RESTClientDelegate <NSObject>

@optional
-(void)RESTClient:(RESTClient *)client alterParameters:(NSMutableDictionary *)parameters url:(NSURL *)resourceUrl method:(NSString *)method;
-(NSMutableURLRequest *)RESTClient:(RESTClient *)client getRequestForUrl:(NSURL *)url method:(NSString *)method body:(NSData *)bodyOrNil;
@end
