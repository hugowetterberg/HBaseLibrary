//
//  RESTClientAsyncRequestDelegate.h
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-09-14.
//  Copyright 2009 Good Old. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RESTClientAsyncRequest.h"

@protocol RESTClientAsyncRequestDelegate <NSObject>

- (void)RESTClientAsyncRequestFinished:(RESTClientAsyncRequest *)request;

@end
