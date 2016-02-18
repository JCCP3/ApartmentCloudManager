//
//  AddApartmentUserViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/18.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "AddApartmentUserViewController.h"
#import "NormalInputTextFieldCell.h"

@interface AddApartmentUserViewController () <UITableViewDelegate, UITableViewDataSource, NormalInputTextFieldCellDelegate, UIActionSheetDelegate>
{
    UITableView *addApartmentUserTableView;
    
    NSArray *aryTitleData;
    NSArray *aryPlaceHolderData;
}

@end

@implementation AddApartmentUserViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    aryTitleData = @[@"住户姓名", @"住户性别", @"手机号码", @"身份证号"];
    aryPlaceHolderData = @[@"请输入住户姓名", @"请选择住户性别", @"请输入手机号码", @"请输入身份证号"];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"添加住户" segmentArray:nil];
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    [self adaptSecondRightItemWithTitle:@"确认添加"];
    
    if (!self.currentApartmentUser) {
        self.currentApartmentUser = [[ApartmentUser alloc] init];
    }
    
    [self createTableView];
}

- (void)createTableView
{
    addApartmentUserTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    addApartmentUserTableView.delegate = self;
    addApartmentUserTableView.dataSource = self;
    addApartmentUserTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    addApartmentUserTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:addApartmentUserTableView];
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
    return [aryTitleData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    NormalInputTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NormalInputTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 1) {
        cell.isTextFiledEnable = NO;
    } else {
        cell.isTextFiledEnable = YES;
    }
    
    cell.delegate = self;
    cell.cellType = AddApartmentUserLogic;
    cell.apartmentUser = self.currentApartmentUser;
    
    cell.title = [aryTitleData objectAtIndex:indexPath.row];
    cell.placeHolderTitle = [aryPlaceHolderData objectAtIndex:indexPath.row];
    
    [cell loadAddUserCellWithIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self onClickResign];
    
    if (indexPath.row == 1) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        actionSheet.tag = 111;
        [actionSheet showInView:self.view];
    }
}

- (void)onClickResign
{
    int i = 0 ;
    while (i < 1) {
        
        int maxNum = 4;
        
        for (int j = 0 ; j < maxNum ; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            NormalInputTextFieldCell *cell = (NormalInputTextFieldCell *)[addApartmentUserTableView cellForRowAtIndexPath:indexPath];
            for (UIView *subView in cell.subviews) {
                UIView *wrapperView = (UIView *)[subView viewWithTag:10086];
                for (UIView *tmpSubView in wrapperView.subviews) {
                    if ([tmpSubView isKindOfClass:[UITextField class]]) {
                        UITextField *textField = (UITextField *)tmpSubView;
                        [textField resignFirstResponder];
                    }
                }
            }
        }
        
        i ++;
    }
}


#pragma mark - BaseAction
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickSecondRightItem
{
    [self onClickResign];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    NSString *requestUrl = @"";
    if (self.currentApartmentUser.apartmentUserId) {
        [paramDic setValue:self.currentApartmentUser.apartmentUserId forKey:@"id"];
        requestUrl = @"/tenants/update.json";
    } else {
        requestUrl = @"/tenants/add.json";
    }
    [paramDic setObject:self.currentApartmentUser.name forKey:@"name"];
    [paramDic setObject:self.currentApartmentUser.numberId forKey:@"numberId"];
    [paramDic setObject:self.currentApartmentUser.phone
                 forKey:@"phone"];
    [paramDic setObject:self.currentApartmentUser.userSex forKey:@"sex"];
    
    [CustomRequestUtils createNewPostRequest:requestUrl params:paramDic success:^(id responseObject) {
        NSDictionary *jsonDic = responseObject;
        if ([[jsonDic objectForKey:@"status"] isEqualToString:RequestSuccessful]) {
            //添加用户成功
            if ([self.delegate respondsToSelector:@selector(AAUD_passApartmentUser:)]) {
                [self.delegate AAUD_passApartmentUser:self.currentApartmentUser];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}


#pragma mark - NormalInputTextFieldCellDelegate
- (void)NITFC_addApartmentUser:(ApartmentUser *)apartmentUser
{
    self.currentApartmentUser = apartmentUser;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex < 2) {
        NSString *sex = [actionSheet buttonTitleAtIndex:buttonIndex];
        self.currentApartmentUser.userSex = sex;
        
        [addApartmentUserTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end
