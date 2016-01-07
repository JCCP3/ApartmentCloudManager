//
//  MJRefreshDIYHeader.m
//  YouShaQi
//
//  Created by CaiSanze on 15/12/21.
//  Copyright © 2015年 HangZhou RuGuo Network Technology Co.Ltd. All rights reserved.
//

#import "MJRefreshDIYHeader.h"
#import "SvGifView.h"

@interface MJRefreshDIYHeader () {
    UIImageView *arrowDownView;
    SvGifView *gifLoadingView;
}

@end

@implementation MJRefreshDIYHeader

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    
    arrowDownView = [[UIImageView alloc] initWithImage:ImageNamed(@"refresh_arrow.png")];
    arrowDownView.center = CGPointMake(MainScreenWidth / 2, self.mj_h / 2);
    arrowDownView.hidden = YES;
    [self addSubview:arrowDownView];
    
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"refresh_loading@2x" withExtension:@"gif"];
    gifLoadingView = [[SvGifView alloc] initWithCenter:CGPointMake(MainScreenWidth / 2, self.mj_h / 2) fileURL:fileUrl];
    gifLoadingView.backgroundColor = [UIColor clearColor];
    gifLoadingView.hidden = YES;
    [self addSubview:gifLoadingView];
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
            arrowDownView.hidden = NO;
            [arrowDownView setTransform:CGAffineTransformMakeRotation(0)];
            gifLoadingView.hidden = YES;
            break;
        case MJRefreshStatePulling:
        {
            [UIView animateWithDuration:0.18f animations:^{
                [arrowDownView setTransform:CGAffineTransformMakeRotation(M_PI)];
            }];
        }
            break;
        case MJRefreshStateRefreshing:
            arrowDownView.hidden = YES;
            gifLoadingView.hidden = NO;
            [gifLoadingView startGif];
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
}

@end

