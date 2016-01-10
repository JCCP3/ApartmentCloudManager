//
//  AddDecorateViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/10.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "AddDecorateViewController.h"
#import "NormalInputTextFieldCell.h"

@interface AddDecorateViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *addDecorateTableView;
    NSArray *aryTitleData;
    NSArray *aryPlaceHolderData;
}

@end

@implementation AddDecorateViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [CustomColorUtils colorWithHexString:@"#f7f7f7"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    aryTitleData = @[@"公寓名称", @"装修楼层", @"装修房间", @"装修日期"];
    aryPlaceHolderData = @[@"请选择您的公寓名称", @"请选择您的装修楼层", @"请选择您要装修的房间名称", @"请选择您装修的开始日期"];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"添加装修事件" segmentArray:nil];
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    
    [self createTableView];
}

- (void)createTableView
{
    addDecorateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    addDecorateTableView.delegate = self;
    addDecorateTableView.dataSource = self;
    addDecorateTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    addDecorateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:addDecorateTableView];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
