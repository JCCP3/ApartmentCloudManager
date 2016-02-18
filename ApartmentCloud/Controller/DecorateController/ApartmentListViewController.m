//
//  ApartmentListViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/25.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "ApartmentListViewController.h"
#import "ApartmentRoom.h"

@interface ApartmentListViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *apartmentListTableView;
    
    NSMutableArray *aryApartmentRoomItem;
    NSMutableArray *aryApartmentItem;
}

@end

@implementation ApartmentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    aryApartmentRoomItem = [[NSMutableArray alloc] init];
    aryApartmentItem = [[NSMutableArray alloc] init];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"公寓列表" segmentArray:nil];
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    
    [self createApartmentListTableView];
    
    [self loadApartmentList];
}

- (void)createApartmentListTableView
{
    apartmentListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    apartmentListTableView.delegate = self;
    apartmentListTableView.dataSource = self;
    [self.view addSubview:apartmentListTableView];
}

- (void)loadApartmentList
{
    [CustomRequestUtils createNewRequest:@"/apartment/list.json" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDic = responseObject;
        [self parseJsonData:jsonDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)parseJsonData:(NSDictionary *)jsonDic
{
    NSMutableArray *finalApartmentArray = [[NSMutableArray alloc] init];
    NSMutableArray *finalArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *tmpArray = [jsonDic objectForKey:@"datas"];
    if (tmpArray && [tmpArray count] > 0) {
        for (NSDictionary *dic in tmpArray) {
            
            Apartment *apartment = [[Apartment alloc] initWithDictionary:dic];
            [finalApartmentArray addObject:apartment];
            
            NSMutableArray *aryApartmentRomeData = [[NSMutableArray alloc] init];
            if ([dic objectForKey:@"apartmentHomes"]) {
                NSMutableArray *currentTmpArray = [dic objectForKey:@"apartmentHomes"];
                
                if (currentTmpArray && [currentTmpArray count] > 0) {
                    for (NSDictionary *tmpDic in currentTmpArray) {
                        ApartmentRoom *room = [[ApartmentRoom alloc] initWithDictionary:tmpDic];
                        [aryApartmentRomeData addObject:room];
                    }
                }
            }
            
            NSMutableDictionary *currentTmpDic = [[NSMutableDictionary alloc] init];
            [currentTmpDic setObject:aryApartmentRomeData forKey:apartment.apartmentName];
            
            [finalArray addObject:currentTmpDic];
            
        }
        
        if ([finalArray count] > 0) {
            aryApartmentRoomItem = finalArray;
        }
        
        if ([finalApartmentArray count] > 0) {
            aryApartmentItem = finalApartmentArray;
        }
        
        [apartmentListTableView reloadData];
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
    return [aryApartmentItem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Apartment *apartment = [aryApartmentItem objectAtIndex:indexPath.row];
    
    cell.textLabel.textColor = [CustomColorUtils colorWithHexString:@"#333333"];
    cell.textLabel.text = @"公寓名称";
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.detailTextLabel.textColor = [CustomColorUtils colorWithHexString:@"#bbbbbb"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
    cell.detailTextLabel.text = apartment.apartmentName;
    
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
    NSDictionary *tmpDic = [aryApartmentRoomItem objectAtIndex:indexPath.row];
    Apartment *apartment = [aryApartmentItem objectAtIndex:indexPath.row];
    NSMutableArray *tmpArray = [tmpDic objectForKey:apartment.apartmentName];
    
    if ([self.delegate respondsToSelector:@selector(ALVCD_passApartment:withRoomArray:)]) {
        [self.delegate ALVCD_passApartment:apartment withRoomArray:tmpArray];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - BaseAction
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
