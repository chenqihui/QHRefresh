//
//  ViewController.m
//  refreshData
//
//  Created by chen on 14-5-29.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIView *_headerView;
    UIView *_contentView;
    
    BOOL _bWillRefresh;
    BOOL _bLoading;
}

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [_scrollView setBackgroundColor:[UIColor yellowColor]];
    [self.view addSubview:_scrollView];
//    _scrollView.height += _scrollView.height*0.5;
    
//    [_scrollView setShowsVerticalScrollIndicator:YES];
//    [_scrollView setUserInteractionEnabled:YES];
//    _scrollView.scrollEnabled = YES;
    
    [_scrollView setContentSize:CGSizeMake(self.view.width, self.view.height*1.5)];
    _scrollView.delegate = self;
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -60, self.view.width, 60)];
    [_headerView setBackgroundColor:[UIColor redColor]];
    [_scrollView addSubview:_headerView];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    [l setText:@"下拉加载"];
    l.tag = 1;
    [_headerView addSubview:l];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.contentSize.width, _scrollView.contentSize.height)];
    [_contentView setBackgroundColor:[UIColor blueColor]];
    [_scrollView addSubview:_contentView];
    
    _bWillRefresh = NO;
}

#pragma mark - scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_bLoading)
        return;
    
//    CGFloat scrollPosition = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y;
    float f = scrollView.contentOffset.y;
    if (f < 0)
    {
        if (f < -_headerView.height)
        {
            if (_bWillRefresh == NO)
            {
                [((UILabel *)[_headerView viewWithTag:1]) setText:@"松手刷新"];
                _bWillRefresh = YES;
            }
        }else
        {
            [((UILabel *)[_headerView viewWithTag:1]) setText:@"下拉加载"];
            _bWillRefresh = NO;
        }
//    }else if (f == -_headerView.height)
//    {
//        if (_bWillRefresh)
//        {
//            [_scrollView setContentOffset:CGPointMake(0, -60)];
//            _bWillRefresh = NO;
//            [self performSelector:@selector(refreshData:) withObject:@"1" afterDelay:3];
//        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"3");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_bWillRefresh)
    {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
        _bWillRefresh = NO;
        [((UILabel *)[_headerView viewWithTag:1]) setText:@"正在加载"];
        _bLoading = YES;
        [self performSelector:@selector(refreshData:) withObject:@"1" afterDelay:3];
    }
}

- (void)refreshData:(NSString *)szT
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    _scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    [UIView commitAnimations];
    _bLoading = NO;
}

@end
