//
//  RefreshControlTableViewController.m
//  refreshData
//
//  Created by chen on 14-9-2.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "RefreshControlTableViewController.h"

@interface RefreshControlTableViewController ()

@property (nonatomic) NSInteger count;

@end

@implementation RefreshControlTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)RefreshViewControlEventValueChanged
{
    if (self.refreshControl.refreshing) {
        NSLog(@"refreshing");
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新中"];
        
        [self performSelector:@selector(handleData) withObject:nil afterDelay:2];
    }
}

// 添加UIRefreshControl下拉刷新控件到UITableViewController的view中
-(void)addRefreshViewControl
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    //    self.refreshControl.tintColor = [UIColor blueColor];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(RefreshViewControlEventValueChanged) forControlEvents:UIControlEventValueChanged];
}

- (void)handleData
{
    NSLog(@"refreshed");
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    
    self.count++;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addRefreshViewControl];
    
    self.count = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text =  [NSString stringWithFormat:@"chen测试_%d", indexPath.row];
    
    return cell;
}

@end
