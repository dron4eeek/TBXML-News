//
//  TBNewsCell.m
//  TBXML News
//
//  Created by Developer on 2/25/14.
//  Copyright (c) 2014 a.molchanovskiy. All rights reserved.
//

#import "TBNewsCell.h"
#import "NewsItem.h"
#import "UILabel+dynamicSizeMe.h"
#import "UIView+Attach.h"
#import "UIView+Frame.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ResizeMagick.h"
#import "SDWebImageManager.h"
#import "UITableViewCell+Helpers.h"

@interface TBNewsCell () <SDWebImageManagerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *photoImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation TBNewsCell


- (void)populateCellWithModel:(NewsItem*)model
{
  self.nameLabel.text = model.title;
  [self.nameLabel resizeToFit];
  self.dateLabel.text = model.date;
  [self.dateLabel attachBelow:self.nameLabel distance:10];
  self.photoImage.image = nil;
  
  
  __weak typeof (self) weakSelf = self;
  SDWebImageManager *manager = [SDWebImageManager sharedManager];
  [manager downloadWithURL:[NSURL URLWithString:model.imageLink] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
  } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
    UIImage * resizedImage = [image resizedImageByMagick:@"123x80#"];
    weakSelf.photoImage.image = resizedImage;
  }];
}


- (float)populateCellForGetHeightWithModel:(NewsItem*)model
{
  [self populateCellWithModel:model];
  float selfHeight;
  selfHeight = self.dateLabel.y + self.dateLabel.height;
  if (selfHeight > 80)
  {
    self.photoImage.height = selfHeight;
    self.photoImage.image = [self.photoImage.image resizedImageByMagick:[NSString stringWithFormat:@"123x%d#", (int)selfHeight]];
    return selfHeight;
  }
  return 80;
}
@end
