//
//  TBNewsCell.h
//  TBXML News
//
//  Created by Developer on 2/25/14.
//  Copyright (c) 2014 a.molchanovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsItem;
@interface TBNewsCell : UITableViewCell

- (void)popilateCellWithModel:(NewsItem*)model;

@end
