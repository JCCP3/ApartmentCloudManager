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
#import "MJRefreshDIYHeader.h"
#import "LeftSideViewController.h"

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
    if (self.fromLeftSide) {
        [self adaptLeftItemWithNormalImage:ImageNamed(@"nav_menu.png") highlightedImage:ImageNamed(@"nav_menu.png")];
    } else {
        [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    }
    
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
    [self.view addSubview:waterListTableView];
}

- (void)loadWaterList:(BOOL)refresh
{
    NSString *tmpUrl = [NSString stringWithFormat:@"/device/waterside/list.json"];
    
    if (refresh) {
        tmpUrl = [tmpUrl stringByAppendingString:@"?currPage=1&pageSize=10"];
    } else {
        tmpUrl = [tmpUrl stringByAppendingString:[NSString stringWithFormat:@"?currPage=%ld&pageSize=10",(long)[aryData count]/10 + 1]];
    }
    
//    tmpUrl = [tmpUrl stringByAppendingString:@"&noBinding=N"];
    
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
            Water *water = [[Water alloc] initWithDictionary:tmpDic];
            [currentTmpArray addObject:water];
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
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    Water *water = [aryData objectAtIndex:indexPath.row];
    cell.textLabel.text = water.mark;
    cell.textLabel.textColor = [UIColor blackColor];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"当前读数:%ld", (long)water.currentNumber];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    return cell;
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
    if (!self.fromLeftSide) {
        if ([self.delegate respondsToSelector:@selector(AWLD_passApartmentWater:)]) {
            [self.delegate AWLD_passApartmentWater:[aryData objectAtIndex:indexPath.row]];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        AddApartmentWaterViewController *view = [[AddApartmentWaterViewController alloc] init];
        view.currentWater = [aryData objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:view animated:YES];
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Water *water = [aryData objectAtIndex:indexPath.row];
        [aryData removeObject:water];
        
        [self deleteWaterInfo:water];
    }
}

- (void)deleteWaterInfo:(Water *)water
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:water.waterId forKey:@"id"];
    
    [CustomRequestUtils createNewPostRequest:@"/device/waterside/del.json" params:paramDic success:^(id responseObject) {
        NSDictionary *jsonDic = responseObject;
        if (jsonDic) {
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - BaseAction
- (void)onClickLeftItem
{
    if (self.fromLeftSide) {
        LeftSideViewController *leftSideViewController = [[LeftSideViewController alloc] init];
        [[APPDELEGATE ppRevealSideViewController] pushViewController:leftSideViewController onDirection:PPRevealSideDirectionLeft animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)onClickSecondRightItem
{
    AddApartmentWaterViewController *view = [[AddApartmentWaterViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
}

@end
