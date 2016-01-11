//
//  HouseHolderListViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/11.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "HouseHolderListViewController.h"

@interface HouseHolderListViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UISearchBar *m_searchBar;
    
    UITableView *houseHolderListTableView;
    NSMutableArray *aryData;
}

@end

@implementation HouseHolderListViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [CustomColorUtils colorWithHexString:@"#f7f7f7"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    aryData = [[NSMutableArray alloc] init];
    
    NSString *title = self.isHouseHolderList ? @"住户列表" : @"押金列表";
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:title segmentArray:nil];
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    
    m_searchBar = [self createSearchBar];
    [self.view addSubview:m_searchBar];
    
    [self createTableView];
}

- (void)createTableView
{
    houseHolderListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,  64 + 50, MainScreenWidth, MainScreenHeight - 64 - 50)];
    houseHolderListTableView.delegate = self;
    houseHolderListTableView.dataSource = self;
    houseHolderListTableView.backgroundColor = [CustomColorUtils colorWithHexString:@"#f7f7f7"];
    houseHolderListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:houseHolderListTableView];
}

- (UISearchBar *)createSearchBar
{
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, MainScreenWidth, 50)];
    searchBar.delegate = self;
    searchBar.translucent = YES;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.placeholder = [GlobalUtils translateStr:@"输入租客姓名"];
    searchBar.keyboardType =  UIKeyboardTypeDefault;
    
    return searchBar;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [m_searchBar resignFirstResponder];
    NSString *text = m_searchBar.text;
    if ([text isEqualToString:@""]) {
        return;
    }
    
    if (self.isHouseHolderList) {
        [self loadHourseHolderListByName];
    } else {
        [self loadDepositListByName];
    }
    
}

- (void)loadHourseHolderListByName
{
    
}

- (void)loadDepositListByName
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
