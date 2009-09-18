//
//  HCache.h
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-08-10.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSimpleCache.h"

@interface HCache : NSObject {

}

+ (id<HSimpleCache>) sharedCache;
+ (void) setSharedCache:(id<HSimpleCache>)cache;

@end
