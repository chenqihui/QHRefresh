//
//  RefreshTableViewController.m
//  refreshData
//
//  Created by chen on 14-9-1.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "RefreshTableViewController.h"

@interface RefreshTableViewController ()
{
    NSArray *_arData;
    QHLoadMoreView *_loadMoreView;
    QHPullRefreshView *_pullRefreshView;
    NSMutableArray *_arMuData;
    
    int _indexs;
}

@end

@implementation RefreshTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%f", self.tableView.height);
    _indexs = 7;
    _arData = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"4", @"5", @"6", @"7", @"6", @"7"];
    _arMuData = [NSMutableArray new];
    [_arMuData addObjectsFromArray:_arData];
    
    _loadMoreView = [[QHLoadMoreView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    [_loadMoreView setBackgroundColor:[UIColor whiteColor]];
    self.tableView.tableFooterView = _loadMoreView;
    _loadMoreView.loadtag = kLoadMoreTag_loaded;
    
    _pullRefreshView = [[QHPullRefreshView alloc] initWithFrame:CGRectMake(0, -PULL_HEIGHT, self.view.width, PULL_HEIGHT)];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView addSubview:_pullRefreshView];
    
    //这里的self.view应该就是self.tableview
//    NSLog(@"%d", self.view == self.tableView);
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
    }
    
    // Configure the cell...
    cell.textLabel.text = [_arMuData objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGFloat scrollPosition = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y;
    float f = scrollView.contentOffset.y;
    if (f < 0)
    {
        if (f < -_pullRefreshView.height && _pullRefreshView.loadtag != kRefreshTag_loading)
        {
            if (_pullRefreshView.loadtag == kRefreshTag_loaded)
            {
                _pullRefreshView.loadtag = kRefreshTag_willloading;
            }
        }else
        {
            if (_pullRefreshView.loadtag != kRefreshTag_loaded && _pullRefreshView.loadtag != kRefreshTag_loading)
            {
                _pullRefreshView.loadtag = kRefreshTag_loaded;
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
    if (_pullRefreshView.loadtag == kRefreshTag_willloading)//拉拽放手时，只有kRefreshTag_willloading此状态才可以进行刷新
    {
        _pullRefreshView.loadtag = kRefreshTag_loading;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        scrollView.contentInset = UIEdgeInsetsMake(_pullRefreshView.height, 0.f, 0.f, 0.0f);
        [UIView commitAnimations];
        
        [self performSelector:@selector(refreshData:) withObject:scrollView afterDelay:2];
    }
}

#pragma mark - delegateEnd

- (void)reload
{
    __async_main__, ^
    {
        _loadMoreView.loadtag = kLoadMoreTag_loaded;
        
        [_arMuData addObjectsFromArray:@[[NSString stringWithFormat:@"%d", ++_indexs], [NSString stringWithFormat:@"%d", ++_indexs]]];
        [self.tableView reloadData];
    });
}

- (void)refreshData:(UIScrollView *)scrollView
{
    __async_main__, ^
    {
        _pullRefreshView.loadtag = kRefreshTag_finish;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        [UIView commitAnimations];
        
        [_arMuData insertObject:[NSString stringWithFormat:@"%d", ++_indexs] atIndex:0];
        [_arMuData insertObject:[NSString stringWithFormat:@"%d", ++_indexs] atIndex:0];
        [self.tableView reloadData];
    });
}

@end
