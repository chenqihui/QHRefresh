//
//  PullRefreshView.h
//  refreshData
//
//  Created by chen on 14-9-1.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QHRefreshTag.h"

@interface QHPullRefreshView : UIView

@property (nonatomic, retain) UILabel *loadLabel;

@property (nonatomic, assign) PullRefreshTag loadtag;

//实时更新箭头
- (void)qhPullRefreshScrollViewDidScroll:(UIScrollView *)scrollView;

@end
