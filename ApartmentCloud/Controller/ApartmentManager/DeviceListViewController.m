//
//  DeviceListViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/2/21.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "DeviceListViewController.h"
#import "DeviceInfo.h"
#import "ExpendCell.h"

#import "AddDeviceInfoViewController.h"

@interface DeviceListViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *deviceTableView;
    
    NSMutableArray *aryData;
}

@end

@implementation DeviceListViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    aryData = [[NSMutableArray alloc] init];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"设备列表" segmentArray:nil];
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    
    [self adaptSecondRightItemWithTitle:@"添加"];
    
    [self createTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadDeviceList];
}

- (void)createTableView
{
    deviceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    deviceTableView.delegate = self;
    deviceTableView.dataSource = self;
    deviceTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 20)];
    deviceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:deviceTableView];
}

- (void)loadDeviceList
{
    NSString *requestUrl = [NSString stringWithFormat:@"/device/list.json?homeId=%ld",[self.apartmentRoom.roomId integerValue]];
    
    [CustomRequestUtils createNewRequest:requestUrl success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDic = responseObject;
        
        if (jsonDic) {
            [self parseJsonDic:jsonDic];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)parseJsonDic:(NSDictionary *)jsonDic
{
    NSMutableArray *currentTmpArray = [[NSMutableArray alloc] init];
    if ([[jsonDic objectForKey:@"datas"] count] > 0) {
        NSMutableArray *tmpArray = [jsonDic objectForKey:@"datas"];
        for (NSDictionary *tmpDic in tmpArray) {
            DeviceInfo *info = [[DeviceInfo alloc] initWithDictionary:tmpDic];
            [currentTmpArray addObject:info];
        }
        
        aryData = currentTmpArray;
        
        [deviceTableView reloadData];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView
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
    
    DeviceInfo *info = [aryData objectAtIndex:indexPath.row];
    [cell loadDeviceCellData:info];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 109;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddDeviceInfoViewController *view = [[AddDeviceInfoViewController alloc] init];
    view.currentDeviceInfo = [aryData objectAtIndex:indexPath.row];
    view.homeId = self.apartmentRoom.roomId;
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
        DeviceInfo *deviceInfo = [aryData objectAtIndex:indexPath.row];
        
        if ([aryData containsObject:deviceInfo]) {
            [aryData removeObject:deviceInfo];
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self deleteDeviceInfo:deviceInfo];
    }
}

- (void)deleteDeviceInfo:(DeviceInfo *)deviceInfo
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:deviceInfo.deviceId forKey:@"id"];
    
    [CustomRequestUtils createNewPostRequest:@"/device/del.json" params:paramDic success:^(id responseObject) {
        NSDictionary *jsonDic = responseObject;
        if (jsonDic) {
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}



#pragma mark -
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickSecondRightItem
{
    AddDeviceInfoViewController *view = [[AddDeviceInfoViewController alloc] init];
    view.homeId = self.apartmentRoom.roomId;
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
