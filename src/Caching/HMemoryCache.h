//
//  HMemoryCache.h
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-08-10.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSimpleCache.h"

@interface HMemoryCache : NSObject <HSimpleCache> {
    int memLimit;
    int cacheableLimit;
    int usedMemory;
    NSMutableDictionary *cache;
    NSMutableArray *queue;
}

- (id)initWithMemoryLimit:(int)memoryLimit maxCacheableSize:(int)maxCacheable;

@end
