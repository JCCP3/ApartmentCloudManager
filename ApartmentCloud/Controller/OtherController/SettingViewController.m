//
//  SettingViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/2/20.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "SettingViewController.h"
#import "LeftSideViewController.h"
#import "BaseSettingViewController.h"

@interface SettingViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *settingTableView;
}

@end

@implementation SettingViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"设置" segmentArray:nil];
    
    [self adaptLeftItemWithNormalImage:ImageNamed(@"nav_menu.png") highlightedImage:ImageNamed(@"nav_menu.png")];
    
    [self createTableView];
}

- (void)createTableView
{
    settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,  64 , MainScreenWidth, MainScreenHeight - 64)];
    settingTableView.delegate = self;
    settingTableView.dataSource = self;
    settingTableView.backgroundColor = [CustomColorUtils colorWithHexString:@"#f7f7f7"];
    settingTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:settingTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = @"水电气基础设定";
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseSettingViewController *view = [[BaseSettingViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
}


- (void)onClickLeftItem
{
    LeftSideViewController *leftSideViewController = [[LeftSideViewController alloc] init];
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
