//
//  AddApartmentDescViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/18.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "AddApartmentDescViewController.h"

@interface AddApartmentDescViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *addApartmentDescTableView;
    
    NSArray *aryTitleData;
    NSArray *aryPlaceHolderData;
}

@end

@implementation AddApartmentDescViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    aryTitleData = @[@"房间名称", @"租住状态", @"月租金" , @"押金", @"租赁时间", @"交租方式", @"居住人数", @"出租类型"];
    aryPlaceHolderData = @[@"请输入房间名称", @"请选择租住状态", @"请输入月租金", @"请输入押金", @"请选择租赁时间", @"请选择交租方式", @"请选择居住人数", @"请选择出租类型"];
    
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"房间详情" segmentArray:nil];
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    [self adaptSecondRightItemWithTitle:@"确认添加"];
    [self createTableView];
}

- (void)createTableView
{
    addApartmentDescTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    addApartmentDescTableView.delegate = self;
    addApartmentDescTableView.dataSource = self;
    addApartmentDescTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    addApartmentDescTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:addApartmentDescTableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
