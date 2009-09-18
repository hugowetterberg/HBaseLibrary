//
//  HCache.h
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-08-10.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSimpleCache.h"

@interface HFileCache : NSObject <HSimpleCache> {
    NSString *cachePath;
    id<HSimpleCache> memoryCache;
}

- (id)init;
- (id)initWithMemoryCache:(id<HSimpleCache>)memoryCacheOrNil;
- (NSString *)pathForKey:(NSString *)key;

@end
