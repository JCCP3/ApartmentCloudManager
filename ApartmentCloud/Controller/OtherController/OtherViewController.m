//
//  OtherViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/10.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "OtherViewController.h"
#import "LeftSideViewController.h"
#import "HouseHolderListViewController.h"
#import "OperateStatementViewController.h"
#import "FeedBackViewController.h"
#import "TenantViewController.h"

@interface OtherViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *otherTableView;
    NSArray *aryData;
    
    LeftSideViewController *leftSideViewController;
}

@end

@implementation OtherViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [CustomColorUtils colorWithHexString:@"#f7f7f7"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    aryData = @[@"账户", @"二维码", @"住户列表", @"房租列表", @"用户反馈"];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"其他" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(@"nav_menu.png") highlightedImage:ImageNamed(@"nav_menu.png")];
    
    [self createTableView];
}

- (void)createTableView
{
    otherTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,  64, MainScreenWidth, MainScreenHeight - 64)];
    otherTableView.delegate = self;
    otherTableView.dataSource = self;
    otherTableView.backgroundColor = [CustomColorUtils colorWithHexString:@"#f7f7f7"];
    otherTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:otherTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString *title;
    if (indexPath.section == 0) {
        title = [aryData objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        title = [aryData objectAtIndex:indexPath.row + 2];
    } else {
        title = [aryData objectAtIndex:indexPath.row + 4];
    }
    
    cell.textLabel.text = title;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.detailTextLabel.text = [UserDefaults objectForKey:UserAccount];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            //生成二维码
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0 ||indexPath.row == 1) {
            HouseHolderListViewController *view = [[HouseHolderListViewController alloc] init];
            if (indexPath.row == 0) {
                view.isHouseHolderList = YES;
            }
            [self.navigationController pushViewController:view animated:YES];
        }
    } else {
        FeedBackViewController *view = [[FeedBackViewController alloc] init];
        [self.navigationController pushViewController:view animated:YES];
    }
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
