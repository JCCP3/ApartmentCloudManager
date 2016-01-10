//
//  SaleViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/10.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "SaleViewController.h"
#import "LeftSideViewController.h"

@interface SaleViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *saleTableView;
    NSArray *aryData;
    
    LeftSideViewController *leftSideViewController;
}

@end

@implementation SaleViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    aryData = @[@"添加营销媒体资源", @"历史营销媒体资源", @"添加营销费用支出", @"历史营销费用支出"];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"营销销售" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(@"nav_menu.png") highlightedImage:ImageNamed(@"nav_menu.png")];
    
    [self createTableView];
    
}

- (void)createTableView
{
    saleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,  64, MainScreenWidth, MainScreenHeight - 64)];
    saleTableView.delegate = self;
    saleTableView.dataSource = self;
    saleTableView.backgroundColor = [CustomColorUtils colorWithHexString:@"#f7f7f7"];
    saleTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:saleTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
    }
    
    cell.textLabel.text = title;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
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
