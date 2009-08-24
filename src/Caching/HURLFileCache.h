//
//  HURLCache.h
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-08-10.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSimpleURLCache.h"

@interface HURLFileCache : NSObject <HSimpleURLCache> {
    NSString *cachePath;
    id<HSimpleURLCache> memoryCache;
}

- (id)init;
- (id)initWithMemoryCache:(id<HSimpleURLCache>)memoryCacheOrNil;
- (NSString *)pathForUrl:(NSURL *)url;

@end
