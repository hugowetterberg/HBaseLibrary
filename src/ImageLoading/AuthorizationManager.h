//
//  AuthorizationManager.h
//  Kalendariet
//
//  Created by Hugo Wetterberg on 2009-07-19.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OAConsumer.h"
#import "OAToken.h"
#import "OAServiceTicket.h"
#import "OADataFetcher.h"

@interface AuthorizationManager : NSObject {
    OAConsumer *consumer;
    OAToken *requestToken;
    OAToken *accessToken;
    NSString *requestTokenEndpoint;
    NSString *accessTokenEndpoint;
    NSString *authorizationUrlPattern;
    NSMutableSet *delegates;
}

@property (readonly) OAConsumer *consumer;
@property (readonly) NSMutableSet *delegates;
@property (retain) OAToken *requestToken;
@property (retain) OAToken *accessToken;
@property (retain) NSString *requestTokenEndpoint;
@property (retain) NSString *accessTokenEndpoint;
@property (retain) NSString *authorizationUrlPattern;

-(id)initWithConsumer:(OAConsumer *)consumerObject baseUrl:(NSURL *)baseUrl;
-(id)initWithConsumer:(OAConsumer *)consumerObject requestEndpoint:(NSString *)reqEndpoint accessEndpoint:(NSString *)accEndpoint authorizationUrlPattern:(NSString *)authUrlPattern;
-(void)resetAuthorization;
-(BOOL)hasAccess;
-(void)getRequestToken;
-(void)getRequestTokenFromEndpoint:(NSURL *)endpoint;
-(void)getAccessToken;
-(void)getAccessTokenFromEndpoint:(NSURL *)endpoint;

@end
