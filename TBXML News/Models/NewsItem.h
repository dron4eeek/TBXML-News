//
//  NewsItem.h
//  RSSiMaladec
//
//  Created by Alximik on 09.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsItem : NSObject

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * link;
@property (nonatomic, strong) NSString * description;
@property (nonatomic, strong) NSString * date;
@property (nonatomic, strong) NSString * imageLink;
@property (nonatomic, strong) UIImage * image;

@end
