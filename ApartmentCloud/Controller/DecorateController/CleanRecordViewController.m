//
//  CleanRecordViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/11.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "CleanRecordViewController.h"

@interface CleanRecordViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *cleanRecordTableView;
    NSMutableArray *aryData;
}

@end

@implementation CleanRecordViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [CustomColorUtils colorWithHexString:@"#f7f7f7"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"保洁记录" segmentArray:nil];
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    
    [self createTableView];
    
}

- (void)createTableView
{
    cleanRecordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    cleanRecordTableView.delegate = self;
    cleanRecordTableView.dataSource = self;
    cleanRecordTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    cleanRecordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:cleanRecordTableView];
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
    cell.detailTextLabel.textColor = [CustomColorUtils colorWithHexString:@"#39c2bc"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13.f];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
