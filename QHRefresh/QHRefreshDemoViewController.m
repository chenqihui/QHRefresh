//
//  QHRefreshDemoViewController.m
//  QHRefresh
//
//  Created by chen on 14-9-2.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "QHRefreshDemoViewController.h"

#import "QHPullRefreshAndLoadMore.h"

@interface QHRefreshDemoViewController ()<UITableViewDataSource, UITableViewDelegate, QHPullRefreshAndLoadMoreDelegate>
{
    UITableView *_tableView;
    QHPullRefreshAndLoadMore *_qhRefresh;
    NSMutableArray *_arMuData;
    int _indexs;
}

@end

@implementation QHRefreshDemoViewController

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
    
    _qhRefresh = [[QHPullRefreshAndLoadMore alloc] initRefreshWithScroll:_tableView pullRefreshView:60 presentType:QHRefreshHeaderViewPresentTypeBehindTableView loadMoreView:30 delegate:self titile:nil];
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
    [_qhRefresh qhRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_qhRefresh qhRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - QHPullRefreshAndLoadMoreDelegate

- (void)qhPullRefreshData:(QHPullRefreshAndLoadMore *)refresh
{
//    [_arMuData insertObject:[NSString stringWithFormat:@"%d", ++_indexs] atIndex:0];
//    [_arMuData insertObject:[NSString stringWithFormat:@"%d", ++_indexs] atIndex:0];
//    [_tableView reloadData];
//    [refresh qhPullRefreshScrollViewEndLoading:_tableView];
    
    [self performSelector:@selector(refreshData:) withObject:refresh afterDelay:2];
}

- (void)qhLoadMoreData:(QHPullRefreshAndLoadMore *)refresh
{
//    [refresh qhLoadMoreDidEndLoading:kLoadMoreTag_loaded];
    
    [self performSelector:@selector(reload:) withObject:refresh afterDelay:2];
}

#pragma mark - delegateEnd

- (void)refreshData:(QHPullRefreshAndLoadMore *)refresh
{
    __async_main__, ^
    {
        [_arMuData insertObject:[NSString stringWithFormat:@"%d", ++_indexs] atIndex:0];
        [_arMuData insertObject:[NSString stringWithFormat:@"%d", ++_indexs] atIndex:0];
        [_tableView reloadData];
        [refresh qhPullRefreshScrollViewEndLoading:_tableView tag:kPullRefreshTag_finish];
    });
}

- (void)reload:(QHPullRefreshAndLoadMore *)refresh
{
    __async_main__, ^
    {
        [_arMuData addObjectsFromArray:@[[NSString stringWithFormat:@"%d", ++_indexs], [NSString stringWithFormat:@"%d", ++_indexs]]];
        [_tableView reloadData];
        [refresh qhLoadMoreDidEndLoading:kLoadMoreTag_loaded];
    });
}

@end
