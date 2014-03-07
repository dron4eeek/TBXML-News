//
//  APIDownload.h
//  Download
//
//  Created by Alximik on 08.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIDownload : NSObject {
    id delegate;
    NSInteger tag;
    NSMutableData *downloadData;
    NSURLResponse *response;
    NSURLConnection *connection;
    
    SEL successSelector;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, retain) NSMutableData *downloadData;
@property (nonatomic, retain) NSURLResponse *response;
@property (nonatomic, retain) NSURLConnection *connection;

+ (id)downloadWithURL:(NSString*)url delegate:(id)delegate sel:(SEL)selector;
+ (id)downloadWithURL:(NSString*)url delegate:(id)delegate;

- (void)setSuccessSelector:(SEL)selector;
- (void)cancel;

@end