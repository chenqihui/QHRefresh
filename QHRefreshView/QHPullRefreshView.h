//
//  PullRefreshView.h
//  refreshData
//
//  Created by chen on 14-9-1.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, RefreshTag)
{
    kRefreshTag_loading,
    kRefreshTag_loaded,
    kRefreshTag_willloading,
    kRefreshTag_finish,
    kRefreshTag_error
};

@interface QHPullRefreshView : UIView

@property (nonatomic, retain) UILabel *loadLabel;

@property (nonatomic, assign) RefreshTag loadtag;

//实时更新箭头
- (void)qhRefreshScrollViewDidScroll:(UIScrollView *)scrollView;

@end
