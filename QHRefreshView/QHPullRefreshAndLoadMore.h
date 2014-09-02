//
//  PullRefreshAndLoadMoreView.h
//  refreshData
//
//  Created by chen on 14-9-2.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QHRefreshTag.h"

@class QHPullRefreshAndLoadMore;

@protocol QHPullRefreshAndLoadMoreDelegate <NSObject>

- (void)qhPullRefreshData:(QHPullRefreshAndLoadMore *)refresh;
- (void)qhLoadMoreData:(QHPullRefreshAndLoadMore *)refresh;

@end

@interface QHPullRefreshAndLoadMore : NSObject

@property (nonatomic, retain) NSString *kLoadMore_noneData;
@property (nonatomic, retain) NSString *kLoadMore_loaded;
@property (nonatomic, retain) NSString *kLoadMore_loading;
@property (nonatomic, retain) NSString *kLoadMore_loadNoneData;
@property (nonatomic, retain) NSString *kLoadMore_reload;
@property (nonatomic, retain) NSString *kLoadMore_error;

@property (nonatomic, retain) NSString *kPullRefresh_loaded;
@property (nonatomic, retain) NSString *kPullRefresh_loading;
@property (nonatomic, retain) NSString *kPullRefresh_willloading;
@property (nonatomic, retain) NSString *kPullRefresh_finish;
@property (nonatomic, retain) NSString *kPullRefresh_error;

- (void)qhRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)qhRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
/**
 *  下拉刷新结束时调用
 *
 *  @param scrollView 当前添加的UIScrollView
 *  @param tag        调用后的状态
 */
- (void)qhPullRefreshScrollViewEndLoading:(UIScrollView *)scrollView tag:(PullRefreshTag)tag;
/**
 *  上拉加载更多
 *
 *  @param tag 调用后的状态
 */
- (void)qhLoadMoreDidEndLoading:(LoadMoreTag)tag;

- (id)initRefreshWithScroll:(UIScrollView *)view//需要添加的UIScrollView或者UITableView
            pullRefreshView:(CGFloat)nPullRefreshViewHeight//下拉刷新UIView的高度，默认是随滑动的
                presentType:(QHRefreshHeaderViewPresentType)type
               loadMoreView:(CGFloat)nLoadMoreViewHeight//上拉加载UIView的高度
                   delegate:(id<QHPullRefreshAndLoadMoreDelegate>)delegate//代理回调
                     titile:(NSArray *)arTitile;//选传，这个是各个title的提示标语（规则是：两个数组，一个是5个NSString，对应PullRefreshTag，二个是六个NSString，对应LoadMoreTag，以上都是按顺序放置，如使用默认的话传：@""）

@end
