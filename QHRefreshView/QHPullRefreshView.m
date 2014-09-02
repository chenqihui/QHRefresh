//
//  PullRefreshView.m
//  refreshData
//
//  Created by chen on 14-9-1.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "QHPullRefreshView.h"

@interface QHPullRefreshView ()
{
    UIActivityIndicatorView *_activityLoading;
}

@end

@implementation QHPullRefreshView

- (void)dealloc
{
    [_loadLabel release];
    [_activityLoading release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
//    self.backgroundColor = [UIColor orangeColor];
    if (self) {
        // Initialization code
        //        [self setBackgroundColor:[UIColor redColor]];
        UIFont *font = [UIFont systemFontOfSize:16];
        CGSize s;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
            s = [@"陈陈陈陈陈陈" sizeWithAttributes:@{NSFontAttributeName:font}];
        else
            s = [@"陈陈陈陈陈陈" sizeWithFont:font];
        _loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.height - s.height)/2, s.width * 2, s.height)];
        [_loadLabel setBackgroundColor:[UIColor clearColor]];
        _loadLabel.centerX = self.centerX;
        [_loadLabel setFont:font];
        [_loadLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_loadLabel];
        
        _activityLoading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityLoading setFrame:CGRectMake(0, _loadLabel.top, s.height, s.height)];
        _activityLoading.right = _loadLabel.left + s.width/2;
        [self addSubview:_activityLoading];
        [_activityLoading setHidesWhenStopped:YES];
        
//        _loadtag = kRefreshTag_loaded;
        [self setLoadtag:kRefreshTag_loaded];
        
    }
    return self;
}

- (void)setLoadtag:(RefreshTag)loadtag
{
    _loadtag = loadtag;
    __async_main__, ^
    {
        [self changeLoadMore];
    });
}

- (void)changeLoadMore
{
    if ([_activityLoading isAnimating])
        [_activityLoading stopAnimating];
    
    [_loadLabel setTextColor:[UIColor blackColor]];
    
    switch (_loadtag)
    {
        case kRefreshTag_loaded:
            [_loadLabel setText:@"下拉刷新"];
            break;
        case kRefreshTag_loading:
            [_loadLabel setText:@"刷新中..."];
            [_activityLoading startAnimating];
            break;
        case kRefreshTag_willloading:
            [_loadLabel setText:@"松手刷新"];
            break;
        case kRefreshTag_finish:
            [_loadLabel setText:@"刷新完成"];
            break;
        case kRefreshTag_error:
            [_loadLabel setText:@"刷新失败"];
            break;
    }
}

@end
