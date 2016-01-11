//
//  AddCleanViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/11.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "AddCleanViewController.h"
#import "NormalInputTextFieldCell.h"

@interface AddCleanViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *aryTitleData;
    NSArray *aryPlaceHolderData;
    
    UITableView *addCleanTableView;
}

@end

@implementation AddCleanViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [CustomColorUtils colorWithHexString:@"#f7f7f7"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    aryTitleData = @[@"公寓名称", @"保洁楼层", @"保洁房间", @"保洁日期"];
    aryPlaceHolderData = @[@"请选择您的公寓名称", @"请选择您的保洁楼层", @"请选择您要保洁的房间名称", @"请选择您保洁日期"];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"添加保洁事件" segmentArray:nil];
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    
    [self createTableView];

}

- (void)createTableView
{
    addCleanTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    addCleanTableView.delegate = self;
    addCleanTableView.dataSource = self;
    addCleanTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    addCleanTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:addCleanTableView];
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
    
    if (indexPath.row == 2) {
        cell.isTextFiledEnable = YES;
    } else {
        cell.isTextFiledEnable = NO;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
