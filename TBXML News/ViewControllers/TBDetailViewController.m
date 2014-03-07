//
//  TBDetailViewController.m
//  TBXML News
//
//  Created by Developer on 2/25/14.
//  Copyright (c) 2014 a.molchanovskiy. All rights reserved.
//

#import "TBDetailViewController.h"
#import "NewsItem.h"

@interface TBDetailViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TBDetailViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.description = [self.description stringByReplacingOccurrencesOfString:@"/upload-files/"
                                                                 withString:@"http://imaladec.com/upload-files/"];
  [self.webView loadHTMLString:self.description baseURL:nil];
}

@end
