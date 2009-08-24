/*
 *  entities.h
 *  HBaseLibrary
 *
 *  Created by Hugo Wetterberg on 2009-08-16.
 *
 *  I have to track down the source of this code. I think
 *  that I found it at Stack Overflow.
 */

#ifndef _DECODE_HTML_ENTITIES_UTF8
#define _DECODE_HTML_ENTITIES_UTF8

#include <stddef.h>

extern size_t decode_html_entities_utf8(char * dest, const char * src);

#endif