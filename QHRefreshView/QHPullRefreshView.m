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
    UIImageView *_arrowImageView;
    
    float m;
}

@end

@implementation QHPullRefreshView

- (void)dealloc
{
    [_loadLabel release];
    [_activityLoading release];
    [_arrowImageView release];
    
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
        
        UIImage *image = [UIImage imageNamed:@"blackArrow.png"];
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_activityLoading.left, 5, _activityLoading.width, self.height - 10)];
        _arrowImageView.image = image;
        [self addSubview:_arrowImageView];
        
//        _loadtag = kRefreshTag_loaded;
        [self setLoadtag:kRefreshTag_loaded];
        
        m = M_PI/self.height;
        
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
            [_arrowImageView setHidden:NO];
            [UIView beginAnimations:nil context:nil];
            _arrowImageView.transform = CGAffineTransformIdentity;
            [UIView commitAnimations];
            [_loadLabel setText:@"下拉刷新"];
            break;
        case kRefreshTag_loading:
            [_loadLabel setText:@"刷新中..."];
            [_arrowImageView setHidden:YES];
            [_activityLoading startAnimating];
            break;
        case kRefreshTag_willloading:
            [UIView beginAnimations:nil context:nil];
            _arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
            [UIView commitAnimations];
            [_loadLabel setText:@"松手刷新"];
            break;
        case kRefreshTag_finish:
            _arrowImageView.transform = CGAffineTransformIdentity;
            [_loadLabel setText:@"刷新完成"];
            break;
        case kRefreshTag_error:
            _arrowImageView.transform = CGAffineTransformIdentity;
            [_loadLabel setText:@"刷新失败"];
            break;
    }
}

- (void)qhRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    float f = scrollView.contentOffset.y;
    if (f < 0)
    {
        if (f > -self.height)
        {
            float r = (-f) * m;
            _arrowImageView.transform = CGAffineTransformMakeRotation(r);
        }
    }
}

@end
