//
//  ApartmentUserListViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/24.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "ApartmentUserListViewController.h"
#import "AddApartmentUserViewController.h"
#import "NormalInputTextFieldCell.h"

@interface ApartmentUserListViewController () <UITableViewDelegate, UITableViewDataSource, AddApartmentUserDelegate>
{
    UITableView *apartmentUserListTableView;
    NSMutableArray *aryData;
}

@end

@implementation ApartmentUserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    aryData = [[NSMutableArray alloc] init];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"住户列表" segmentArray:nil];
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    [self adaptSecondRightItemWithTitle:@"添加"];
    
    [self createApartmentUserListTableView];

    [self addLongTapGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadApartmentUserList];
}

- (void)createApartmentUserListTableView
{
    apartmentUserListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    apartmentUserListTableView.delegate = self;
    apartmentUserListTableView.dataSource = self;
    apartmentUserListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    apartmentUserListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:apartmentUserListTableView];
}

- (void)addLongTapGesture
{
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onClickEdit:)];
    [apartmentUserListTableView addGestureRecognizer:press];
}

- (void)onClickEdit:(UIGestureRecognizer *)rec
{
    CGPoint point = [rec locationInView:apartmentUserListTableView];
    NSIndexPath *indexPath = [apartmentUserListTableView indexPathForRowAtPoint:point];
    
    if (rec.state == UIGestureRecognizerStateBegan) {
        AddApartmentUserViewController *view = [[AddApartmentUserViewController alloc] init];
        view.delegate = self;
        view.currentApartmentUser = [aryData objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:view animated:YES];
    }
}

- (void)loadApartmentUserList
{
    [CustomRequestUtils createNewRequest:@"/tenants/list.json" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDic = responseObject;
//        if (jsonDic && [[jsonDic objectForKey:@"status"] isEqualToString:RequestSuccessful]) {
//            
//        }
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
            ApartmentUser *apartmentUser = [[ApartmentUser alloc] initWithDictionary:tmpDic];
            [currentTmpArray addObject:apartmentUser];
        }
        
        aryData = currentTmpArray;
        [apartmentUserListTableView reloadData];
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
        
        ApartmentUser *user = [aryData objectAtIndex:indexPath.row];
        
        cell.title = @"住户姓名";
        cell.placeHolderTitle = user.name;
        cell.isSelect = user.isSelect;
        
        cell.backgroundColor = [UIColor clearColor];
        
        [cell loadApartmentUserListCellWithIndexPath:indexPath];

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
    ApartmentUser *user = [aryData objectAtIndex:indexPath.row];
    user.isSelect = !user.isSelect;
    [apartmentUserListTableView reloadData];
}


#pragma mark - BaseAction
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickSecondRightItem
{
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    for (ApartmentUser *user in aryData) {
        if (user.isSelect) {
            [tmpArray addObject:user];
        }
    }
    
    if ([tmpArray count] > 0) {
        
        if ([self.delegate respondsToSelector:@selector(AULD_passApartmentUser:)]) {
            [self.delegate AULD_passApartmentUser:tmpArray];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        AddApartmentUserViewController *view = [[AddApartmentUserViewController alloc] init];
        view.delegate = self;
        [self.navigationController pushViewController:view animated:YES];
    }
}


#pragma mark - AddApartmentUserViewControllerDelegate
- (void)AAUD_passApartmentUser:(ApartmentUser *)apartmentUser
{
    
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
