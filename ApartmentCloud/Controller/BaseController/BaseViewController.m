//
//  BaseViewController.m
//  NavigationBarDemo
//
//  Created by JC_CP3 on 15/7/20.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"

static const CGFloat segmentItemWidth = 100;
static const CGFloat segmentItemHeight = 29;

@interface BaseViewController () <MBProgressHUDDelegate> {
    UIView *navBarView;
    UIButton *navLeftBarBtn;
    UILabel *navTitleLabel;
    UIButton *navFirstRightBarBtn;
    UIButton *navSecondRightBarBtn;
    UISegmentedControl *segmentedControl;
    
    NSArray *currentSegmentArray;
    CustomNavigationBarColorTag customBgTag;
    NSString *currentTitle;
    
    UIColor *navBarBackgroundColor;
    UIColor *navBarTextColor;
    UIColor *navBarSeparatorColor;
    UIColor *navItemNormalColor;
    UIColor *navItemHighlightedColor;
    
    MBProgressHUD *progress;
}

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self enableBackGesture];
    self.navigationController.navigationBarHidden = YES;
    
    navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64.f)];
    [self.view addSubview:navBarView];
    
    navLeftBarBtn = [[UIButton alloc] init];
    [navLeftBarBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navLeftBarBtn addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:navLeftBarBtn];
    
    navTitleLabel = [[UILabel alloc] init];
    navTitleLabel.font = [UIFont boldSystemFontOfSize:17];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    [navBarView addSubview:navTitleLabel];
    
    navFirstRightBarBtn = [[UIButton alloc] init];
    [navFirstRightBarBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navFirstRightBarBtn addTarget:self action:@selector(onClickFirstRightItem) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:navFirstRightBarBtn];

    navSecondRightBarBtn = [[UIButton alloc] init];
    [navSecondRightBarBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navSecondRightBarBtn addTarget:self action:@selector(onClickSecondRightItem) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:navSecondRightBarBtn];
    
    segmentedControl = [[UISegmentedControl alloc] init];
    segmentedControl.hidden = YES;
    [segmentedControl addTarget:self action:@selector(onClickSegment:) forControlEvents:UIControlEventValueChanged];
    [navBarView addSubview:segmentedControl];
    
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    self.shadowView.layer.zPosition = 99999;
    self.shadowView.hidden = YES;
    self.shadowView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.shadowView];
    [self.view bringSubviewToFront:self.shadowView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews
{
    [self refreshNavBarFrame];
}

- (void)refreshNavBarFrame
{
    [navBarView setFrame:CGRectMake(0, 0, MainScreenWidth, CGRectGetHeight(navBarView.frame))];
    [navTitleLabel setCenter:CGPointMake(navBarView.center.x, navTitleLabel.center.y)];
    [navFirstRightBarBtn setFrame:CGRectMake(MainScreenWidth - CGRectGetWidth(navFirstRightBarBtn.frame), 20, CGRectGetWidth(navFirstRightBarBtn.frame), 44)];
    [navSecondRightBarBtn setFrame:CGRectMake(MainScreenWidth - CGRectGetWidth(navFirstRightBarBtn.frame) - CGRectGetWidth(navSecondRightBarBtn.frame), 20, CGRectGetWidth(navSecondRightBarBtn.frame), 44)];
    [self.shadowView setFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置navBarView方法
- (void)adaptNavBarWithBgTag:(CustomNavigationBarColorTag)bgTag navTitle:(NSString *)title segmentArray:(NSArray *)array
{
    switch (bgTag) {
        case CustomNavigationBarColorRed:
            navBarBackgroundColor = [CustomColorUtils colorWithHexString:@"#fb5d6b"];
            navBarTextColor = [UIColor whiteColor];
            navBarSeparatorColor = RGBCOLOR(133, 11, 11);
            
            navItemNormalColor = RGBCOLOR(255, 255, 255);
            navItemHighlightedColor = RGBACOLOR(255, 255, 255, 0.4f);
            break;
            
        case CustomNavigationBarColorWhite:
            navBarBackgroundColor = RGBCOLOR(247, 247, 247);
            navBarTextColor = RGBCOLOR(51, 51, 51);
            navBarSeparatorColor = RGBCOLOR(170, 170, 170);
            
            navItemNormalColor = RGBCOLOR(214, 44, 44);
            navItemHighlightedColor = RGBCOLOR(242, 206, 206);
            break;
            
        case CustomNavigationBarColorLightWhite:
            navBarBackgroundColor = RGBCOLOR(250, 250, 250);
            navBarTextColor = RGBCOLOR(33, 33, 33);
            navBarSeparatorColor = RGBCOLOR(128, 128, 128);
            
            navItemNormalColor = RGBCOLOR(214, 44, 44);
            navItemHighlightedColor = RGBCOLOR(242, 206, 206);
            break;
            
        case CustomNavigationBarColorBlack:
            navBarBackgroundColor = RGBCOLOR(30, 30, 30);
            navBarTextColor = [UIColor whiteColor];
            
            navItemNormalColor = RGBCOLOR(255, 255, 255);
            navItemHighlightedColor = RGBCOLOR(255, 255, 255);
            break;
    }
    
    [navBarView setBackgroundColor:navBarBackgroundColor];

    currentSegmentArray = array;
    customBgTag = bgTag;
    currentTitle = title;
    
    [self updateNavBarWithTitle:title];
    
    [self updateSegmentControl];
    
    [self updateSeparateLine];
}

- (void)updateNavBarWithTitle:(NSString *)title
{
    [navTitleLabel setFrame:CGRectMake(50, 20.f, MainScreenWidth - 100, 40)];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.text = [CustomStringUtils isBlankString:title] ? @"" : title;
    navTitleLabel.textColor = navBarTextColor;
}

- (void)updateSegmentControl
{
    // sengment
    if ([currentSegmentArray count] > 0) {
        [segmentedControl setTintColor:navItemNormalColor];
        CGFloat segmentCount = [currentSegmentArray count];
        [navBarView setFrame:CGRectMake(0, 0, MainScreenWidth, 64 + 44)];
        if (segmentedControl.numberOfSegments != segmentCount) {
            for (int i = 0; i < segmentCount; i++) {
                NSString *title = [currentSegmentArray objectAtIndex:i];
                [segmentedControl insertSegmentWithTitle:title atIndex:i animated:NO];
            }
        }
        
        [segmentedControl setFrame:CGRectMake(0, 0, (segmentCount * segmentItemWidth), segmentItemHeight)];
        [navBarView alignCenterSubview:segmentedControl withBottomPadding:10];
        
        segmentedControl.hidden = NO;
    } else {
        segmentedControl.hidden = YES;
    }
}

- (void)updateSeparateLine
{
    if (navBarSeparatorColor) {
        CGFloat customNavHeight = [currentSegmentArray count] > 0 ? 64 + 44 : 64;
        UIView *navBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, customNavHeight - 0.5f, CGRectGetWidth(self.view.bounds), 0.5f)];
        navBottomLine.backgroundColor = navBarSeparatorColor;
        [self.view addSubview:navBottomLine];
        [self.view resetSubViewWidthEqualToSuperView:navBottomLine];
    }
}

- (void)adaptCenterItemWithView:(UIView *)view
{
    navTitleLabel.hidden = YES;
    [navBarView addSubview:view];
    CGFloat bottomPadding = (44 - CGRectGetHeight(view.frame)) / 2;
    bottomPadding = MAX(0, bottomPadding);
    [navBarView alignCenterSubview:view withBottomPadding:bottomPadding];
}

- (NSInteger)getCurrentSelectedSegmentIndex
{
    return segmentedControl.selectedSegmentIndex;
}

- (void)updateSegmentControlWithIndex:(NSInteger)index
{
    segmentedControl.selectedSegmentIndex = index;
}

#pragma mark LeftItem
- (void)adaptLeftItemWithTitle:(NSString *)title backArrow:(BOOL)backArrow
{
    if ([CustomStringUtils isBlankString:title]) {
        navLeftBarBtn.hidden = YES;
        return;
    }
    
    [navLeftBarBtn setTitleColor:navItemNormalColor forState:UIControlStateNormal];
    [navLeftBarBtn setTitleColor:navItemHighlightedColor forState:UIControlStateHighlighted];
    
    if (backArrow) {
        UIImage *normalImage = [self createNormalImageWithTitle:title];
        [navLeftBarBtn setImage:normalImage forState:UIControlStateNormal];
        
        UIImage *highlightedImage = [self createHighlightedImageWithTitle:title];
        [navLeftBarBtn setImage:highlightedImage forState:UIControlStateHighlighted];
        [navLeftBarBtn setFrame:CGRectMake(0, 20.f, normalImage.size.width, 44.f)];
    } else {
        [navLeftBarBtn setTitle:title forState:UIControlStateNormal];
        CGSize titleSize = [CustomSizeUtils simpleSizeWithStr:title font:navLeftBarBtn.titleLabel.font];
        CGFloat itemWidth = titleSize.width + 30;
        [navLeftBarBtn setFrame:CGRectMake(0, 20.f, itemWidth, 44.f)];
    }
}

- (UIImage *)createNormalImageWithTitle:(NSString *)title
{
    UIFont *textFont = [UIFont systemFontOfSize:15];
    CGSize textSize = [CustomSizeUtils simpleSizeWithStr:title font:textFont];
    CGFloat textWidth = textSize.width >= 55 ? 90 : 75;
    
    CGSize imgSize = CGSizeMake(textWidth, 44);
    CGRect textRect = CGRectMake(25, 13.5f, 65, 16);
    
    UIGraphicsBeginImageContextWithOptions(imgSize, NO, [[UIScreen mainScreen] scale]);
    
    UIImage *originImage;
    switch (customBgTag) {
        case CustomNavigationBarColorRed:
            originImage = ImageNamed(@"nav_back_white.png");
            break;
            
        case CustomNavigationBarColorWhite:
            originImage = ImageNamed(@"nav_back_red.png");
            break;
            
        case CustomNavigationBarColorLightWhite:
            originImage = ImageNamed(@"nav_back_red.png");
            break;
            
        case CustomNavigationBarColorBlack:
            break;
    }
    
    [originImage drawAtPoint:CGPointMake(0, 0)];
    
    UILabel *backLabel = [[UILabel alloc] initWithFrame:textRect];
    backLabel.backgroundColor = [UIColor clearColor];
    backLabel.font = textFont;
    backLabel.textColor = navItemNormalColor;
    backLabel.text = title;
    
    [backLabel drawTextInRect:backLabel.frame];
    
    // Read the UIImage object
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)createHighlightedImageWithTitle:(NSString *)title
{
    UIFont *textFont = [UIFont systemFontOfSize:15];
    CGSize textSize = [CustomSizeUtils simpleSizeWithStr:title font:textFont];
    CGFloat textWidth = textSize.width >= 55 ? 90 : 75;
    
    CGSize imgSize = CGSizeMake(textWidth, 44);
    CGRect textRect = CGRectMake(25, 13.5f, 65, 16);
    
    UIGraphicsBeginImageContextWithOptions(imgSize, NO, 2.0);
    
    UIImage *originImage;
    switch (customBgTag) {
        case CustomNavigationBarColorRed:
            originImage = ImageNamed(@"nav_back_white_selected.png");
            break;
            
        case CustomNavigationBarColorWhite:
            originImage = ImageNamed(@"nav_back_red_selected.png");
            break;
            
        case CustomNavigationBarColorLightWhite:
            originImage = ImageNamed(@"nav_back_red_selected.png");
            break;
            
        case CustomNavigationBarColorBlack:
            break;
    }
    [originImage drawAtPoint:CGPointMake(0, 0)];
    
    UILabel *backLabel = [[UILabel alloc] initWithFrame:textRect];
    backLabel.backgroundColor = [UIColor clearColor];
    backLabel.font = textFont;
    backLabel.textColor = navItemHighlightedColor;
    backLabel.text = title;
    
    [backLabel drawTextInRect:backLabel.frame];
    
    // Read the UIImage object
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)adaptLeftItemWithNormalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage
{
    if (!normalImage) {
        navLeftBarBtn.hidden = YES;
        return;
    }
    
    [navLeftBarBtn setImage:normalImage forState:UIControlStateNormal];
    [navLeftBarBtn setImage:highlightedImage forState:UIControlStateHighlighted];
    [navLeftBarBtn setFrame:CGRectMake(0, 20.f, normalImage.size.width, 44.f)];
}

#pragma mark FirstRightItem
- (void)adaptFirstRightItemWithTitle:(NSString *)title
{
    if ([CustomStringUtils isBlankString:title]) {
        [UIView animateWithDuration:0.3f animations:^{
            navFirstRightBarBtn.layer.opacity = 0;
        } completion:^(BOOL finished) {
            navFirstRightBarBtn.hidden = YES;
            navFirstRightBarBtn.layer.opacity = 1;
        }];
        return;
    }
    
    navFirstRightBarBtn.hidden = NO;
    [navFirstRightBarBtn setTitle:title forState:UIControlStateNormal];
    [navFirstRightBarBtn setTitleColor:navItemNormalColor forState:UIControlStateNormal];
    [navFirstRightBarBtn setTitleColor:navItemHighlightedColor forState:UIControlStateHighlighted];
    
    CGSize titleSize = [CustomSizeUtils simpleSizeWithStr:title font:navFirstRightBarBtn.titleLabel.font];
    CGFloat itemWidth = titleSize.width + 30;
    [navFirstRightBarBtn setFrame:CGRectMake(MainScreenWidth - itemWidth, 20.f, itemWidth, 44.f)];
}

- (void)adaptFirstRightItemWithNormalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage
{
    if (!normalImage) {
        navFirstRightBarBtn.hidden = YES;
        return;
    }
    
    navFirstRightBarBtn.hidden = NO;
    [navFirstRightBarBtn setImage:normalImage forState:UIControlStateNormal];
    [navFirstRightBarBtn setImage:highlightedImage forState:UIControlStateHighlighted];
    
    [navFirstRightBarBtn setFrame:CGRectMake(MainScreenWidth - normalImage.size.width, 20.f, normalImage.size.width, 44.f)];
}

- (void)setFirstRightItemEnabled:(BOOL)enabled
{
    navFirstRightBarBtn.enabled = enabled;
}

#pragma mark SecondRightItem
- (void)adaptSecondRightItemWithTitle:(NSString *)title
{
    if ([CustomStringUtils isBlankString:title]) {
        navSecondRightBarBtn.hidden = YES;
        return;
    }
    
    navSecondRightBarBtn.hidden = NO;
    [navSecondRightBarBtn setTitle:title forState:UIControlStateNormal];
    [navSecondRightBarBtn setTitleColor:navItemNormalColor forState:UIControlStateNormal];
    [navSecondRightBarBtn setTitleColor:navItemHighlightedColor forState:UIControlStateHighlighted];
    
    CGSize titleSize = [CustomSizeUtils simpleSizeWithStr:title font:navSecondRightBarBtn.titleLabel.font];
    CGFloat itemWidth = titleSize.width + 30;
    
    [navSecondRightBarBtn setFrame:CGRectMake(MainScreenWidth - CGRectGetWidth(navFirstRightBarBtn.frame) - itemWidth, 20.f, itemWidth, 44.f)];
}

- (void)adaptSecondRightItemWithNormalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage
{
    if (!normalImage) {
        navSecondRightBarBtn.hidden = YES;
        return;
    }
    
    navSecondRightBarBtn.hidden = NO;
    [navSecondRightBarBtn setImage:normalImage forState:UIControlStateNormal];
    [navSecondRightBarBtn setImage:highlightedImage forState:UIControlStateHighlighted];
    
    [navSecondRightBarBtn setFrame:CGRectMake(MainScreenWidth - CGRectGetWidth(navFirstRightBarBtn.frame) - normalImage.size.width, 20.f, normalImage.size.width, 44.f)];
}

#pragma mark - 共用方法
- (void)enableBackGesture
{
    if ([self.navigationController isKindOfClass:[BaseNavController class]] || [self.navigationController isMemberOfClass:[BaseNavController class]]) {
        [(BaseNavController *)self.navigationController setEnableBackGesture:YES];
    }
}

- (void)disableBackGesture
{
    if ([self.navigationController isKindOfClass:[BaseNavController class]] || [self.navigationController isMemberOfClass:[BaseNavController class]]) {
        [(BaseNavController *)self.navigationController setEnableBackGesture:NO];
    }
}

#pragma mark - 按钮触发事件
- (void)onClickLeftItem
{
    
}

- (void)onClickFirstRightItem
{
    
}

- (void)onClickSecondRightItem
{
    
}

- (void)onClickSegment:(UISegmentedControl *)segmentControl
{
    
}

#pragma mark - MBProgressHud Function
- (void)showProgress
{
    [self showProgressWithMsg:nil cancelBtn:YES];
}

- (void)showProgressWithMsg:(NSString *)msg cancelBtn:(BOOL)cancelBtn
{
    if (progress) {
        [GlobalUtils hideAndSetNil:&progress];
    }
    
    progress = [[MBProgressHUD alloc] init];
    progress.delegate = self;
    progress.labelText = msg ?: @"加载中";
    [[[UIApplication sharedApplication] keyWindow] addSubview:progress];
    if (cancelBtn) {
        [progress showWithCancelBtn];
    } else {
        [progress show:YES];
    }
}

- (void)hideProgress
{
    [GlobalUtils hideAndSetNil:&progress];
}

- (void)hideProgressWithMsg:(NSString *)msg
{
    if (progress) {
        if (msg) {
            progress.labelText = msg;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [GlobalUtils hideAndSetNil:&progress];
            });
        } else {
            [GlobalUtils hideAndSetNil:&progress];
        }
    }
}

- (void)bringProgressToFront
{
    if (progress && [progress superview]) {
        [[progress superview] bringSubviewToFront:progress];
    }
}

- (void)updateProgressText:(NSString *)progressText
{
    if (progress) {
        progress.labelText = progressText;
    }
}

#pragma mark - MBProgressHud Delegate
- (void)hudWasHiddenByCancelBtn
{
    [self progressHideWithCancelBtn];
}

- (void)progressHideWithCancelBtn
{
    
}

#pragma mark - Change Theme
- (void)refreshAllSubviews
{
    [self adaptNavBarWithBgTag:customBgTag navTitle:currentTitle segmentArray:currentSegmentArray];
}

@end
