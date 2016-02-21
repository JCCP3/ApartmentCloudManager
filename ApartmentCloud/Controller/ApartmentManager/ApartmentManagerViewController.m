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
#import "AddApartmentViewController.h"
#import "AddApartmentRoomViewController.h"
#import "LocalUserUtils.h"

#define SECOND_NAV_ARR @[@"我的公寓", @"交租查询", @"到期查询", @"房间统计"]

@interface ApartmentManagerViewController () <AddApartmentViewControllerDelegate, ApartmentCollectionViewDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *aryData;
    
    UIView *secondNavView;
    NSInteger currentSelectedBtnTag;
    UIScrollView *showMyApartmentScrollView;
    
    LeftSideViewController *leftSideViewController;
    
    ApartmentCollectionView *myApartmentCollectionView;
    ApartmentCollectionView *payApartmentCollectionView;
    ApartmentCollectionView *expiredApartmentCollectionView;
    ApartmentCollectionView *roomCountCollectionView;
    
    BOOL myApartmentRequestFinish;
    BOOL payApartmentRequestFinish;
    BOOL expiredApartmentRequestFinish;
    
    UIView *tmpTitleView;
    UIButton *titleBtn;
    
    UIImageView *arrowDownImage;
    
    UIView *showPullDownView;
    BOOL pullDownViewShowed;
    UITableView *pullDownTableView;
    
    UIView *shadowView;
    
    NSArray *aryApartmentData;
    NSString *currentSelectedType;
}

@end

@implementation ApartmentManagerViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [CustomColorUtils colorWithHexString:@"#f7f7f7"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"所有公寓" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(@"nav_menu.png") highlightedImage:ImageNamed(@"nav_menu.png")];
    [self adaptSecondRightItemWithTitle:@"添加公寓"];
    
    [self createSecondNavView]; //创建二级菜单
    
    if ([UserDefaults objectForKey:UserAccount]) {
        
        NSString *requestUrl = [NSString stringWithFormat:@"/user/logon.json?account=%@&logonPassword=%@",[UserDefaults objectForKey:UserAccount], [UserDefaults objectForKey:UserPwd]];
        [CustomRequestUtils createNewRequest:requestUrl success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *jsonDic = responseObject;
            if ([[jsonDic objectForKey:@"status"] isEqualToString:RequestSuccessful]) {
                [LocalUserUtils setLocalUserInfo:jsonDic];
                [self setUpCollectionViews];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    
    
}

- (UIView *)createTitleViewWithStr:(NSString *)titleStr
{
    if (!tmpTitleView) {
        tmpTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 200, 44)];
        tmpTitleView.backgroundColor = [UIColor clearColor];
    }
    
    if (!titleBtn) {
        titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tmpTitleView.frame), 44)];
        [tmpTitleView addSubview:titleBtn];
        
        titleBtn.center = CGPointMake(CGRectGetWidth(tmpTitleView.frame) / 2, 20);
        titleBtn.backgroundColor = [UIColor clearColor];
        [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [titleBtn addTarget:self action:@selector(onClickChooseApartment:) forControlEvents:UIControlEventTouchUpInside];
        [titleBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    }
    
    [titleBtn setTitle:titleStr forState:UIControlStateNormal];
    
    if (!arrowDownImage) {
        arrowDownImage = [[UIImageView alloc] init];
        arrowDownImage.image = ImageNamed(@"c_arrow_down.png");
        [titleBtn addSubview:arrowDownImage];
    }
    
    CGSize titleSize = [CustomSizeUtils simpleSizeWithStr:titleStr font:titleBtn.titleLabel.font];
    CGFloat imageStartX = (CGRectGetWidth(tmpTitleView.frame) / 2) + (titleSize.width / 2);
    [arrowDownImage setFrame:CGRectMake(imageStartX + 5, 19, 12, 6)];
    
    return tmpTitleView;
}

- (void)onClickChooseApartment:(UIButton *)btn
{
    if (showMyApartmentScrollView.contentOffset.x < MainScreenWidth) {
        btn.selected = !btn.selected;
        if (btn.selected) {
            [self showPullDownView];
        } else {
            [self hidePullDownView];
        }
    }
}

- (void)createPullDownView
{
    showPullDownView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    showPullDownView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:showPullDownView];
    [self.view bringSubviewToFront:showPullDownView];
    showPullDownView.hidden = YES;
    
    pullDownTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, - (44 * 3), MainScreenWidth, 44 * 3)];
    [showPullDownView addSubview:pullDownTableView];
    pullDownTableView.backgroundColor = [UIColor whiteColor];
    pullDownTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    pullDownTableView.delegate = self;
    pullDownTableView.dataSource = self;
    [showPullDownView addSubview:pullDownTableView];
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 44)];
    tmpView.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 44)];
    [btn setTitle:@"所有公寓" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tmpView addSubview:btn];
    
    [btn addTarget:self action:@selector(onClickShowAll) forControlEvents:UIControlEventTouchUpInside];
    pullDownTableView.tableHeaderView = tmpView;
    
    shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, CGRectGetHeight(showPullDownView.bounds))];
    [showPullDownView addSubview:shadowView];
    shadowView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickHidePullDownView)];
    [shadowView addGestureRecognizer:tap];
}

- (void)onClickShowAll
{
    [self hidePullDownView];
    [myApartmentCollectionView showDataWithApartment:nil];
}

- (void)onClickHidePullDownView
{
    titleBtn.selected = !titleBtn.selected;
    [self hidePullDownView];
}

- (void)showPullDownView
{
    [pullDownTableView reloadData];
    showPullDownView.clipsToBounds = YES;
    showPullDownView.hidden = NO;
    shadowView.alpha = 0.3;
    [self.view bringSubviewToFront:showPullDownView];
    [showPullDownView bringSubviewToFront:pullDownTableView];
    
    [UIView animateWithDuration:.3 animations:^{
        [pullDownTableView setFrame:CGRectMake(0, 0, CGRectGetWidth(pullDownTableView.bounds), CGRectGetHeight(pullDownTableView.bounds))];
    }];
}

- (void)hidePullDownView
{
    [UIView animateWithDuration:.2 animations:^{
        shadowView.alpha = 0;
        [pullDownTableView setFrame:CGRectMake(0, - CGRectGetHeight(pullDownTableView.bounds), MainScreenWidth, CGRectGetHeight(pullDownTableView.bounds))];
    } completion:^(BOOL finished) {
        showPullDownView.hidden = YES;
    }];
}

#pragma mark - UITableView dataSource&delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return aryApartmentData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, MainScreenWidth - 55, 21)];
        titleLabel.tag = 1000;
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 40, 16, 15, 12)];
        markImageView.image = [UIImage imageNamed:@"c_check"];
        markImageView.tag = 2000;
        [cell.contentView addSubview:markImageView];
        
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    UILabel *currentTitleLabel = (UILabel *)[cell.contentView viewWithTag:1000];
    UIImageView *currentMarkImageView = (UIImageView *)[cell.contentView viewWithTag:2000];
    
    Apartment *apartment = [aryApartmentData objectAtIndex:indexPath.row];
    currentTitleLabel.text = apartment.apartmentName;
    [currentTitleLabel setFrame:CGRectMake(25, 15, MainScreenWidth - 65, CGRectGetHeight(currentTitleLabel.bounds))];
    
    if ([currentTitleLabel.text isEqualToString:currentSelectedType]) {
        currentTitleLabel.textColor = RGBACOLOR(185, 50, 33, 1);
        [currentMarkImageView setHidden:NO];
    } else {
        currentTitleLabel.textColor = [UIColor blackColor];
        [currentMarkImageView setHidden:YES];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    titleBtn.selected = !titleBtn.selected;
    [self hidePullDownView];
    
    Apartment *apartment = [aryApartmentData objectAtIndex:indexPath.row];
    if ([currentSelectedType isEqualToString:apartment.apartmentName]) {
        return;
    }
    
    currentSelectedType = apartment.apartmentName;
    [titleBtn setTitle:currentSelectedType forState:UIControlStateNormal];
    
    //筛选
    [myApartmentCollectionView showDataWithApartment:apartment];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setUpCollectionViews
{
    showMyApartmentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + 45, MainScreenWidth, MainScreenHeight - 64 - 45)];
    showMyApartmentScrollView.delegate = self;
    showMyApartmentScrollView.showsHorizontalScrollIndicator = NO;
    showMyApartmentScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:showMyApartmentScrollView];
    
    if (!myApartmentCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        myApartmentCollectionView = [[ApartmentCollectionView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 64 - 45) collectionViewLayout:flowLayout];
        myApartmentCollectionView.tag = 100;
        myApartmentCollectionView.apartmentCollectionViewDelegate = self;
        [myApartmentCollectionView loadApartmentCollectionViewData];
        [showMyApartmentScrollView addSubview:myApartmentCollectionView];
    }
    
    if (!payApartmentCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        payApartmentCollectionView = [[ApartmentCollectionView alloc] initWithFrame:CGRectMake(MainScreenWidth, 0, MainScreenWidth, MainScreenHeight - 64 - 45) collectionViewLayout:flowLayout];
        payApartmentCollectionView.apartmentCollectionViewDelegate = self;
        payApartmentCollectionView.tag = 101;
//        [payApartmentCollectionView loadDueApartmentCollectionViewData]; //即将到期
        [showMyApartmentScrollView addSubview:payApartmentCollectionView];
    }
    
    if (!expiredApartmentCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        expiredApartmentCollectionView = [[ApartmentCollectionView alloc] initWithFrame:CGRectMake(MainScreenWidth * 2, 0, MainScreenWidth, MainScreenHeight - 64 - 45) collectionViewLayout:flowLayout];
        expiredApartmentCollectionView.apartmentCollectionViewDelegate = self;
        expiredApartmentCollectionView.tag = 102;
//        [expiredApartmentCollectionView loadExpireApartmentCollectionViewData];
        [showMyApartmentScrollView addSubview:expiredApartmentCollectionView];
    }
    
    if (!roomCountCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        roomCountCollectionView = [[ApartmentCollectionView alloc] initWithFrame:CGRectMake(MainScreenWidth * 3, 0, MainScreenWidth, MainScreenHeight - 64 - 45) collectionViewLayout:flowLayout];
        roomCountCollectionView.apartmentCollectionViewDelegate = self;
        roomCountCollectionView.tag = 103;
        //        [expiredApartmentCollectionView loadExpireApartmentCollectionViewData];
        [showMyApartmentScrollView addSubview:roomCountCollectionView];
    }
    
    showMyApartmentScrollView.pagingEnabled = YES;
    [showMyApartmentScrollView setContentSize:CGSizeMake(MainScreenWidth * 4, MainScreenHeight - 64 - 45)];
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

#pragma mark - RequestAction
- (void)requestMyApartmentInfo
{
    if (myApartmentCollectionView) {
        [myApartmentCollectionView loadApartmentCollectionViewData];
    }
}

- (void)requestPayApartmentInfo
{
    if (payApartmentCollectionView) {
        [payApartmentCollectionView loadDueApartmentCollectionViewData];
    }
}

- (void)requestExpiredApartmentInfo
{
    if (expiredApartmentCollectionView) {
        [expiredApartmentCollectionView loadExpireApartmentCollectionViewData];
    }
}

- (void)requestRoomCountInfo
{
    if (roomCountCollectionView) {
        [roomCountCollectionView loadApartmentRoomCountCollectionViewData];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (showPullDownView.hidden) {
        if (scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > MainScreenWidth * 4) {
            scrollView.scrollEnabled = NO;
            return;
        } else {
            int currentPage = scrollView.contentOffset.x / MainScreenWidth;
            
            currentSelectedBtnTag = [self getConvertedTag:currentPage];
            
            if (currentPage == 0) {
                [self requestMyApartmentInfo];
            } else if (currentPage == 1) {
                [self requestPayApartmentInfo];
            } else if (currentPage == 2) {
                [self requestExpiredApartmentInfo];
            } else {
                //房间统计
                [self requestRoomCountInfo];
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
        }
    }
}

#pragma mark - BaseAction
- (void)onClickLeftItem
{
    leftSideViewController = [[LeftSideViewController alloc] init];
    [[APPDELEGATE ppRevealSideViewController] pushViewController:leftSideViewController onDirection:PPRevealSideDirectionLeft animated:YES];
}

- (void)onClickSecondRightItem
{
    AddApartmentViewController *view = [[AddApartmentViewController alloc] init];
    view.delegate = self;
    view.canEdit = YES;
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark - AddApartmentViewControllerDelegate
- (void)AAVCD_passApartment:(Apartment *)apartment
{
    [myApartmentCollectionView loadApartmentCollectionViewData];
}

#pragma mark - ApartmentCollectionViewDelegate
- (void)ACVD_addRoom:(Apartment *)apartment
{
    AddApartmentRoomViewController *view = [[AddApartmentRoomViewController alloc] init];
    view.apartmentId = apartment.apartmentId;
    [self.navigationController pushViewController:view animated:YES];
}

- (void)ACVD_goToRoom:(ApartmentRoom *)room
{
    AddApartmentRoomViewController *view = [[AddApartmentRoomViewController alloc] init];
    view.apartmentRoom = room;
    [self.navigationController pushViewController:view animated:YES];
}

- (void)ACVD_showApartmentDetailInfo:(Apartment *)apartment
{
    AddApartmentViewController *view = [[AddApartmentViewController alloc] init];
    view.delegate = self;
    view.addApartment = apartment;
    [self.navigationController pushViewController:view animated:YES];
}

- (void)ACVD_showTitleViewArray:(NSMutableArray *)aryApartment
{
    aryApartmentData = aryApartment;
    
    UIView *titleView = [self createTitleViewWithStr:[GlobalUtils translateStr:@"所有公寓"]];
    [self adaptCenterItemWithView:titleView];
    
    currentSelectedType = @"所有公寓";
    
    [self createPullDownView];
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
