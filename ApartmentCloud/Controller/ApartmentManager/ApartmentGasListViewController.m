
//
//  ApartmentGasListViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/25.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "ApartmentGasListViewController.h"
#import "NormalInputTextFieldCell.h"
#import "AddApartmentGasViewController.h"
#import "LeftSideViewController.h"
#import "Gas.h"

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
    
    if (self.fromLeftSide) {
        [self adaptLeftItemWithNormalImage:ImageNamed(@"nav_menu.png") highlightedImage:ImageNamed(@"nav_menu.png")];
    } else {
        [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    }
    
    [self adaptSecondRightItemWithTitle:@"添加"];
    [self createGasListTableView];
    
    [self loadGasList:YES];
}

- (void)createGasListTableView
{
    gasTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    gasTableView.delegate = self;
    gasTableView.dataSource = self;
    gasTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:gasTableView];
}

- (void)loadGasList:(BOOL)refresh
{
    NSString *requestUrl;
    if (refresh) {
        requestUrl = @"/device/gasmeter/list.json?currPage=1&pageSize=10";
    } else {
        
    }
    [CustomRequestUtils createNewRequest:requestUrl success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            Gas *gas = [[Gas alloc] initWithDictionary:tmpDic];
            [currentTmpArray addObject:gas];
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
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    Gas *gas = [aryData objectAtIndex:indexPath.row];
    cell.textLabel.text = gas.mark;
    cell.textLabel.textColor = [UIColor blackColor];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"当前读数:%ld", (long)gas.currentNumber];
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
    if (self.fromLeftSide) {
        AddApartmentGasViewController *view = [[AddApartmentGasViewController alloc] init];
        view.currentGas = [aryData objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:view animated:YES];
    } else {
        if ([self.delegate respondsToSelector:@selector(AGLD_passApartmentGas:)]) {
            [self.delegate AGLD_passApartmentGas:[aryData objectAtIndex:indexPath.row]];
        }
        [self.navigationController popViewControllerAnimated:YES];
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
        Gas *gas = [aryData objectAtIndex:indexPath.row];
        [aryData removeObject:gas];
        
        [self deleteGasInfo:gas];
    }
}

- (void)deleteGasInfo:(Gas *)gas
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:gas.gasId forKey:@"id"];
    
    [CustomRequestUtils createNewPostRequest:@"/device/gasmeter/del.json" params:paramDic success:^(id responseObject) {
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
    AddApartmentGasViewController *view = [[AddApartmentGasViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
}

@end
