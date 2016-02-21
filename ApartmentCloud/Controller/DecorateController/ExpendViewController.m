//
//  ExpendViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/2/20.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "ExpendViewController.h"
#import "ExpendCell.h"
#import "LeftSideViewController.h"
#import "ExpendDetailViewController.h"
#import "MJRefreshDIYHeader.h"
#import "MJRefreshDIYFooter.h"

@interface ExpendViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *expendTableView;
    NSMutableArray *aryData;
}

@end

@implementation ExpendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"支出列表" segmentArray:nil];
    if (self.isFromLeftSide) {
        [self adaptLeftItemWithNormalImage:ImageNamed(@"nav_menu.png") highlightedImage:ImageNamed(@"nav_menu.png")];
    } else {
        [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    }
    
    [self adaptSecondRightItemWithTitle:@"添加"];
    
    aryData = [[NSMutableArray alloc] init];
    
    [self createTableView];
    
    [self loadExpendData:YES];
}

- (void)createTableView
{
    expendTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    expendTableView.delegate = self;
    expendTableView.dataSource = self;
    expendTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:expendTableView];
}

- (void)loadExpendData:(BOOL)refresh
{
    NSString *requestUrl;
    if (refresh) {
        requestUrl = [NSString stringWithFormat:@"/apartment/home/maintain/list.json?currPage=1&pageSize=10"];
    } else {
        
    }
    [CustomRequestUtils createNewRequest:requestUrl success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDic = responseObject;
        if (jsonDic && [[jsonDic objectForKey:@"status"] isEqualToString:RequestSuccessful]) {
            [self parseJsonDic:jsonDic];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)parseJsonDic:(NSDictionary *)jsonDic
{
    if ([jsonDic objectForKey:@"datas"] && [[jsonDic objectForKey:@"datas"] count] > 0) {
        NSMutableArray *currentTmpArray = [[NSMutableArray alloc] init];
        NSMutableArray *tmpArray = [jsonDic objectForKey:@"datas"];
        for (NSDictionary *dic in tmpArray) {
            ExpendInfo *info = [[ExpendInfo alloc] initWithDictionary:dic];
            [currentTmpArray addObject:info];
        }
        
        aryData = currentTmpArray;
        [expendTableView reloadData];
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
    static NSString *cellIdentifier = @"ExpendInfoCell";
    
    ExpendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ExpendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ExpendInfo *info = [aryData objectAtIndex:indexPath.row];
    [cell loadExpendCellData:info];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 109;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpendDetailViewController *view = [[ExpendDetailViewController alloc] init];
    ExpendInfo *expendInfo = [aryData objectAtIndex:indexPath.row];
    view.expendInfo = expendInfo;
    [self.navigationController pushViewController:view animated:YES];
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
        ExpendInfo *expendInfo = [aryData objectAtIndex:indexPath.row];
        [self deleteExpendInfo:expendInfo];
        
        [aryData removeObject:expendInfo];
    }
}

- (void)deleteExpendInfo:(ExpendInfo *)expendInfo
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:expendInfo.expendInfoId forKey:@"id"];
    [CustomRequestUtils createNewPostRequest:@"/apartment/home/maintain/del.json" params:paramDic success:^(id responseObject) {
        NSDictionary *jsonDic = responseObject;
        if (jsonDic && [[jsonDic objectForKey:@"status"] isEqualToString:RequestSuccessful]) {
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - BaseAction
- (void)onClickLeftItem
{
    if (self.isFromLeftSide) {
        LeftSideViewController *leftSideViewController = [[LeftSideViewController alloc] init];
        [[APPDELEGATE ppRevealSideViewController] pushViewController:leftSideViewController onDirection:PPRevealSideDirectionLeft animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)onClickSecondRightItem
{
    ExpendDetailViewController *view = [[ExpendDetailViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
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
