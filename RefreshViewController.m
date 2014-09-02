//
//  RefreshViewController.m
//  refreshData
//
//  Created by chen on 14-9-1.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "RefreshViewController.h"

@interface RefreshViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    QHPullRefreshView *_pullRefreshView;
    QHLoadMoreView *_loadMoreView;
    NSMutableArray *_arMuData;
    int _indexs;
}

@end

@implementation RefreshViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *arData = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"2", @"3", @"4", @"5", @"6", @"7"];
    _arMuData = [NSMutableArray new];
    [_arMuData addObjectsFromArray:arData];
    _indexs = [_arMuData count] - 1;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.height -= self.tabBarController.tabBar.height;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_tableView];
    
    _pullRefreshView = [[QHPullRefreshView alloc] initWithFrame:CGRectMake(0, -0, self.view.width, PULL_HEIGHT)];
    [self.view insertSubview:_pullRefreshView belowSubview:_tableView];
//    [_tableView addSubview:_pullRefreshView];
    
    _loadMoreView = [[QHLoadMoreView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    [_loadMoreView setBackgroundColor:[UIColor whiteColor]];
    _tableView.tableFooterView = _loadMoreView;
    _loadMoreView.loadtag = kLoadMoreTag_loaded;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arMuData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    // Configure the cell...
    cell.textLabel.text = [_arMuData objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    CGFloat scrollPosition = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y;
    [_pullRefreshView qhPullRefreshScrollViewDidScroll:scrollView];
    float f = scrollView.contentOffset.y;
    if (f < 0)
    {
        if (f < -_pullRefreshView.height && _pullRefreshView.loadtag != kPullRefreshTag_loading)
        {
            if (_pullRefreshView.loadtag == kPullRefreshTag_loaded)
            {
                _pullRefreshView.loadtag = kPullRefreshTag_willloading;
            }
        }else
        {
            if (_pullRefreshView.loadtag != kPullRefreshTag_loaded && _pullRefreshView.loadtag != kPullRefreshTag_loading)
            {
                _pullRefreshView.loadtag = kPullRefreshTag_loaded;
            }
        }
    } else if (f > scrollView.contentSize.height - scrollView.frame.size.height)// (scrollPosition < 0)
    {
        //立刻加载更多
        {
            if (_loadMoreView.loadtag == kLoadMoreTag_loaded || _loadMoreView.loadtag == kLoadMoreTag_reload)
            {
                _loadMoreView.loadtag = kLoadMoreTag_loading;
                
                [self performSelector:@selector(reload) withObject:nil afterDelay:1];
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_pullRefreshView.loadtag == kPullRefreshTag_willloading)//拉拽放手时，只有kRefreshTag_willloading此状态才可以进行刷新
    {
        _pullRefreshView.loadtag = kPullRefreshTag_loading;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        scrollView.contentInset = UIEdgeInsetsMake(_pullRefreshView.height, 0.f, 0.f, 0.0f);
        [UIView commitAnimations];
        
        [self performSelector:@selector(refreshData:) withObject:scrollView afterDelay:1];
    }
}

#pragma mark - delegateEnd

- (void)refreshData:(UIScrollView *)scrollView
{
    __async_main__, ^
    {
        _pullRefreshView.loadtag = kPullRefreshTag_finish;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        [UIView commitAnimations];
        
        [_arMuData insertObject:[NSString stringWithFormat:@"%d", ++_indexs] atIndex:0];
        [_arMuData insertObject:[NSString stringWithFormat:@"%d", ++_indexs] atIndex:0];
        [_tableView reloadData];
    });
}

- (void)reload
{
    __async_main__, ^
    {
        _loadMoreView.loadtag = kLoadMoreTag_loaded;
        
        [_arMuData addObjectsFromArray:@[[NSString stringWithFormat:@"%d", ++_indexs], [NSString stringWithFormat:@"%d", ++_indexs]]];
        [_tableView reloadData];
    });
}

@end
