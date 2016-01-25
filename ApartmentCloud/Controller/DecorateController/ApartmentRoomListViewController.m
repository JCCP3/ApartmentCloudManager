
//
//  ApartmentRoomListViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/25.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "ApartmentRoomListViewController.h"

@interface ApartmentRoomListViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *aryData;
    UITableView *apartmentRoomListTableView;
}

@end

@implementation ApartmentRoomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    aryData = [[NSMutableArray alloc] init];
    
    if (self.aryApartmentRoom && [self.aryApartmentRoom count] > 0) {
        aryData = self.aryApartmentRoom;
    }
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"公寓房间列表" segmentArray:nil];
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    [self adaptSecondRightItemWithTitle:@"添加"];
    
    [self createApartmentRoomListTableView];
}

- (void)createApartmentRoomListTableView
{
    apartmentRoomListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    apartmentRoomListTableView.delegate = self;
    apartmentRoomListTableView.dataSource = self;
    [self.view addSubview:apartmentRoomListTableView];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ApartmentRoom *room = [aryData objectAtIndex:indexPath.row];
    
    cell.textLabel.textColor = [CustomColorUtils colorWithHexString:@"#333333"];
    cell.textLabel.text = @"房间名称";
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.detailTextLabel.textColor = [CustomColorUtils colorWithHexString:@"#bbbbbb"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
    cell.detailTextLabel.text = room.homeName;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApartmentRoom *room = [aryData objectAtIndex:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(ARLD_passApartmentRoom:)]) {
        [self.delegate ARLD_passApartmentRoom:room];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - BaseAction
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickSecondRightItem
{
    //添加
}


@end
