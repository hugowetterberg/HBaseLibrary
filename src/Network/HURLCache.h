//
//  HURLCache.h
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-08-10.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSimpleURLCache.h"

@interface HURLCache : NSObject {

}

+ (id<HSimpleURLCache>) sharedCache;
+ (void) setSharedCache:(id<HSimpleURLCache>)cache;

@end
