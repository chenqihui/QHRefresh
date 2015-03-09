//
//  QHRefreshTag.h
//  QHRefresh
//
//  Created by chen on 14-9-2.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#ifndef QHRefresh_QHRefreshTag_h
#define QHRefresh_QHRefreshTag_h

#endif

typedef NS_ENUM (NSUInteger, LoadMoreTag)
{
    kLoadMoreTag_noneData = 1,
    kLoadMoreTag_loaded,
    kLoadMoreTag_loading,
    kLoadMoreTag_loadNoneData,
    kLoadMoreTag_reload,
    kLoadMoreTag_error
};

typedef NS_ENUM (NSUInteger, PullRefreshTag)
{
    kPullRefreshTag_loaded,
    kPullRefreshTag_loading,
    kPullRefreshTag_willloading,
    kPullRefreshTag_finish,
    kPullRefreshTag_error
};

/**
 *  下拉刷新的呈现方式
 */
typedef NS_ENUM(NSUInteger, QHRefreshHeaderViewPresentType)
{
    /**
     *  默认方式，下拉刷新跟随移动
     */
    QHRefreshHeaderViewPresentTypeDefault,
    /**
     *  下拉刷新在下拉范围内跟随移动，超出范围定在顶部
     */
    QHRefreshHeaderViewPresentTypePinToTop,
    /**
     *  下拉刷新隐藏在tableview后，类似网易刷新，注意tableview.backgroundView不能为空
     */
    QHRefreshHeaderViewPresentTypeBehindTableView
};
