//
//  TBNewsCell.h
//  TBXML News
//
//  Created by Developer on 2/25/14.
//  Copyright (c) 2014 a.molchanovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsItem;

@protocol TBNewsCellDelegate  <NSObject>

@required
- (void)updateCellAfterImageDownloadedAtIndexPath:(NSIndexPath*)indexPath;

@end


@interface TBNewsCell : UITableViewCell

@property (nonatomic, strong) id <TBNewsCellDelegate> delegate;

- (void)populateCellWithModel:(NewsItem*)model;
- (float)populateCellForGetHeightWithModel:(NewsItem*)model;


@end
