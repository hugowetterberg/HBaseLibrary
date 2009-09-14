//
//  HTMLDecode.m
//  HBaseLibrary
//
//  Created by Hugo Wetterberg on 2009-08-14.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import "NSString+HTMLDecode.h"
#import "entities.h"

@implementation NSString (HTMLDecode)

- (NSString *)HTMLDecode {
    const char *source = [self UTF8String];
    char buffer[strlen(source)+1];
    decode_html_entities_utf8(buffer, source);
    NSString *decoded = [NSString stringWithUTF8String:buffer];
    return decoded;
}

@end
