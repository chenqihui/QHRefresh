//
//  LoadMoreView.h
//  rewardWall
//
//  Created by chen on 14-5-24.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, LoadMoreTag)
{
    kLoadMoreTag_noneData = 1,
    kLoadMoreTag_loading,
    kLoadMoreTag_loaded,
    kLoadMoreTag_loadNoneData,
    kLoadMoreTag_reload,
    kLoadMoreTag_error
};

@interface QHLoadMoreView : UIView

@property (nonatomic, retain) UILabel *loadLabel;

@property (nonatomic, assign) LoadMoreTag loadtag;

@end
