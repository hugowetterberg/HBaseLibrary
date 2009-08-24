/*
 *  entities.h
 *  HBaseLibrary
 *
 *  Created by Hugo Wetterberg on 2009-08-16.
 *
 *  Written by Cristoph http://stackoverflow.com/users/48015/christoph
 *  at Stack Overflow: http://stackoverflow.com/questions/1082162/how-to-unescape-html-in-c
 *  License: http://creativecommons.org/licenses/by-sa/2.5/
 */

#ifndef _DECODE_HTML_ENTITIES_UTF8
#define _DECODE_HTML_ENTITIES_UTF8

#include <stddef.h>

extern size_t decode_html_entities_utf8(char * dest, const char * src);

#endif