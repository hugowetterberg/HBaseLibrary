//
//  OAuthRESTClientDelegate.h
//  DrupalREST
//
//  Created by Hugo Wetterberg on 2009-08-03.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RESTClientDelegate.h"
#import "AuthorizationManager.h"
#import "RESTClient.h"

@interface OAuthRESTClientDelegate : NSObject <RESTClientDelegate> {
    AuthorizationManager *authManager;
}

-(id)initWithAuthorizationManager:(AuthorizationManager *)aAuthManager;

@end
