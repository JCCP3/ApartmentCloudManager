//
//  LeftSideViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/10.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "LeftSideViewController.h"
#import "ApartmentManagerViewController.h"
#import "DecorateViewController.h"
#import "SaleViewController.h"
#import "OtherViewController.h"
#import "LoginViewController.h"
#import "ApartmentWaterListViewController.h"
#import "ApartmentElecListViewController.h"
#import "ApartmentGasListViewController.h"
#import "AppWebViewController.h"
#import "SettingViewController.h"

@interface LeftSideViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *leftSideTableView;
    NSArray *aryImageData;
    NSArray *aryTitleData;
}

@end

@implementation LeftSideViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = AppThemeColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    aryImageData = @[@"left_accounts.png", @"left_horseManager.png", @"left_decoration.png", @"left_decoration.png", @"left_decoration.png", @"left_decoration.png",  @"left_sell.png", @"left_other.png"];
    aryTitleData = @[@"账户", @"房屋管理", @"支出列表", @"水表列表", @"电表列表", @"燃气列表", @"统计分析", @"其他"];
    
    [self createTableView];
    
    [self createFooterView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)createTableView
{
    leftSideTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, MainScreenWidth, MainScreenHeight - 50 - 124)];
    leftSideTableView.delegate = self;
    leftSideTableView.dataSource = self;
    leftSideTableView.backgroundColor = [UIColor clearColor];
    leftSideTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:leftSideTableView];
}

- (void)createFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 84, MainScreenWidth, 84)];
    footerView.backgroundColor = [CustomColorUtils colorWithHexString:@"#dc505d"];
    [self.view addSubview:footerView];
    
//    UIImageView *apartmentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30, 17, 17)];
//    [apartmentImageView setImage:ImageNamed(@"left_apartment.png")];
//    [footerView addSubview:apartmentImageView];
    
//    UILabel *apartmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(apartmentImageView.frame) + 20, 30, MainScreenWidth - (CGRectGetMaxX(apartmentImageView.frame) + 20), 15.f)];
//    apartmentLabel.textColor = [UIColor whiteColor];
//    apartmentLabel.font = [UIFont systemFontOfSize:15.f];
//    apartmentLabel.text = @"查看分散式公寓";
//    [footerView addSubview:apartmentLabel];
    
//    UIButton *apartmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, MainScreenWidth, 47)];
//    [[apartmentBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        
//    }];
//    [footerView addSubview:apartmentBtn];
    
    
    UIImageView *settingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 33.5, 17, 17)];
    [settingImageView setImage:ImageNamed(@"left_setting.png")];
    [footerView addSubview:settingImageView];
    
    UILabel *settingLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(settingImageView.frame) + 20, CGRectGetMinY(settingImageView.frame), MainScreenWidth - (CGRectGetMaxX(settingImageView.frame) + 20), 15.f)];
    settingLabel.textColor = [UIColor whiteColor];
    settingLabel.font = [UIFont systemFontOfSize:15.f];
    settingLabel.text = @"设置";
    [footerView addSubview:settingLabel];
    
    UIButton *settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 37 + 15, MainScreenWidth, 47)];
    [[settingBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        SettingViewController *viewController = [[SettingViewController alloc] init];
        BaseNavController *nav = [[BaseNavController alloc] initWithRootViewController:viewController];
        [[APPDELEGATE ppRevealSideViewController] popViewControllerWithNewCenterController:nav animated:YES];
    }];
    [footerView addSubview:settingBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [aryTitleData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.backgroundColor = [UIColor clearColor];
        
        UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 17, 17)];
        leftImageView.tag = 10086;
        [cell addSubview:leftImageView];
        
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 15, MainScreenWidth - 57, 15)];
        rightLabel.tag = 10010;
        rightLabel.font = [UIFont systemFontOfSize:15.f];
        rightLabel.textColor = [UIColor whiteColor];
        [cell addSubview:rightLabel];
        
        UILabel *sepaLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 46, 190, 0.5)];
        sepaLabel.backgroundColor = [CustomColorUtils colorWithHexString:@"#ff929c"];
        [cell addSubview:sepaLabel];
    }
    
    UIImageView *currentImageView = (UIImageView *)[cell viewWithTag:10086];
    [currentImageView setImage:ImageNamed([aryImageData objectAtIndex:indexPath.row])];
    
    UILabel *currentLabel = (UILabel *)[cell viewWithTag:10010];
    currentLabel.text = [aryTitleData objectAtIndex:indexPath.row];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        LoginViewController *viewController = [[LoginViewController alloc] init];
        BaseNavController *nav = [[BaseNavController alloc] initWithRootViewController:viewController];
        [[APPDELEGATE ppRevealSideViewController] popViewControllerWithNewCenterController:nav animated:YES];
    } else if (indexPath.row == 1) {
        ApartmentManagerViewController *viewController = [[ApartmentManagerViewController alloc] init];
        BaseNavController *nav = [[BaseNavController alloc] initWithRootViewController:viewController];
        [[APPDELEGATE ppRevealSideViewController] popViewControllerWithNewCenterController:nav animated:YES];
    } else if (indexPath.row == 2) {
        //支出列表
        DecorateViewController *viewController = [[DecorateViewController alloc] init];
        BaseNavController *nav = [[BaseNavController alloc] initWithRootViewController:viewController];
        [[APPDELEGATE ppRevealSideViewController] popViewControllerWithNewCenterController:nav animated:YES];
    } else if (indexPath.row == 3){
        ApartmentWaterListViewController *viewController = [[ApartmentWaterListViewController alloc] init];
        viewController.fromLeftSide = YES;
        BaseNavController *nav = [[BaseNavController alloc] initWithRootViewController:viewController];
        [[APPDELEGATE ppRevealSideViewController] popViewControllerWithNewCenterController:nav animated:YES];
    } else if (indexPath.row == 4) {
        ApartmentElecListViewController *viewController = [[ApartmentElecListViewController alloc] init];
        viewController.fromLeftSide = YES;
        BaseNavController *nav = [[BaseNavController alloc] initWithRootViewController:viewController];
        [[APPDELEGATE ppRevealSideViewController] popViewControllerWithNewCenterController:nav animated:YES];
    } else if (indexPath.row == 5) {
        ApartmentGasListViewController *viewController = [[ApartmentGasListViewController alloc] init];
        viewController.fromLeftSide = YES;
        BaseNavController *nav = [[BaseNavController alloc] initWithRootViewController:viewController];
        [[APPDELEGATE ppRevealSideViewController] popViewControllerWithNewCenterController:nav animated:YES];
    } else if (indexPath.row == 6){
        AppWebViewController *viewController = [[AppWebViewController alloc] init];
        BaseNavController *nav = [[BaseNavController alloc] initWithRootViewController:viewController];
        [[APPDELEGATE ppRevealSideViewController] popViewControllerWithNewCenterController:nav animated:YES];
    } else {
        OtherViewController *viewController = [[OtherViewController alloc] init];
        BaseNavController *nav = [[BaseNavController alloc] initWithRootViewController:viewController];
        [[APPDELEGATE ppRevealSideViewController] popViewControllerWithNewCenterController:nav animated:YES];
    }
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
