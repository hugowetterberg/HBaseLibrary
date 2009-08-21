//
//  AsyncImageViewTableCell.m
//  Kalendariet
//
//  Created by Hugo Wetterberg on 2009-07-23.
//  Copyright 2009 Hugo Wetterberg. All rights reserved.
//

#import "AsyncImageLoader.h"
#import "HURLCache.h"
#import "AsyncImageLoaderDelegate.h"

@interface AsyncImageLoader (Private)

- (UIImage *)getIfCached:(NSURL *)aUrl;

@end


@implementation AsyncImageLoader

@synthesize delegate;

- (id)init {
    self = [super init];
    if (self) {
        // Nothing here right now
    }
    return self;
}

- (void)loadImageFromURL:(NSURL*)aUrl {
    [self loadImageFromURL:aUrl targetSize:CGSizeZero];
}

- (void)loadImageFromURL:(NSURL*)aUrl targetSize:(CGSize)aTargetSize {
    NSLog(@"Load requested for %fx%f of %@", aTargetSize.width, aTargetSize.height, aUrl);
    [connection cancel];
    [connection release];
    connection = nil;
    targetSize = aTargetSize;
    [data release];
    data = [[NSMutableData alloc] init];
    
    UIImage *img = nil;
    url = [aUrl retain];
    if (targetSize.width > 0.0) {
        resizedUrl = [[NSURL URLWithString:[NSString stringWithFormat:@"#%fx%f", targetSize.width, targetSize.height] 
                      relativeToURL:aUrl] retain];
        NSLog(@"%@", [resizedUrl absoluteString]);
        img = [self getIfCached:resizedUrl];
    }
    else {
        resizedUrl = nil;
        img = [self getIfCached:url];
    }
    
    if (img) { // Pass on the image to the delegate if it was in the cache
        NSLog(@"Async image loader cache hit for %@", url);
        if ([delegate respondsToSelector:@selector(asyncImageLoader:imageDidLoad:)]) {
            [delegate asyncImageLoader:self imageDidLoad:img];
        }
    }
    else { // Otherwise we'll just have to load it
        NSLog(@"Started async loading of %@", url);
        request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

- (UIImage *)getIfCached:(NSURL *)aUrl {
    return [[HURLCache sharedCache] getImageForUrl:aUrl];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)urlResponse {
    [data setLength:0];
}

//the URL connection calls this repeatedly as data arrives
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
    [data appendData:incrementalData];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [delegate asyncImageLoader:self didFailWithError:error];
}

//the URL connection calls this once all the data has downloaded
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    NSLog(@"Async loading of %@ finished", url);
    //so self data now has the complete image
    [connection release];
    connection = nil;
    
    [[HURLCache sharedCache] storeData:data forUrl:url];
    
    //make an image view for the image
    UIImage *img = [UIImage imageWithData:data];
    if (img) {
        // Resize if requested and if a resize is needed (we don't do upscaling)
        if (targetSize.width && (targetSize.width < img.size.width || targetSize.height < img.size.height)) {
            img = [AsyncImageLoader resizeImage:img toFillFrame:targetSize];
            [[HURLCache sharedCache] storeData:UIImageJPEGRepresentation(img, 0.6) forUrl:resizedUrl];
        }
        [delegate asyncImageLoader:self imageDidLoad:img];
    }
}

+ (UIImage *)resizeImage:(UIImage *)image toFillFrame:(CGSize)frame {
    if (frame.width == 0) {
        return image;
    }
    
    CGSize original = image.size;
    CGSize scaled;
    
    float xratio = original.width / frame.width;
    float yratio = original.height / frame.height;
    
    if (xratio <= yratio) {
        scaled = CGSizeMake(original.width / xratio, original.height / xratio);
    }
    else {
        scaled = CGSizeMake(original.width / xratio, original.height / xratio);
    }
    
    CGImageRef imageRef = [image CGImage];
	CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
	CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();
    
    if (alphaInfo == kCGImageAlphaNone)
		alphaInfo = kCGImageAlphaNoneSkipLast;
	
	CGContextRef bitmap = CGBitmapContextCreate(NULL, scaled.width, scaled.height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);
    CGContextDrawImage(bitmap, CGRectMake(0, 0, scaled.width, scaled.height), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    
    UIImage *resized = [UIImage imageWithCGImage:ref];
    
    CGColorSpaceRelease(colorSpaceInfo);
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return resized;
}

- (void)dealloc {
    [connection cancel]; //in case the URL is still downloading
    [connection release];
    [data release];
    [request release];
    [super dealloc];
}

@end
