QHRefresh
=========

自定义的刷新控件（以下是本人的愚见，如有不对，望海涵，有建议可以提出，我也会改进）

下拉刷新及上拉加载

首先谈谈刷新及加载在现在iOS的使用方式，大致有下面几种（这里的实例是基于UITableView上的scrollView使用的）

A、代表框架：EGOTableViewPullRefresh
   代码地址：https://github.com/enormego/EGOTableViewPullRefresh
   为UITableView添加下拉刷新和上拉加载的UIView，UiView里面包含动画   逻辑等。它通过在UITableView里面的UIScrollViewDelegate回调给UIView，然后对应的把执行结果（即开始，结束），也是通过代理回调给UITableView来执行数据刷新等操作。
一般是下面的
//滑动时触发，更改状态，变化
- (void)scrollViewDidScroll:(UIScrollView *)scrollView; 
//主要用于下拉刷新松手后触发事件
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
如同框架设计的方法

@property(nonatomic,assign) id <EGORefreshTableHeaderDelegate> delegate;

- (void)refreshLastUpdatedDate;
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end

@protocol EGORefreshTableHeaderDelegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view;
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view;
@optional
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view;
@end

B、代表框架：PullingRefreshTableView
   代码地址：https://github.com/Zhangmangyuan/PullingRefreshTableView
   代码说明：http://www.cnblogs.com/PleaseInputEnglish/p/3485989.html
   使用继承的方式，这里通过使用PullingRefreshTableView做为UITableVIew 的父类，在父类的UIScrollViewDelegate回调里面直接处理（内容其实是跟上面一样的）下拉上拉的逻辑动画等，补充下，此框架居然是使用两种方式，即继承使用UIScrollViewDelegate，也支持使用UITableVIew的UIScrollViewDelegate来调用父类的方法（等同与EGOTableViewPullRefresh）


C、为UIScrollView或者UITableVIew添加类别
   代表框架：MJRefresh
   代码地址：https://github.com/CoderMJLee/MJRefresh
   代码说明：http://blog.csdn.net/hitwhylz/article/details/19046725
   这种就是通过UIScrollView+MJRefresh类别来获取UIScrollView事件的，而且此框架将刷新与加载的UIView集成到类别里面，所以只需在对应的UITableVIew调用相应的add方法就可以快速添加UIView了，相对简便。

 1. 添加头部控件的方法
 [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
 或者
 [self.tableView addHeaderWithCallback:^{ }];
 2. 添加尾部控件的方法
 [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
 或者
 [self.tableView addFooterWithCallback:^{ }];
 3. 可以在MJRefreshConst.h和MJRefreshConst.m文件中自定义显示的文字内容和文字颜色
 4. 本框架兼容iOS6\iOS7，iPhone\iPad横竖屏
 5.自动进入刷新状态
 1> [self.tableView headerBeginRefreshing];
 2> [self.tableView footerBeginRefreshing];
 6.结束刷新
 1> [self.tableView headerEndRefreshing];
 2> [self.tableView footerEndRefreshing];

D、我的实现

    我的做法比较倾向与A，因为这样更方便的分离和单独给UIScrollView使用，然后结合B和C一些写法来实现，此代码要继续优化的哈

