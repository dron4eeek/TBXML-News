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

#define DETAILED_VIEW_SEGUE @"DETAILED_VIEW_SEGUE"

@interface TBMainViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *rssNews;

@end

@implementation TBMainViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
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

- (void)didDownloadImage:(APIDownload*)request {
  NewsItem *newsItem = [self.rssNews objectAtIndex:request.tag];
  newsItem.image = [UIImage imageWithData:request.downloadData];
  
  [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.rssNews count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//  static NSString *CellIdentifier = @"Cell";
  
//  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//  if (cell == nil) {
//    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
//                                  reuseIdentifier:CellIdentifier];
//    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
//  }
  TBNewsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
  NewsItem *newsItem = [self.rssNews objectAtIndex:indexPath.row];
  [cell popilateCellWithModel:newsItem];
//  cell.textLabel.text = newsItem.title;
//  cell.detailTextLabel.text = newsItem.date;
//  cell.imageView.image = newsItem.image;
//  
//  if (!cell.imageView.image)
//  {
//    APIDownload *request = [APIDownload downloadWithURL:newsItem.imageLink
//                                               delegate:self
//                                                    sel:@selector(didDownloadImage:)];
//    request.tag = indexPath.row;
//  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NewsItem *newsItem = [self.rssNews objectAtIndex:indexPath.row];
  [self performSegueWithIdentifier:DETAILED_VIEW_SEGUE sender:newsItem];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:DETAILED_VIEW_SEGUE])
  {
    TBDetailViewController *detailViewController = (TBDetailViewController*)segue.destinationViewController;
    NewsItem * item = (NewsItem*)sender;
    detailViewController.description = item.description;
  }
}

@end
