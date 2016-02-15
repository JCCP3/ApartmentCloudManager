//
//  ApartmentWaterListViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/25.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "ApartmentWaterListViewController.h"
#import "NormalInputTextFieldCell.h"
#import "AddApartmentWaterViewController.h"

@interface ApartmentWaterListViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *aryData;
    
    UITableView *waterListTableView;
}

@end

@implementation ApartmentWaterListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    aryData = [[NSMutableArray alloc] init];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"水表列表" segmentArray:nil];
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    [self adaptSecondRightItemWithTitle:@"添加"];
    
    [self createWaterListTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadWaterList:YES];
}

- (void)createWaterListTableView
{
    waterListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    waterListTableView.delegate = self;
    waterListTableView.dataSource = self;
    waterListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    waterListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:waterListTableView];
    
    
}

- (void)loadWaterList:(BOOL)refresh
{
    NSString *tmpUrl = @"/device/waterside/list.json";
    
    if (refresh) {
        tmpUrl = [tmpUrl stringByAppendingString:@"?currPage=0&pageSize=10"];
    } else {
        tmpUrl = [tmpUrl stringByAppendingString:[NSString stringWithFormat:@"?currPage=%ld&pageSize=10",(long)[aryData count]/10]];
    }
    
    tmpUrl = [tmpUrl stringByAppendingString:@"&bind=N"];
    
    [CustomRequestUtils createNewRequest:tmpUrl
                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDic = responseObject;
        [self parseJsonDic:jsonDic];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)parseJsonDic:(NSDictionary *)dic
{
    NSMutableArray *currentTmpArray = [[NSMutableArray alloc] init];
    if ([dic objectForKey:@"datas"] && [[dic objectForKey:@"datas"] count] > 0) {
        NSMutableArray *tmpArray = [dic objectForKey:@"datas"];
        for (NSDictionary *tmpDic in tmpArray) {
        }
        
        
        aryData = currentTmpArray;
        [waterListTableView reloadData];
    }
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
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"Cell";
        NormalInputTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NormalInputTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.isTextFiledEnable = NO;
        
        
        cell.backgroundColor = [UIColor clearColor];
        
        [cell loadNormalInputTextFieldCellData];
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - BaseAction
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickSecondRightItem
{
    AddApartmentWaterViewController *view = [[AddApartmentWaterViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
}

@end
