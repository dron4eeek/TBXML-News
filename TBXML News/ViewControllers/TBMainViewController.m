//
//  TBViewController.m
//  TBXML News
//
//  Created by Developer on 2/25/14.
//  Copyright (c) 2014 a.molchanovskiy. All rights reserved.
//

#import "TBMainViewController.h"
#import "TBDetailViewController.h"
#import "TBNewsCell.h"
#import "APIDownload.h"
#import "TBXML.h"
#import "NewsItem.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ResizeMagick.h"

@interface TBMainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *rssNews;

@end

@implementation TBMainViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = @"TBXML PARSING";
  
  [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TBNewsCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TBNewsCell"];
  [APIDownload downloadWithURL:@"http://imaladec.com/rss.php" delegate:self];
}

- (void)APIDownload:(APIDownload*)request {
  TBXML *tbxml = [TBXML tbxmlWithXMLData:request.downloadData];
  TBXMLElement *root = tbxml.rootXMLElement;
  
  if (root) {
    
    TBXMLElement *channel = [TBXML childElementNamed:@"channel" parentElement:root];
    if (channel) {
      
      self.rssNews = [NSMutableArray array];
      
      TBXMLElement *item = [TBXML childElementNamed:@"item" parentElement:channel];
      while (item) {
        TBXMLElement *title = [TBXML childElementNamed:@"title" parentElement:item];
        TBXMLElement *link = [TBXML childElementNamed:@"link" parentElement:item];
        TBXMLElement *description = [TBXML childElementNamed:@"description" parentElement:item];
        TBXMLElement *image = [TBXML childElementNamed:@"image" parentElement:item];
        TBXMLElement *date = [TBXML childElementNamed:@"pubDate" parentElement:item];
        
        NewsItem *newsItem = [NewsItem new];
        newsItem.title = [TBXML textForElement:title];
        newsItem.link = [TBXML textForElement:link];
        newsItem.description = [TBXML textForElement:description];
        newsItem.date = [TBXML textForElement:date];
        newsItem.imageLink = [[TBXML textForElement:image] stringByReplacingOccurrencesOfString:@"/upload-files/"
                                                                                     withString:@"http://imaladec.com/upload-files/"];
        
        [self.rssNews addObject:newsItem];
        
        item = [TBXML nextSiblingNamed:@"item" searchFromElement:item];
      }
    }
  }
  [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.rssNews count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  TBNewsCell * cell = (TBNewsCell*)[tableView dequeueReusableCellWithIdentifier:@"TBNewsCell"];
  NewsItem *newsItem = [self.rssNews objectAtIndex:indexPath.row];
  return [cell populateCellForGetHeightWithModel:newsItem];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  TBNewsCell * cell = (TBNewsCell*)[tableView dequeueReusableCellWithIdentifier:@"TBNewsCell"];
  NewsItem *newsItem = [self.rssNews objectAtIndex:indexPath.row];
  [cell populateCellWithModel:newsItem];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NewsItem *newsItem = [self.rssNews objectAtIndex:indexPath.row];
  TBDetailViewController *detailViewController = [TBDetailViewController new];
  detailViewController.description = newsItem.description;
  [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
