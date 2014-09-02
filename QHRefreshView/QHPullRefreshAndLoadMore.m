//
//  PullRefreshAndLoadMoreView.m
//  refreshData
//
//  Created by chen on 14-9-2.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "QHPullRefreshAndLoadMore.h"

@interface QHPullRefreshAndLoadMore ()
{
    UIView *_pullRefreshView;
    UILabel *_pullRefreshLabel;
    UIActivityIndicatorView *_pullRefreshActivity;
    UIImageView *_arrowImageView;
    float nRotation;
    
    UIView *_loadMoreView;
    UILabel *_loadMoreLabel;
    UIActivityIndicatorView *_loadMoreActivity;
    
    QHRefreshHeaderViewPresentType _pressentType;
}

@property (nonatomic, assign) PullRefreshTag pullRefreshTag;
@property (nonatomic, assign) LoadMoreTag loadMoreTag;
@property (nonatomic, assign) id<QHPullRefreshAndLoadMoreDelegate> pullAndLoadDelegate;

@end

@implementation QHPullRefreshAndLoadMore

+ (CGSize)refreshSizeWithString:(NSString *)str withFont:(UIFont *)font
{
    CGSize s;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
        s = [str sizeWithAttributes:@{NSFontAttributeName:font}];
    else
        s = [str sizeWithFont:font];
    
    return s;
}

- (void)dealloc
{
    [_pullRefreshView release];
    [_pullRefreshLabel release];
    [_pullRefreshActivity release];
    [_arrowImageView release];
    
    [_loadMoreView release];
    [_loadMoreLabel release];
    [_loadMoreActivity release];
    
    [super dealloc];
}

- (id)initRefreshWithScroll:(UIScrollView *)view pullRefreshView:(CGFloat)nPullRefreshViewHeight presentType:(QHRefreshHeaderViewPresentType)type loadMoreView:(CGFloat)nLoadMoreViewHeight delegate:(id<QHPullRefreshAndLoadMoreDelegate>)delegate titile:(NSArray *)arTitile
{
    NSArray *ar = arTitile;
    if (ar.count == 2 && ar != nil)
    {
        NSArray *arPullRefresh = [ar objectAtIndex:0];
        if (arPullRefresh != nil && arPullRefresh.count == 5)
        {
            _kPullRefresh_loaded = ((NSString *)[ar objectAtIndex:0]).length > 0 ? (NSString *)[ar objectAtIndex:0] : @"下拉刷新";
            _kPullRefresh_loading = ((NSString *)[ar objectAtIndex:1]).length > 0 ? (NSString *)[ar objectAtIndex:1] : @"刷新中...";
            _kPullRefresh_willloading = ((NSString *)[ar objectAtIndex:2]).length > 0 ? (NSString *)[ar objectAtIndex:2] : @"松手刷新";
            _kPullRefresh_finish = ((NSString *)[ar objectAtIndex:3]).length > 0 ? (NSString *)[ar objectAtIndex:3] : @"刷新完成";
            _kPullRefresh_error = ((NSString *)[ar objectAtIndex:4]).length > 0 ? (NSString *)[ar objectAtIndex:4] : @"刷新失败";
        }
        NSArray *arLoadMore = [ar objectAtIndex:1];
        if (arLoadMore != nil && arLoadMore.count == 6)
        {
            _kLoadMore_noneData = ((NSString *)[ar objectAtIndex:0]).length > 0 ? (NSString *)[ar objectAtIndex:0] : @"暂无数据";
            _kLoadMore_loaded = ((NSString *)[ar objectAtIndex:1]).length > 0 ? (NSString *)[ar objectAtIndex:1] : @"加载更多";
            _kLoadMore_loading = ((NSString *)[ar objectAtIndex:2]).length > 0 ? (NSString *)[ar objectAtIndex:2] : @"刷新中...";
            _kLoadMore_loadNoneData = ((NSString *)[ar objectAtIndex:3]).length > 0 ? (NSString *)[ar objectAtIndex:3] : @"已到达最底部";
            _kLoadMore_reload = ((NSString *)[ar objectAtIndex:4]).length > 0 ? (NSString *)[ar objectAtIndex:4] : @"加载失败，重新拉动获取";
            _kLoadMore_error = ((NSString *)[ar objectAtIndex:5]).length > 0 ? (NSString *)[ar objectAtIndex:5] : @"无法加载，请检查网络";
        }
    }else
    {
        _kPullRefresh_loaded = @"下拉刷新";
        _kPullRefresh_loading = @"刷新中...";
        _kPullRefresh_willloading = @"松手刷新";
        _kPullRefresh_finish = @"刷新完成";
        _kPullRefresh_error = @"刷新失败";
        
        _kLoadMore_noneData = @"暂无数据";
        _kLoadMore_loaded = @"加载更多";
        _kLoadMore_loading = @"刷新中...";
        _kLoadMore_loadNoneData = @"已到达最底部";
        _kLoadMore_reload = @"加载失败，重新拉动获取";
        _kLoadMore_error = @"无法加载，请检查网络";
    }
    return [self initRefreshWithScroll:view pullRefreshView:nPullRefreshViewHeight presentType:type loadMoreView:nLoadMoreViewHeight delegate:delegate];
}

- (id)initRefreshWithScroll:(UIScrollView *)view pullRefreshView:(CGFloat)nPullRefreshViewHeight presentType:(QHRefreshHeaderViewPresentType)type loadMoreView:(CGFloat)nLoadMoreViewHeight delegate:(id<QHPullRefreshAndLoadMoreDelegate>)delegate
{
    self = [super init];
    
    if (self)
    {
        _pullAndLoadDelegate = delegate;
        _pressentType = type;
        
        if (nPullRefreshViewHeight > 0)
        {
            _pullRefreshView = [[UIView alloc] init];
            _pullRefreshView.backgroundColor = [UIColor whiteColor];
            if (_pressentType == QHRefreshHeaderViewPresentTypeBehindTableView)
            {
                _pullRefreshView.frame = CGRectMake(0, 0, view.frame.size.width, nPullRefreshViewHeight);
                [[view superview] insertSubview:_pullRefreshView belowSubview:view];
            }else
            {
                _pullRefreshView.frame = CGRectMake(0, -nPullRefreshViewHeight, view.frame.size.width, nPullRefreshViewHeight);
                [view addSubview:_pullRefreshView];
            }
            
            UIFont *font = [UIFont systemFontOfSize:16];
            CGSize s = [QHPullRefreshAndLoadMore refreshSizeWithString:@"陈陈陈陈陈陈" withFont:font];
            _pullRefreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, s.width * 2, s.height)];
            [_pullRefreshLabel setBackgroundColor:[UIColor clearColor]];
            _pullRefreshLabel.center = CGPointMake(_pullRefreshView.center.x, (_pullRefreshView.frame.size.height - s.height)/2);
            [_pullRefreshLabel setFont:font];
            [_pullRefreshLabel setTextAlignment:NSTextAlignmentCenter];
            [_pullRefreshView addSubview:_pullRefreshLabel];
            
            float nPullRefreshActivityRadius = s.height;
            _pullRefreshActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [_pullRefreshActivity setFrame:CGRectMake(_pullRefreshLabel.frame.origin.x + s.width/2 - nPullRefreshActivityRadius, _pullRefreshLabel.frame.origin.y, nPullRefreshActivityRadius, nPullRefreshActivityRadius)];
            [_pullRefreshActivity setHidesWhenStopped:YES];
            [_pullRefreshView addSubview:_pullRefreshActivity];
            
            UIImage *image = [UIImage imageNamed:@"blackArrow.png"];
            _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_pullRefreshActivity.frame.origin.x - 5, 5, _pullRefreshActivity.frame.size.width, _pullRefreshView.frame.size.height - 10)];
            _arrowImageView.image = image;
            [_pullRefreshView addSubview:_arrowImageView];
            
            self.pullRefreshTag = kPullRefreshTag_loaded;
            nRotation = M_PI/_pullRefreshView.frame.size.height;
        }
        
        if (nLoadMoreViewHeight > 0)
        {
            _loadMoreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, nLoadMoreViewHeight)];
            _loadMoreView.backgroundColor = [UIColor whiteColor];
            if ([view isKindOfClass:UITableView.class])
                ((UITableView *)view).tableFooterView = _loadMoreView;
//            else
//            {
//                _loadMoreView.frame = CGRectMake(0, view.contentSize.height - nLoadMoreViewHeight, view.frame.size.width, nLoadMoreViewHeight);
//                [view addSubview:_loadMoreView];
//            }
            
            UIFont *font = [UIFont systemFontOfSize:16];
            CGSize s = [QHPullRefreshAndLoadMore refreshSizeWithString:@"陈陈陈陈陈陈" withFont:font];
            _loadMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (_loadMoreView.frame.size.height - s.height)/2, s.width * 2, s.height)];
            [_loadMoreLabel setBackgroundColor:[UIColor clearColor]];
            _loadMoreLabel.center = CGPointMake(_loadMoreView.center.x, _loadMoreLabel.center.y);
            [_loadMoreLabel setFont:font];
            [_loadMoreLabel setTextAlignment:NSTextAlignmentCenter];
            [_loadMoreView addSubview:_loadMoreLabel];
            
            float nLoadMoreActivityRadius = s.height;
            _loadMoreActivity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [_loadMoreActivity setFrame:CGRectMake(_loadMoreLabel.frame.origin.x + s.width/2 - nLoadMoreActivityRadius, _loadMoreLabel.frame.origin.y, nLoadMoreActivityRadius, nLoadMoreActivityRadius)];
            [_loadMoreView addSubview:_loadMoreActivity];
            [_loadMoreActivity setHidesWhenStopped:YES];
            
            self.loadMoreTag = kLoadMoreTag_loaded;
        }
    }
    return self;
}

- (void)setPullRefreshTag:(PullRefreshTag)pullRefreshTag
{
    _pullRefreshTag = pullRefreshTag;
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self changePullRefresh];
    });
}

- (void)setLoadMoreTag:(LoadMoreTag)loadMoreTag
{
    _loadMoreTag = loadMoreTag;
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self changeLoadMore];
    });
}

- (void)changePullRefresh
{
    if ([_pullRefreshActivity isAnimating])
        [_pullRefreshActivity stopAnimating];
    
    switch (_pullRefreshTag)
    {
        case kPullRefreshTag_loaded:
            [_arrowImageView setHidden:NO];
            [UIView beginAnimations:nil context:nil];
            _arrowImageView.transform = CGAffineTransformIdentity;
            [UIView commitAnimations];
            [_pullRefreshLabel setText:_kPullRefresh_loaded];
            break;
        case kPullRefreshTag_loading:
            [_arrowImageView setHidden:YES];
            [_pullRefreshActivity startAnimating];
            [_pullRefreshLabel setText:_kPullRefresh_loading];
            break;
        case kPullRefreshTag_willloading:
            [UIView beginAnimations:nil context:nil];
            _arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
            [UIView commitAnimations];
            [_pullRefreshLabel setText:_kPullRefresh_willloading];
            break;
        case kPullRefreshTag_finish:
            _arrowImageView.transform = CGAffineTransformIdentity;
            [_pullRefreshLabel setText:_kPullRefresh_finish];
            break;
        case kPullRefreshTag_error:
            _arrowImageView.transform = CGAffineTransformIdentity;
            [_pullRefreshLabel setText:_kPullRefresh_error];
            break;
    }
}

- (void)changeLoadMore
{
    if ([_loadMoreActivity isAnimating])
        [_loadMoreActivity stopAnimating];
    
    switch (_loadMoreTag)
    {
        case kLoadMoreTag_noneData:
            [_loadMoreLabel setText:_kLoadMore_noneData];
            break;
        case kLoadMoreTag_loaded:
            [_loadMoreLabel setText:_kLoadMore_loaded];
            break;
        case kLoadMoreTag_loading:
            [_loadMoreActivity startAnimating];
            [_loadMoreLabel setText:_kLoadMore_loading];
            break;
        case kLoadMoreTag_loadNoneData:
            [_loadMoreLabel setText:_kLoadMore_loadNoneData];
            break;
        case kLoadMoreTag_reload:
            [_loadMoreLabel setText:_kLoadMore_reload];
            break;
        case kLoadMoreTag_error:
            [_loadMoreLabel setText:_kLoadMore_error];
            break;
    }
}

#pragma mark - action

- (void)qhRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    float f = scrollView.contentOffset.y;
    if (f < 0)
    {
        if (f < -_pullRefreshView.height && _pullRefreshTag != kPullRefreshTag_loading)
        {
            if (_pullRefreshTag == kPullRefreshTag_loaded)
            {
                self.pullRefreshTag = kPullRefreshTag_willloading;
            }
            
            if (_pressentType == QHRefreshHeaderViewPresentTypePinToTop)
            {
                _pullRefreshView.frame = CGRectMake(0, f, _pullRefreshView.frame.size.width, _pullRefreshView.frame.size.height);
            }
        }else
        {
            float r = (-f) * nRotation;
            _arrowImageView.transform = CGAffineTransformMakeRotation(r);

            if (_pullRefreshTag != kPullRefreshTag_loaded && _pullRefreshTag != kPullRefreshTag_loading)
            {
                self.pullRefreshTag = kPullRefreshTag_loaded;
            }
        }
    } else if (f > scrollView.contentSize.height - scrollView.frame.size.height)// (scrollPosition < 0)
    {
        //立刻加载更多
        {
            if (_loadMoreTag == kLoadMoreTag_loaded || _loadMoreTag == kLoadMoreTag_reload)
            {
                self.loadMoreTag = kLoadMoreTag_loading;
                
                if ([_pullAndLoadDelegate respondsToSelector:@selector(qhLoadMoreData:)])
                {
                    [_pullAndLoadDelegate qhLoadMoreData:self];
                }
            }
        }
    }
}

- (void)qhRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    if (_pullRefreshTag == kPullRefreshTag_willloading)//拉拽放手时，只有kRefreshTag_willloading此状态才可以进行刷新
    {
        self.pullRefreshTag = kPullRefreshTag_loading;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        scrollView.contentInset = UIEdgeInsetsMake(_pullRefreshView.height, 0.f, 0.f, 0.0f);
        [UIView commitAnimations];
        
        
        if (_pressentType == QHRefreshHeaderViewPresentTypePinToTop)
        {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
//        {
            _pullRefreshView.frame = CGRectMake(0, -_pullRefreshView.frame.size.height, _pullRefreshView.frame.size.width, _pullRefreshView.frame.size.height);
//        });
        }
        
        if ([_pullAndLoadDelegate respondsToSelector:@selector(qhPullRefreshData:)])
        {
            [_pullAndLoadDelegate qhPullRefreshData:self];
        }
    }
}

- (void)qhPullRefreshScrollViewEndLoading:(UIScrollView *)scrollView tag:(PullRefreshTag)tag
{
    self.pullRefreshTag = tag;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    [UIView commitAnimations];
}

- (void)qhLoadMoreDidEndLoading:(LoadMoreTag)tag
{
    self.loadMoreTag = tag;
}

@end
