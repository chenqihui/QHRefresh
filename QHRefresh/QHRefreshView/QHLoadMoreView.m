//
//  LoadMoreView.m
//  rewardWall
//
//  Created by chen on 14-5-24.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "QHLoadMoreView.h"

@interface QHLoadMoreView ()
{
    UIActivityIndicatorView *_activityLoading;
}

@end

@implementation QHLoadMoreView

- (void)dealloc
{
    [_loadLabel release];
    [_activityLoading release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        [self setBackgroundColor:[UIColor redColor]];
        UIFont *font = [UIFont systemFontOfSize:16];
        CGSize s;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
            s = [@"陈陈陈陈陈陈" sizeWithAttributes:@{NSFontAttributeName:font}];
        else
            s = [@"陈陈陈陈陈陈" sizeWithFont:font];
        _loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, s.width * 2, s.height)];
        [_loadLabel setBackgroundColor:[UIColor clearColor]];
        _loadLabel.center = self.center;
        [_loadLabel setFont:font];
        [_loadLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_loadLabel];
        
        _activityLoading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityLoading setFrame:CGRectMake(0, _loadLabel.top, s.height, s.height)];
        _activityLoading.right = _loadLabel.left + s.width/2;
        [self addSubview:_activityLoading];
        [_activityLoading setHidesWhenStopped:YES];
        
        _loadtag = kLoadMoreTag_loaded;
        
    }
    return self;
}

- (void)setLoadtag:(LoadMoreTag)loadtag
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
        case kLoadMoreTag_noneData:
            [_loadLabel setTextColor:[UIColor grayColor]];
            [_loadLabel setText:@"暂无数据"];
            break;
        case kLoadMoreTag_loaded:
            [_loadLabel setText:@"拉动获取更多"];
            break;
        case kLoadMoreTag_loading:
            [_loadLabel setText:@"加载中..."];
            [_activityLoading startAnimating];
            break;
        case kLoadMoreTag_loadNoneData:
            [_loadLabel setText:@"已到达最底部"];
            break;
        case kLoadMoreTag_reload:
            [_loadLabel setText:@"加载失败，重新拉动获取"];
            break;
        case kLoadMoreTag_error:
            [_loadLabel setText:@"无法加载，请检查网络"];
            break;
    }
}

@end
