//
//  RESTClientCachePolicy.h
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-09-17.
//  Copyright 2010 Hugo Wetterberg. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RESTClientCachePolicy : NSObject <NSCopying> {
    BOOL useCache;
    NSTimeInterval maxAge;
    BOOL serveStale;
    NSString *cacheKey;
}

@property (assign) BOOL useCache;
@property (assign) NSTimeInterval maxAge;
@property (assign) BOOL serveStale;
@property (retain, nonatomic) NSString* cacheKey;

+ (RESTClientCachePolicy *)noCaching;

- (id)initWithUseCache:(BOOL)shouldUseCache maxAge:(NSTimeInterval)age serveStale:(BOOL)shouldServeStale;

@end
