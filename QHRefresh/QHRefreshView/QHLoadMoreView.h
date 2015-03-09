//
//  LoadMoreView.h
//  rewardWall
//
//  Created by chen on 14-5-24.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QHRefreshTag.h"

@interface QHLoadMoreView : UIView

@property (nonatomic, retain) UILabel *loadLabel;

@property (nonatomic, assign) LoadMoreTag loadtag;

@end
