//
//  DecorateFollowViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/11.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "DecorateFollowViewController.h"

@interface DecorateFollowViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *aryData;
    UITableView *decorateFollowTableView;
}

@end

@implementation DecorateFollowViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [CustomColorUtils colorWithHexString:@"#f7f7f7"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *title = self.isDecorateFollow ? @"装修跟进" : @"维修跟进";
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:title segmentArray:nil];
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    
    [self createTableView];
}

- (void)createTableView
{
    decorateFollowTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    decorateFollowTableView.delegate = self;
    decorateFollowTableView.dataSource = self;
    decorateFollowTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    decorateFollowTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:decorateFollowTableView];
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
    return [aryData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.textColor = [CustomColorUtils colorWithHexString:@"#333333"];
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.detailTextLabel.textColor = [CustomColorUtils colorWithHexString:@"#bbbbbb"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
    cell.detailTextLabel.text = @"查看进度";
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - BaseAction
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
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
