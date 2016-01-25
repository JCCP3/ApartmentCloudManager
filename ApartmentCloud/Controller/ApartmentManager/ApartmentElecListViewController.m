//
//  ApartmentElecViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/25.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "ApartmentElecListViewController.h"
#import "NormalInputTextFieldCell.h"

@interface ApartmentElecListViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *aryData;
    
    UITableView *elecListTableView;
}

@end

@implementation ApartmentElecListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    aryData = [[NSMutableArray alloc] init];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"电表列表" segmentArray:nil];
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    
    [self createElecListTableView];
    
    [self loadElecList];
    
}

- (void)createElecListTableView
{
    elecListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    elecListTableView.delegate = self;
    elecListTableView.dataSource = self;
    elecListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    elecListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:elecListTableView];
}

- (void)loadElecList
{
    [CustomRequestUtils createNewRequest:@"/tenants/list.json" success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        [elecListTableView reloadData];
    }
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

@end
