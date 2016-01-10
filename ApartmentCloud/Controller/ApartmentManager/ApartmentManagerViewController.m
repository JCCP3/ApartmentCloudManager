//
//  ApartmentManagerViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/8.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "ApartmentManagerViewController.h"
#import "ApartmentCollectionView.h"
#import "LeftSideViewController.h"

#define SECOND_NAV_ARR @[@"我的公寓", @"交租查询", @"到期查询", @"入住房间"]

@interface ApartmentManagerViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableArray *aryData;
    
    UIView *secondNavView;
    NSInteger currentSelectedBtnTag;
    UIScrollView *showMyApartmentScrollView;
    
    LeftSideViewController *leftSideViewController;
    
    ApartmentCollectionView *myApartmentCollectionView;
    ApartmentCollectionView *payApartmentCollectionView;
    ApartmentCollectionView *expiredApartmentCollectionView;
}

@end

@implementation ApartmentManagerViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"所有公寓" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(@"nav_menu.png") highlightedImage:ImageNamed(@"nav_menu.png")];
    
    [self createSecondNavView];
    
//    [self setUpCollectionViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setUpCollectionViews
{
    if (!myApartmentCollectionView) {
        myApartmentCollectionView = [[ApartmentCollectionView alloc] initWithFrame:CGRectMake(0, 64 + 40, MainScreenWidth, MainScreenHeight - 64 - 40)];
        myApartmentCollectionView.delegate = self;
        myApartmentCollectionView.dataSource = self;
        [self.view addSubview:myApartmentCollectionView];
    }
    
    if (!payApartmentCollectionView) {
        payApartmentCollectionView = [[ApartmentCollectionView alloc] initWithFrame:CGRectMake(0, 64 + 40, MainScreenWidth, MainScreenHeight - 64 - 40)];
        payApartmentCollectionView.delegate = self;
        payApartmentCollectionView.dataSource = self;
        [self.view addSubview:payApartmentCollectionView];
    }
    
    if (!expiredApartmentCollectionView) {
        expiredApartmentCollectionView = [[ApartmentCollectionView alloc] initWithFrame:CGRectMake(0, 64 + 40, MainScreenWidth, MainScreenHeight - 64 - 40)];
        expiredApartmentCollectionView.delegate = self;
        expiredApartmentCollectionView.dataSource = self;
        [self.view addSubview:expiredApartmentCollectionView];
    }
    
}

- (void)createSecondNavView
{
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 45)];
    tmpView.backgroundColor = [UIColor whiteColor];
    CGFloat btnWidth = MainScreenWidth / [SECOND_NAV_ARR count];
    
    [SECOND_NAV_ARR enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *navBtn = [GlobalUtils createSecondaryNavBtn:CGRectMake(0 + btnWidth * idx, 0, btnWidth, 45) withTitle:[GlobalUtils translateStr:obj]];
        UILabel *navLabel = (UILabel *)[navBtn viewWithTag:99];
        if (idx == 0) {
            [navBtn setSelected:YES];
            navLabel.textColor = AppThemeColor;
        } else {
            navLabel.textColor = [CustomColorUtils colorWithHexString:@"#888888"];
        }
        navBtn.tag = [self getConvertedTag:idx];
        [navBtn addTarget:self action:@selector(secondNavClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tmpView addSubview:navBtn];
    }];
    
    secondNavView = tmpView;
    secondNavView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:secondNavView];
}

- (void)secondNavClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (currentSelectedBtnTag == btn.tag) {
        return;
    } else {
        currentSelectedBtnTag = btn.tag;
    }
    
    [SECOND_NAV_ARR enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *navBtn = (UIButton *)[secondNavView viewWithTag:[self getConvertedTag:idx]];
        UILabel *navLabel = (UILabel *)[navBtn viewWithTag:99];
        if (navBtn.tag == currentSelectedBtnTag) {
            navLabel.textColor = AppThemeColor;
            navBtn.selected = YES;
        } else {
            navLabel.textColor = [CustomColorUtils colorWithHexString:@"#888888"];
            navBtn.selected = NO;
        }
    }];
    
    [showMyApartmentScrollView scrollRectToVisible:CGRectMake((currentSelectedBtnTag - 100) * MainScreenWidth, CGRectGetMinY(showMyApartmentScrollView.frame), MainScreenWidth, CGRectGetHeight(showMyApartmentScrollView.bounds)) animated:NO];
}

- (NSUInteger)getConvertedTag:(NSUInteger)originTag
{
    return originTag + 100;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

#pragma mark - BaseAction
- (void)onClickLeftItem
{
    leftSideViewController = [[LeftSideViewController alloc] init];
    [[APPDELEGATE ppRevealSideViewController] pushViewController:leftSideViewController onDirection:PPRevealSideDirectionLeft animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
