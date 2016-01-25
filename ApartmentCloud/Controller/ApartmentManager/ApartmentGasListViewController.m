//
//  ApartmentGasListViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/25.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "ApartmentGasListViewController.h"
#import "NormalInputTextFieldCell.h"

@interface ApartmentGasListViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *gasTableView;
    
    NSMutableArray *aryData;
}

@end

@implementation ApartmentGasListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    aryData = [[NSMutableArray alloc] init];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"气表列表" segmentArray:nil];
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    
    [self createGasListTableView];
    
    [self loadGasList];
}

- (void)createGasListTableView
{
    gasTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    gasTableView.delegate = self;
    gasTableView.dataSource = self;
    gasTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    gasTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:gasTableView];
}

- (void)loadGasList
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
        [gasTableView reloadData];
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


@end
