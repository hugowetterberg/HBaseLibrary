//
//  NSDictionary.m
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-09-14.
//  Copyright 2010 Hugo Wetterberg. All rights reserved.
//

#import "NSMutableDictionary+HTTPParameters.h"
#import "NSString+URLEncoding.h"

@implementation NSMutableDictionary  (HTTPParameters)

- (NSString *)asHTTPParameters {
    NSArray *keys = [self allKeys];
    if (keys && keys.count) {
        NSMutableString *query = [[NSMutableString alloc] initWithString:@"?"];
        for (int i=0; i<keys.count; i++) {
            NSString *key = [keys objectAtIndex:i];
            if (i) {
                [query appendFormat:@"&%@=%@", [key URLEncodedString], [(NSString *)[self objectForKey:key] URLEncodedString]];
            }
            else {
                [query appendFormat:@"%@=%@", [key URLEncodedString], [(NSString *)[self objectForKey:key] URLEncodedString]];
            }
        }
        return [query autorelease];
    }
    return @"";
}

@end
