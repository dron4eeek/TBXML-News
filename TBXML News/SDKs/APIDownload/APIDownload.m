//
//  APIDownload.m
//  Download
//
//  Created by Alximik on 08.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "APIDownload.h"

@implementation APIDownload

@synthesize delegate;
@synthesize tag;
@synthesize downloadData;
@synthesize response;
@synthesize connection;


- (void)dealloc {
    self.downloadData = nil;
    self.response = nil;
    self.connection = nil;
    [super dealloc];
}

+ (id)downloadWithURL:(NSString*)url delegate:(id)delegate sel:(SEL)selector {
    APIDownload *request = [APIDownload downloadWithURL:url delegate:delegate];
    [request setSuccessSelector:selector];
    return request;
}

+ (id)downloadWithURL:(NSString*)url delegate:(id)delegate {
    APIDownload *request = [[APIDownload alloc] init];
    request.delegate = delegate;
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *dounloadURL = [NSURL URLWithString:url];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:dounloadURL
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0f];
    
    request.connection = [[[NSURLConnection alloc] initWithRequest:theRequest delegate:request] autorelease];
    if (request.connection) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        request.downloadData = [NSMutableData data];
    } else {
        NSLog(@"Connection failed");
    }
    
    return [request autorelease];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse
{
    if ([aResponse expectedContentLength]) {
        self.response = aResponse;
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [downloadData appendData:data];
    
    if (self.response)
	{
		CGFloat expectedLength = [self.response expectedContentLength];
		CGFloat currentLength = downloadData.length;
		CGFloat percent = currentLength / expectedLength;
        
        SEL selector = @selector(dataDownloadAtPercent:);
        if (delegate && [delegate respondsToSelector:selector]) {
            [delegate performSelector:selector withObject:[NSNumber numberWithFloat:percent]];
        }
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    
	if (!successSelector) {
		successSelector = @selector(APIDownload:);
	}
	if ([delegate respondsToSelector:successSelector]) {
		[delegate performSelector:successSelector withObject:self];
	}    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)setSuccessSelector:(SEL)selector {
	successSelector = selector;
}

- (void)cancel {
    [connection cancel];
}

@end
