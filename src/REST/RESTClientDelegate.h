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
-(void)RESTClient:(RESTClient *)client alterRESTRequest:(RESTClientRequest *)request;
-(NSMutableURLRequest *)RESTClient:(RESTClient *)client getURLRequestFor:(RESTClientRequest *)request;
@end
