//
//  AddApartmentViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/13.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "AddApartmentViewController.h"
#import "NormalInputTextFieldCell.h"
#import "AddApartmentFloorViewController.h"

typedef enum
{
    CONCENTRATED = 1,
    DISPERSION = 2,
    HOTELS
    
}ApartmentStyle;

@interface AddApartmentViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate, NormalInputTextFieldCellDelegate>
{
    UITableView *addApartmentTableView;
    NSArray *aryTitleData;
    NSArray *aryPlaceHolderData;
    NSArray *aryApartmentStyle;
    NSArray *aryApartmentStypeId;
    
    CGFloat keyboardOriginY;
    CGFloat keyboardHeight;
}

@end

@implementation AddApartmentViewController
@synthesize addApartment;

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [CustomColorUtils colorWithHexString:@"#f7f7f7"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (!addApartment) {
        addApartment = [[Apartment alloc] init];
    }
    
    aryTitleData = @[@"公寓名称", @"公寓类型", @"管理电话", @"公寓区域", @"道路名称", @"小区名称", @"水(元/吨)", @"电(元/度)", @"气(元/m)"];
    aryPlaceHolderData = @[@"请选择您的公寓名称", @"请选择您的公寓类型", @"请输入您的管理电话号码", @"请选择您公寓所在的区域", @"请输入公寓所在道路名称", @"请输入公寓所在小区名称", @"请输入用水费用标准", @"请输入用电费用标准", @"请输入燃气费用标准"];
    aryApartmentStyle = @[@"集中式",@"分散式",@"酒店"];
    aryApartmentStypeId = @[@"CONCENTRATED", @"DISPERSION", @"HOTELS"];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"添加公寓" segmentArray:nil];
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    [self adaptSecondRightItemWithTitle:@"下一步"];
    
    [self createTableView];
    
    [self addTableViewGesture];
}

- (void)addTableViewGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickResign)];
    tap.delegate = self;
    [addApartmentTableView addGestureRecognizer:tap];
}

- (void)onClickResign
{
    int i = 0 ;
    while (i < 2) {
        
        int maxNum = i == 0 ? 6 : 3;
        
        for (int j = 0 ; j < maxNum ; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            NormalInputTextFieldCell *cell = (NormalInputTextFieldCell *)[addApartmentTableView cellForRowAtIndexPath:indexPath];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addKeyboardObserver];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeObservers];
}

- (void)addKeyboardObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeKeyboardFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIKeyboardNotification
- (void)changeKeyboardFrame:(NSNotification *)notification
{
    keyboardOriginY = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    if (keyboardOriginY != MainScreenHeight) {
        [addApartmentTableView setFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - keyboardHeight - 64)];
    } else {
        [addApartmentTableView setFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    }
}

- (void)createTableView
{
    addApartmentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    addApartmentTableView.delegate = self;
    addApartmentTableView.dataSource = self;
    addApartmentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:addApartmentTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 6;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld",(long)indexPath.section, (long)indexPath.row];
    NormalInputTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NormalInputTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.cellType = AddApartmentLogic;
    cell.delegate = self;
    cell.backgroundColor = [UIColor clearColor];

    if (indexPath.section == 0) {
        cell.title = [aryTitleData objectAtIndex:indexPath.row];
        cell.placeHolderTitle = [aryPlaceHolderData objectAtIndex:indexPath.row];
        if (indexPath.row == 2 || indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 5) {
            if (indexPath.row == 2) {
                cell.keyboardType = KeyboardNumPad;
            }
            cell.isTextFiledEnable = YES;
        } else {
            cell.isTextFiledEnable = NO;
        }
    } else {
        cell.title = [aryTitleData objectAtIndex:indexPath.row + 6];
        cell.placeHolderTitle = [aryPlaceHolderData objectAtIndex:indexPath.row + 6];
        cell.isTextFiledEnable = YES;
    }
    
    cell.apartment = addApartment;
    [cell loadAddApartmentCellWithIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    } else {
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 44)];
    headerView.backgroundColor = [UIColor clearColor];
    [headerView.subviews makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    
    UIView *verticalSepaView = [[UIView alloc] initWithFrame:CGRectMake(10, 14, 3, 16)];
    verticalSepaView.backgroundColor = AppThemeColor;
    [headerView addSubview:verticalSepaView];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(verticalSepaView.frame) + 5, 14, 100, 16)];
    descLabel.font = [UIFont systemFontOfSize:16.f];
    descLabel.textColor = AppThemeColor;
    NSString *title;
    if (section == 0) {
        title = @"基本信息";
    } else {
        title = @"费用设定";
    }
    descLabel.text = title;
    [headerView addSubview:descLabel];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"集中式",@"分散式",@"酒店", nil];
            actionSheet.tag = 12590;
            [actionSheet showInView:self.view];
        } else if (indexPath.row == 3) {
            
        }
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
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"添加楼层",@"完成添加", nil];
    actionSheet.tag = 12580;
    
    [actionSheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 12580) {
        if (buttonIndex == 0) {
            //添加楼层
            AddApartmentFloorViewController *view = [[AddApartmentFloorViewController alloc] init];
            [self.navigationController pushViewController:view animated:YES];
            
        } else if (buttonIndex == 1) {
            //添加公寓
            [self addApartmentToServer];
        }
    } else if (actionSheet.tag == 12590) {
        if (buttonIndex < aryApartmentStyle.count) {
//            NSString *apartmentStyle = [aryApartmentStyle objectAtIndex:buttonIndex];
            addApartment.category = [aryApartmentStypeId objectAtIndex:buttonIndex];
            [addApartmentTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (void)addApartmentToServer
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:addApartment.apartmentName forKey:@"apartmentName"];
    [paramDic setObject:addApartment.category forKey:@"category"];
    [paramDic setObject:addApartment.managerPhone forKey:@"managerPhone"];
    [paramDic setObject:@"123" forKey:@"cityId"];
    [paramDic setObject:addApartment.communityName forKey:@"communityName"];
    [paramDic setObject:addApartment.roadName forKey:@"roadName"];
    [paramDic setObject:addApartment.waterPrice forKey:@"waterPrice"];
    [paramDic setObject:addApartment.electricityPrice forKey:@"electricityPrice"];
    [paramDic setObject:addApartment.gasPrice forKey:@"gasPrice"];
    [CustomRequestUtils createNewPostRequest:@"/apartment/add.json" params:paramDic success:^(id responseObject) {
        NSDictionary *jsonDic = responseObject;
        if (jsonDic && [[jsonDic objectForKey:@"status"] isEqualToString:RequestSuccessful]) {
            if ([self.delegate respondsToSelector:@selector(AAVCD_passApartment:)]) {
                [self.delegate AAVCD_passApartment:addApartment];
            }
            //添加公寓成功
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - UIGestureRecognize delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view.superview class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - NormalInputTextFieldDelegate
- (void)NITFC_addApartmentWithApartment:(Apartment *)apartment
{
    addApartment = apartment;
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
