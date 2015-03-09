//
//  AppDelegate.m
//  refreshData
//
//  Created by chen on 14-5-29.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "RefreshTableViewController.h"
#import "RefreshViewController.h"
#import "RefreshControlTableViewController.h"
#import "QHRefreshDemoViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //实验下拉刷新
    UIViewController *mainVC = nil;
    
    {
        ViewController *viewVC = [[ViewController alloc] init];
        mainVC = viewVC;
    }
    
    {
        UITabBarController *tabBarC = [[UITabBarController alloc] init];
        //UITableViewController添加自己的刷新加载（这里的self.view就是self.tableview）
        //改变不了UITableViewController.view(tableView)的高度
        RefreshTableViewController *refreshTableVC = [[RefreshTableViewController alloc] init];
        UITabBarItem *item2 = [[UITabBarItem alloc]initWithTitle:@"刷新加载1" image:nil tag:1];
        refreshTableVC.tabBarItem = item2;
        //普通的添加自己的刷新加载（为集合到控件的方式）
        RefreshViewController *refreshVC = [[RefreshViewController alloc] init];
        UITabBarItem *item3 = [[UITabBarItem alloc]initWithTitle:@"刷新加载2" image:nil tag:1];
        refreshVC.tabBarItem = item3;
        //添加iOS6之后自带的UIRefreshControl
        RefreshControlTableViewController *refreshControlTVC = [[RefreshControlTableViewController alloc] init];
        UITabBarItem *item4 = [[UITabBarItem alloc]initWithTitle:@"UIRefreshControl" image:nil tag:1];
        refreshControlTVC.tabBarItem = item4;
        //
        QHRefreshDemoViewController *qhRefreshDemoVC = [[QHRefreshDemoViewController alloc] init];
        UITabBarItem *item5 = [[UITabBarItem alloc]initWithTitle:@"QHRefresh" image:nil tag:1];
        qhRefreshDemoVC.tabBarItem = item5;
        
        tabBarC.viewControllers = @[refreshTableVC, refreshVC, refreshControlTVC, qhRefreshDemoVC];
        mainVC = tabBarC;
    }
    
    self.window.rootViewController = mainVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
