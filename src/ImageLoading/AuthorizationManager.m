//
//  AuthorizationManager.m
//  Kalendariet
//
//  Created by Hugo Wetterberg on 2009-07-19.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import "AuthorizationManager.h"

@implementation AuthorizationManager

@synthesize consumer, requestToken, accessToken, delegates, requestTokenEndpoint, accessTokenEndpoint, authorizationUrlPattern;

-(id)initWithConsumer:(OAConsumer *)consumerObject baseUrl:(NSURL *)baseUrl {
    NSString *absoluteBase = [baseUrl absoluteString];
    NSString *reqEndpoint = [NSString stringWithFormat:@"%@/oauth/request_token", absoluteBase];
    NSString *accEndpoint = [NSString stringWithFormat:@"%@/oauth/access_token", absoluteBase];
    NSString *authUrlPattern = [NSString stringWithFormat:@"%@/oauth/authorize?oauth_token=%%@", absoluteBase];
    return [self initWithConsumer:consumerObject requestEndpoint:reqEndpoint accessEndpoint:accEndpoint authorizationUrlPattern:authUrlPattern];
}

-(id)initWithConsumer:(OAConsumer *)consumerObject requestEndpoint:(NSString *)reqEndpoint accessEndpoint:(NSString *)accEndpoint authorizationUrlPattern:(NSString *)authUrlPattern {
    self = [super init];
    
    if (self) {
        consumer = [consumerObject retain];
        
        self.requestTokenEndpoint = [reqEndpoint retain];
        self.accessTokenEndpoint = [accEndpoint retain];
        self.authorizationUrlPattern = [authUrlPattern retain];

        // Get tokens
        NSArray *requestTokenSetting = [[NSUserDefaults standardUserDefaults] arrayForKey:@"RequestToken"];
        if (requestTokenSetting) {
            requestToken = [[OAToken alloc] 
                            initWithKey:(NSString*)[requestTokenSetting objectAtIndex:0] 
                            secret:(NSString*)[requestTokenSetting objectAtIndex:1]];
        }
        
        NSArray *accessTokenSetting = [[NSUserDefaults standardUserDefaults] arrayForKey:@"AccessToken"];
        if (accessTokenSetting) {
            accessToken = [[OAToken alloc] 
                           initWithKey:(NSString*)[accessTokenSetting objectAtIndex:0] 
                           secret:(NSString*)[accessTokenSetting objectAtIndex:1]];
        }
        
        delegates = [[NSMutableSet alloc] init];
    }
    return self;
}

-(void)resetAuthorization {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RequestToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AccessToken"];
    
    self.requestToken = nil;
    self.accessToken = nil;
}

-(BOOL)hasAccess {
    return !!accessToken;
}

-(void)getRequestToken {
    NSURL *endpoint = [NSURL URLWithString:self.requestTokenEndpoint];
    return [self getRequestTokenFromEndpoint:endpoint];
}

-(void)getRequestTokenFromEndpoint:(NSURL *)endpoint {
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] 
                                    initWithURL:endpoint
                                    consumer:consumer
                                    token:nil   // we don't have a Token yet
                                    realm:nil   // our service provider doesn't specify a realm
                                    signatureProvider:nil]; // use the default method, HMAC-SHA1
	[request setHTTPMethod:@"POST"];
	
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not get token" message:@"Failed to get the request token from the server." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
	if (ticket.didSucceed) {
		NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        OAToken *token = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		self.requestToken = token;
        [token release];
        [responseBody release];
        responseBody = nil;
        
        if (self.requestToken) {
            // Persist our token
            NSArray *tokenSetting = [[NSArray alloc] initWithObjects:self.requestToken.key, self.requestToken.secret, nil];
            [[NSUserDefaults standardUserDefaults] setObject:tokenSetting forKey:@"RequestToken"];
            [tokenSetting release];
            
            NSString *urlString = [NSString stringWithFormat:self.authorizationUrlPattern, requestToken.key];
            NSLog(@"%@", urlString);
            NSURL *url = [NSURL URLWithString:urlString];
            
            [[UIApplication sharedApplication] openURL:url];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not get token" message:@"Failed to get the request token from the server." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
	}
}

-(void)getAccessToken {
    NSURL *endpoint = [NSURL URLWithString:self.accessTokenEndpoint];
    return [self getAccessTokenFromEndpoint:endpoint];
}

-(void)getAccessTokenFromEndpoint:(NSURL *)endpoint {
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] 
                                    initWithURL:endpoint
                                    consumer:consumer
                                    token:requestToken   // Use the request token to fetch our access token
                                    realm:nil   // our service provider doesn't specify a realm
                                    signatureProvider:nil]; // use the default method, HMAC-SHA1
	[request setHTTPMethod:@"POST"];
	
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestAccessToken:didFinishWithData:)
                  didFailSelector:@selector(requestAccessToken:didFailWithError:)];    
}

- (void)requestAccessToken:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not get token" message:@"Failed to get the access token from the server." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)requestAccessToken:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    if (ticket.didSucceed) {
		NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        OAToken *token = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		self.accessToken = token;
        [responseBody release];
        [token release];
        responseBody = nil;
        token = nil;
        
        if (self.accessToken) {
            NSArray *tokenSetting = [[NSArray alloc] initWithObjects:self.accessToken.key, self.accessToken.secret, nil];
            [[NSUserDefaults standardUserDefaults] setObject:tokenSetting forKey:@"AccessToken"];
            [tokenSetting release];
            
            // Let go of the request token, it's spent
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RequestToken"];
            [requestToken release];
            requestToken = nil;
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not get token" message:@"Failed to get the access token from the server." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
	}
}

-(void)dealloc {
    [consumer release];
    [requestToken release];
    [accessToken release];
    [accessTokenEndpoint release];
    [requestTokenEndpoint release];
    [authorizationUrlPattern release];
    [super dealloc];
}

@end
