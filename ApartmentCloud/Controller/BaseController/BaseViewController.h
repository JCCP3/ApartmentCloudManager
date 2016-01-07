//
//  BaseViewController.h
//  NavigationBarDemo
//
//  Created by JCCP3 on 15/7/20.
//  Copyright (c) 2015年 JCCP3. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CustomProgressText = 1,
    CustomProgressLoading
} CustomProgressTag;

typedef enum {
    CustomNavigationBarColorRed = 1,
    CustomNavigationBarColorWhite,
    CustomNavigationBarColorLightWhite,
    CustomNavigationBarColorBlack
} CustomNavigationBarColorTag;

@interface BaseViewController : UIViewController

@property (nonatomic ,strong) UIView *shadowView;

- (void)adaptNavBarWithBgTag:(CustomNavigationBarColorTag)bgTag navTitle:(NSString *)title segmentArray:(NSArray *)array;
- (void)adaptCenterItemWithView:(UIView *)view;
- (void)updateNavBarWithTitle:(NSString *)title;
- (NSInteger)getCurrentSelectedSegmentIndex;
- (void)updateSegmentControlWithIndex:(NSInteger)index;

- (void)adaptLeftItemWithNormalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage;
- (void)adaptLeftItemWithTitle:(NSString *)title backArrow:(BOOL)backArrow;

- (void)adaptFirstRightItemWithNormalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage;
- (void)adaptFirstRightItemWithTitle:(NSString *)title;
- (void)setFirstRightItemEnabled:(BOOL)enabled;

- (void)adaptSecondRightItemWithNormalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage;
- (void)adaptSecondRightItemWithTitle:(NSString *)title;

- (void)refreshNavBarFrame;
- (void)disableBackGesture;

- (void)onClickLeftItem;
- (void)onClickFirstRightItem;
- (void)onClickSecondRightItem;
- (void)onClickSegment:(UISegmentedControl *)segmentControl;

- (void)showProgress;
- (void)showProgressWithMsg:(NSString *)msg cancelBtn:(BOOL)cancelBtn;
- (void)hideProgress;
- (void)hideProgressWithMsg:(NSString *)msg;
- (void)progressHideWithCancelBtn;
- (void)bringProgressToFront;
- (void)updateProgressText:(NSString *)progressText;

- (void)refreshAllSubviews;

@end
