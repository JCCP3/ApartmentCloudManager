//
//  AddApartmentFloorViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/13.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "AddApartmentFloorViewController.h"
#import "NormalInputTextFieldCell.h"

@interface AddApartmentFloorViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *floorInfoTableView;
    NSArray *aryTitleData;
    NSArray *aryPlaceHolderData;
}

@end

@implementation AddApartmentFloorViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [CustomColorUtils colorWithHexString:@"#f7f7f7"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    aryTitleData = @[@"公寓名称", @"新加楼层", @"房间数" , @"推广链接"];
    aryPlaceHolderData = @[@"请输入公寓名称", @"请输入公寓楼层", @"请输入该楼层总房间数", @"请输入您的推广链接"];
    
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    [self adaptSecondRightItemWithTitle:@"确认添加"];
   
    [self createTableView];
}

- (void)createTableView
{
    floorInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    floorInfoTableView.delegate = self;
    floorInfoTableView.dataSource = self;
    floorInfoTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    floorInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:floorInfoTableView];
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
    NormalInputTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NormalInputTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row != 0) {
        cell.isTextFiledEnable = NO;
    } else {
        cell.isTextFiledEnable = YES;
    }
    
    cell.title = [aryTitleData objectAtIndex:indexPath.row];
    cell.placeHolderTitle = [aryPlaceHolderData objectAtIndex:indexPath.row];
    
    [cell loadNormalInputTextFieldCellData];
    
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

- (void)onClickSecondRightItem
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
