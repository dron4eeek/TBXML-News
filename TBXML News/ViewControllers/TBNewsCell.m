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
#import "UIImageView+WebCache.h"
#import "UIImage+ResizeMagick.h"
#import "SDWebImageManager.h"

@interface TBNewsCell ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end
@implementation TBNewsCell


- (void)popilateCellWithModel:(NewsItem*)model
{
  self.nameLabel.text = model.title;
  [self.nameLabel resizeToFit];
  self.dateLabel.text = model.date;
  [self.dateLabel attachBelow:self.nameLabel distance:10];

    __weak typeof(self) weakSelf = self;
     dispatch_async(dispatch_get_main_queue(), ^{
      [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:model.imageLink]
                                                 options:SDWebImageRefreshCached
                                                progress:^(NSInteger receivedSize, NSInteger expectedSize)
      {
        NSLog(@"%ld",(long)receivedSize);
                                                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
                                                  if(error)
                                                  {
                                                    
                                                  }
                                                  else
                                                  {
                                                    weakSelf.imageView.image = [image resizedImageByMagick: @"100x79#"];

                                                  }
                                                }];
     });

  

}

@end
