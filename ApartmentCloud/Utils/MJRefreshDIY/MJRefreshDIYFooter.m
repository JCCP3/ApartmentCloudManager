//
//  MJRefreshDIYFooter.m
//  YouShaQi
//
//  Created by CaiSanze on 15/12/22.
//  Copyright © 2015年 HangZhou RuGuo Network Technology Co.Ltd. All rights reserved.
//

#import "MJRefreshDIYFooter.h"

@interface MJRefreshDIYFooter() {
    UILabel *label;
    UIActivityIndicatorView *loading;
}
@end

@implementation MJRefreshDIYFooter
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 40;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 15)];
    [label setTextColor:RGBCOLOR(119, 119, 119)];
    [label setCenter:CGPointMake(MainScreenWidth / 2, 20)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont systemFontOfSize:12.0f]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:label];
    
    loading = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 70, 10.0f, 20.0f, 20.0f)];
    [loading setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    loading.hidden = YES;
    [self addSubview:loading];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            label.text = [GlobalUtils translateStr:@"上拉加载更多"];
            loading.hidden = YES;
            break;
        case MJRefreshStatePulling:
            label.text = [GlobalUtils translateStr:@"上拉加载更多"];
            loading.hidden = YES;
            break;
        case MJRefreshStateRefreshing:
            label.text = [GlobalUtils translateStr:@"正在加载更多..."];
            loading.hidden = NO;
            [loading startAnimating];
            break;
        case MJRefreshStateNoMoreData:
            label.text = @"";
            loading.hidden = YES;
            break;
        default:
            break;
    }
}

@end
