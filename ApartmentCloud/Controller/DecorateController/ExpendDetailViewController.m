//
//  ExpendDetailViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/2/20.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "ExpendDetailViewController.h"
#import "NormalInputTextFieldCell.h"

@interface ExpendDetailViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *expendDetailTableView;
    
    NSMutableArray *aryData;
}

@end

@implementation ExpendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"支出列表" segmentArray:nil];
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    
    aryData = [[NSMutableArray alloc] init];
    
    [self createTableView];
}

- (void)createTableView
{
    expendDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    expendDetailTableView.delegate = self;
    expendDetailTableView.dataSource = self;
    expendDetailTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    expendDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:expendDetailTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    NormalInputTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NormalInputTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 2 || indexPath.row == 4) {
        cell.isTextFiledEnable = YES;
    } else {
        cell.isTextFiledEnable = NO;
    }
    
    return cell;
    
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
