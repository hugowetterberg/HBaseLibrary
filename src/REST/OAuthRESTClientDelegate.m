//
//  OAuthRESTClientDelegate.m
//  DrupalREST
//
//  Created by Hugo Wetterberg on 2009-08-03.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import "OAuthRESTClientDelegate.h"

@implementation OAuthRESTClientDelegate

-(id)initWithAuthorizationManager:(AuthorizationManager *)aAuthManager {
    self = [super init];
    if (self) {
        authManager = aAuthManager;
        [authManager retain];
    }
    return self;
}

-(NSURLRequest *)RESTClient:(id)client getRequestForUrl:(NSURL *)url method:(NSString *)method {
    OAMutableURLRequest *request = [[[OAMutableURLRequest alloc] initWithURL:url
                                                             consumer:authManager.consumer
                                                                token:authManager.accessToken 
                                                                realm:nil 
                                                    signatureProvider:nil] autorelease];
    [request setHTTPMethod:method];
    [request prepare];
    return request;
}

@end
