//
//  AddApartmentDescViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/18.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "AddApartmentRoomViewController.h"
#import "NormalInputTextFieldCell.h"
#import "ApartmentRoom.h"
#import "AddApartmentUserViewController.h"
#import "NormalTextViewCell.h"
#import "DateFormatUtils.h"
#import "ApartmentUserListViewController.h"
#import "ApartmentGasListViewController.h"
#import "ApartmentWaterListViewController.h"
#import "ApartmentElecListViewController.h"
#import "CustomTimeUtils.h"
#import "HouseHolderInfoViewController.h"
#import "ExpendViewController.h"
#import "DeviceListViewController.h"
#import "HouseHolderListViewController.h"

typedef enum{
    
    RENT_ING = 1,
    IDLE_ING = 2,
    NO_CLEAN = 3
    
}ApartmentStatus;


@interface AddApartmentRoomViewController () <UITableViewDelegate, UITableViewDataSource, NormalInputTextFieldCellDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate, ApartmentUserListDelegate, AddApartmentUserDelegate, ApartmentElecListDelegate, ApartmentGasListDelegate, ApartmentWaterListDelegate>
{
    UITableView *addRoomTableView;
    
    NSArray *aryTitleData;
    NSArray *aryPlaceHolderData;

    NSArray *aryStatusItem;
    NSArray *aryRentItem;
    NSArray *aryTanantItem;
    
    UIDatePicker *datePicker;
    
    CGFloat keyboardHeight;
    CGFloat keyboardOriginY;
    
    BOOL datePickerShowed;
}

@end

@implementation AddApartmentRoomViewController
@synthesize apartmentRoom;

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    aryTitleData = @[@"房间名称", @"租住状态", @"月租金" , @"押金", @"租赁时间", @"交租方式", @"居住人数", @"出租类型"];
    aryPlaceHolderData = @[@"请输入房间名称", @"请选择租住状态", @"请输入月租金", @"请输入押金", @"请选择租赁时间", @"请选择交租方式", @"请选择居住人数", @"请选择出租类型"];
    
    aryStatusItem = @[@"RENT_ING", @"IDLE_ING", @"NO_CLEAN"];
    aryRentItem = @[@"ALL", @"ROOMMATE"];
    aryTanantItem = @[@"1人", @"2人", @"3人", @"3人以上"];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"房间详情" segmentArray:nil];
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    
    
    
    if ([apartmentRoom.roomId integerValue] > 0) {
        [self adaptSecondRightItemWithTitle:@"更多"];
        [self adaptFirstRightItemWithTitle:@"更新"];
    } else {
        [self adaptSecondRightItemWithTitle:@"添加"];
    }

    
    if (!apartmentRoom) {
        apartmentRoom = [[ApartmentRoom alloc] init];
        apartmentRoom.deliverCategory = @"M_2_1";
        apartmentRoom.aryApartmentUser = [[NSMutableArray alloc] init];
    }
    
    [self initDatePickerView];
    
    [self createTableView];
    
    [self addTableViewGesture];
    
    [self addKeyboardObserver];
}

- (void)createTableView
{
    addRoomTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    addRoomTableView.delegate = self;
    addRoomTableView.dataSource = self;
    addRoomTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 20)];
    addRoomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:addRoomTableView];
}

- (void)addTableViewGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickResign)];
    tap.delegate = self;
    [addRoomTableView addGestureRecognizer:tap];
}

- (void)onClickResign
{
    int i = 0 ;
    while (i < 1) {
        
        int maxNum = i == 0 ? 8 : 0;
        
        for (int j = 0 ; j < maxNum ; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            NormalInputTextFieldCell *cell = (NormalInputTextFieldCell *)[addRoomTableView cellForRowAtIndexPath:indexPath];
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
    
    for (int j = 0 ; j < 1 ; j++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:2];
        NormalTextViewCell *cell = (NormalTextViewCell *)[addRoomTableView cellForRowAtIndexPath:indexPath];
        for (UIView *subView in cell.subviews) {
            UIView *wrapperView = (UIView *)[subView viewWithTag:10086];
            for (UIView *tmpSubView in wrapperView.subviews) {
                if ([tmpSubView isKindOfClass:[UITextView class]]) {
                    UITextView *textView = (UITextView *)tmpSubView;
                    [textView resignFirstResponder];
                    if (![CustomStringUtils isBlankString:textView.text]) {
                        apartmentRoom.mark = textView.text;
                    }
                }
            }
        }
    }
    
    if (datePickerShowed) {
        [self hideDatePickerView];
    }
}

- (void)addKeyboardObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeKeyboardHeight:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)changeKeyboardHeight:(NSNotification *)notification
{
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardHeight = keyboardRect.size.height;
    keyboardOriginY = keyboardRect.origin.y;
    
    if (keyboardOriginY != MainScreenHeight) {
        
        [self hideDatePickerView];
        
        [addRoomTableView setFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 - keyboardHeight)];
    } else {
        [addRoomTableView setFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [aryTitleData count];
            break;
            
        case 1:
            return [apartmentRoom.aryApartmentUser count];
            break;
            
        case 2:
            return 1;
            break;
            
        case 3:
            if (apartmentRoom.water) {
                return 1;
            } else {
                return 0;
            }
            break;
            
        case 4:
            if (apartmentRoom.elec) {
                return 1;
            } else {
                return 0;
            }
            break;
            
        case 5:
            if (apartmentRoom.gas) {
                return 1;
            } else {
                return 0;
            }
            break;
            
        default:
            break;
    }
    
    return 0;
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
        
        if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 3) {
            cell.isTextFiledEnable = YES;
        } else {
            cell.isTextFiledEnable = NO;
        }
        
        cell.title = [aryTitleData objectAtIndex:indexPath.row];
        cell.placeHolderTitle = [aryPlaceHolderData objectAtIndex:indexPath.row];
        
        cell.cellType = AddRoomLogic;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.room = apartmentRoom;
        [cell loadAddRoomCellWithIndexPath:indexPath];
        
        return cell;

    } else if (indexPath.section == 1) {
        
        ApartmentUser *apartmentUser = [apartmentRoom.aryApartmentUser objectAtIndex:indexPath.row];
        static NSString *cellIdentifier = @"ApartmentUserCell";
        NormalInputTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NormalInputTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.isTextFiledEnable = NO;
        cell.title = @"住户姓名";
        cell.descTextField.text = apartmentUser.name;
        
        cell.backgroundColor = [UIColor clearColor];
        
        [cell loadNormalInputTextFieldCellData];
        
        return cell;
        
    } else if (indexPath.section == 2) {
        
        static NSString *cellIdentifier = @"NormalTextViewCell";
        
        NormalTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NormalTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        
        cell.title = @"房间备注";
        cell.placeHolderTitle = @"添加房间备注";
        
        [cell loadNormalTextViewCell];
        
        return cell;
        
    } else if (indexPath.section == 3) {
        
        static NSString *cellIdentifier = @"WaterCell";
        NormalInputTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NormalInputTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.isTextFiledEnable = NO;
        cell.title = @"水表名称";
        cell.descTextField.text = apartmentRoom.water.mark;
        
        cell.backgroundColor = [UIColor clearColor];
        
        [cell loadNormalInputTextFieldCellData];
        
        return cell;
    } else if (indexPath.section == 4) {
        
        static NSString *cellIdentifier = @"ElecCell";
        NormalInputTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NormalInputTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.isTextFiledEnable = NO;
        cell.title = @"电表名称";
        cell.descTextField.text = apartmentRoom.elec.mark;
        
        cell.backgroundColor = [UIColor clearColor];
        
        [cell loadNormalInputTextFieldCellData];
        
        return cell;
        
    } else if (indexPath.section == 5) {
        
        static NSString *cellIdentifier = @"GasCell";
        NormalInputTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NormalInputTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.isTextFiledEnable = NO;
        cell.title = @"气表名称";
        cell.descTextField.text = apartmentRoom.gas.mark;
        
        cell.backgroundColor = [UIColor clearColor];
        
        [cell loadNormalInputTextFieldCellData];
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return 120;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 28.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 28)];
    [sectionHeaderView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel *sepaLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 3, 16)];
    sepaLabel.backgroundColor = AppThemeColor;
    [sectionHeaderView addSubview:sepaLabel];
    
    UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(16, 12, 200, 16)];
    sectionTitle.backgroundColor = [UIColor clearColor];
    sectionTitle.textColor = AppThemeColor;
    sectionTitle.font = [UIFont systemFontOfSize:16];
    NSString *title = @"";
    if (section == 0) {
        title = @"基本信息";
    } else if (section == 1) {
        title = @"住户信息";
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 10 - 100, 16, 100, 12)];
        [btn setTitle:@"添加住户" forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [btn setTitleColor:AppThemeColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            ApartmentUserListViewController *view = [[ApartmentUserListViewController alloc] init];
            view.delegate = self;
            [self.navigationController pushViewController:view animated:YES];
        }];
        [sectionHeaderView addSubview:btn];
        
    } else if (section == 2){
        title = @"特殊备注";
    } else if (section == 3) {
        title = @"水表读数";
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 10 - 100, 16, 100, 12)];
        [btn setTitle:@"添加水表" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [btn setTitleColor:AppThemeColor forState:UIControlStateNormal];
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            ApartmentWaterListViewController *view = [[ApartmentWaterListViewController alloc] init];
            view.delegate = self;
            [self.navigationController pushViewController:view animated:YES];
        }];
        [sectionHeaderView addSubview:btn];
        
    } else if (section == 4) {
        title = @"电表读数";
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 10 - 100, 16, 100, 12)];
        [btn setTitle:@"添加电表" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [btn setTitleColor:AppThemeColor forState:UIControlStateNormal];
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            ApartmentElecListViewController *view = [[ApartmentElecListViewController alloc] init];
            view.delegate = self;
            [self.navigationController pushViewController:view animated:YES];
        }];
        [sectionHeaderView addSubview:btn];
        
    } else {
        title = @"燃气读数";
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 10 - 100, 16, 100, 12)];
        [btn setTitle:@"添加燃气" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [btn setTitleColor:AppThemeColor forState:UIControlStateNormal];
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            ApartmentGasListViewController *view = [[ApartmentGasListViewController alloc] init];
            view.delegate = self;
            [self.navigationController pushViewController:view animated:YES];
        }];
        [sectionHeaderView addSubview:btn];
        
    }
    sectionTitle.text = [GlobalUtils translateStr:title];
    [sectionHeaderView addSubview:sectionTitle];
    
    return sectionHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self onClickResign];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"出租中",@"闲置中",@"未打扫", nil];
            actionSheet.tag = 111;
            [actionSheet showInView:self.view];
        } else if (indexPath.row == 4) {
            
            [self showDatePickerView];
            
        } else if (indexPath.row == 6) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"1人", @"2人", @"3人", @"3人以上",nil];
            actionSheet.tag = 112;
            [actionSheet showInView:self.view];
        } else if (indexPath.row == 7) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"整租",@"合租", nil];
            actionSheet.tag = 113;
            [actionSheet showInView:self.view];
        }
    } else if (indexPath.section == 1) {
        AddApartmentUserViewController *view = [[AddApartmentUserViewController alloc] init];
        view.delegate = self;
        view.currentApartmentUser = [apartmentRoom.aryApartmentUser objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:view animated:YES];
    } else if (indexPath.section == 3) {
        ApartmentWaterListViewController *viewController = [[ApartmentWaterListViewController alloc] init];
        viewController.delegate = self;
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (indexPath.section == 4) {
        ApartmentElecListViewController *viewController = [[ApartmentElecListViewController alloc] init];
        viewController.delegate = self;
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (indexPath.section == 5) {
        ApartmentGasListViewController *viewController = [[ApartmentGasListViewController alloc] init];
        viewController.delegate = self;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - BaseAction
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickFirstRightItem
{
    [self onClickResign];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    if (![CustomStringUtils isBlankString:apartmentRoom.homeName]) {
        [paramDic setObject:apartmentRoom.homeName forKey:@"homeName"];
    } else {
        [self showAlertViewWithMsg:@"请输入房间名称"];
        return;
    }
    if (![CustomStringUtils isBlankString:apartmentRoom.status]) {
        [paramDic setObject:apartmentRoom.status forKey:@"status"];
    } else {
        [self showAlertViewWithMsg:@"请选择租住状态"];
        return;
    }
    if (apartmentRoom.monthlyRent > 0) {
        [paramDic setObject:[NSString stringWithFormat:@"%ld", (long)apartmentRoom.monthlyRent] forKey:@"monthlyRent"];
    } else {
        [self showAlertViewWithMsg:@"请输入月租金"];
        return;
    }
    if (apartmentRoom.deposit > 0) {
        [paramDic setObject:[NSString stringWithFormat:@"%ld", (long)apartmentRoom.deposit] forKey:@"deposit"];
    } else {
        [self showAlertViewWithMsg:@"请输入押金"];
        return;
    }
    if ([apartmentRoom.expDate integerValue] > 0) {
        [paramDic setObject:[CustomTimeUtils changeIntervalToDate:self.apartmentRoom.expDate] forKey:@"expDate"];
    } else {
        [self showAlertViewWithMsg:@"请选择租蘋时间"];
        return;
    }
    
    apartmentRoom.deliverCategory = @"M_2_1";
    if (![CustomStringUtils isBlankString:apartmentRoom.deliverCategory]) {
        [paramDic setObject:apartmentRoom.deliverCategory forKey:@"deliverCategory"];
    } else {
        [self showAlertViewWithMsg:@"请选择交租方式"];
        return;
    }
    if (apartmentRoom.tanantNumber > 0) {
        [paramDic setObject:[NSString stringWithFormat:@"%ld", apartmentRoom.tanantNumber] forKey:@"tanantNumber"];
    } else {
        [self showAlertViewWithMsg:@"请输入居住人数"];
        return;
    }
    if (![CustomStringUtils isBlankString:apartmentRoom.rentCategory]) {
        [paramDic setObject:apartmentRoom.rentCategory forKey:@"rentCategory"];
    } else {
        [self showAlertViewWithMsg:@"请输入出租类型"];
        return;
    }
    if (![CustomStringUtils isBlankString:apartmentRoom.mark]) {
        [paramDic setObject:apartmentRoom.mark forKey:@"mark"];
    } else {
        [self showAlertViewWithMsg:@"请输入备注"];
        return;
    }
    
    NSString *tmpUserIds = @"";
    for (ApartmentUser *user in apartmentRoom.aryApartmentUser) {
        NSString *tmpString = [user.apartmentUserId stringValue];
        if (![[apartmentRoom.aryApartmentUser lastObject] isEqual:user]) {
            tmpString = [tmpString stringByAppendingString:@","];
        }
        tmpUserIds = [tmpUserIds stringByAppendingString:tmpString];
    }
    
    if (![CustomStringUtils isBlankString:tmpUserIds]) {
        [paramDic setObject:tmpUserIds forKey:@"userIds"];
    }
    
    if (apartmentRoom.water.waterId) {
        [paramDic setObject:apartmentRoom.water.waterId forKey:@"watersideId"];
    }
    
    if (apartmentRoom.gas.gasId) {
        [paramDic setObject:apartmentRoom.gas.gasId forKey:@"gasmeterId"];
    }
    
    if (apartmentRoom.elec.elecId) {
        [paramDic setObject:apartmentRoom.elec.elecId forKey:@"ammeterId"];
    }
    
    if ([apartmentRoom.roomId integerValue] > 0) {
        //更新
        [paramDic setObject:apartmentRoom.roomId forKey:@"id"];
        
        [CustomRequestUtils createNewPostRequest:@"/apartment/home/update.json" params:paramDic success:^(id responseObject) {
            NSDictionary *jsonDic = responseObject;
            if (jsonDic && [[jsonDic objectForKey:@"status"] isEqualToString:RequestSuccessful]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
        
    } else {
        //添加
        if ([self.apartmentId integerValue] > 0) {
            [paramDic setObject:(NSString *)self.apartmentId forKey:@"apartmentId"];
        }
        
        [CustomRequestUtils createNewPostRequest:@"/apartment/home/add.json" params:paramDic success:^(id responseObject) {
            NSDictionary *jsonDic = responseObject;
            if (jsonDic && [[jsonDic objectForKey:@"status"] isEqualToString:RequestSuccessful]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    }
}

- (void)onClickSecondRightItem
{
    UIActionSheet *actioSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"房主信息", @"支出列表", @"设备列表", @"续交房租", nil];
    actioSheet.tag = 118;
    [actioSheet showInView:self.view];
}

- (void)showAlertViewWithMsg:(NSString *)msg
{
    if (![CustomStringUtils isBlankString:msg]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alertView show];
    }
}

#pragma mark - NormalInputTextFieldCellDelegate
- (void)NITFC_addRoomWithRoom:(ApartmentRoom *)room
{
    apartmentRoom = room;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 111) {
        if (buttonIndex == 0 || buttonIndex == 1 || buttonIndex == 2) {
            apartmentRoom.status = [aryStatusItem objectAtIndex:buttonIndex];
            [addRoomTableView reloadData];
        }
     } else if (actionSheet.tag == 112) {
         if (buttonIndex == 0 || buttonIndex == 1 || buttonIndex == 2 || buttonIndex == 3) {
             apartmentRoom.tanantNumber = buttonIndex + 1;
             [addRoomTableView reloadData];
         }
    } else if (actionSheet.tag == 113) {
        if (buttonIndex == 0 || buttonIndex == 1) {
            apartmentRoom.rentCategory = [aryRentItem objectAtIndex:buttonIndex];
            [addRoomTableView reloadData];
        }
    } else if (actionSheet.tag == 118) {
        if (buttonIndex == 0) {
            //房主信息
            HouseHolderInfoViewController *view = [[HouseHolderInfoViewController alloc] init];
            view.apartmentRoom = self.apartmentRoom;
            [self.navigationController pushViewController:view animated:YES];
        } else if (buttonIndex == 1) {
            ExpendViewController *view = [[ExpendViewController alloc] init];
            [self.navigationController pushViewController:view animated:YES];
        } else if (buttonIndex == 2) {
            DeviceListViewController *view = [[DeviceListViewController alloc] init];
            view.apartmentRoom = self.apartmentRoom;
            [self.navigationController pushViewController:view animated:YES];
        } else if (buttonIndex == 3){
            HouseHolderListViewController *view = [[HouseHolderListViewController alloc] init];
            [self.navigationController pushViewController:view animated:YES];
        }
    }
}


#pragma mark - UIGestureRecognize delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view.superview class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - datePickerViewFunction
- (void)initDatePickerView
{
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 216, MainScreenWidth, 216)];
    datePicker.backgroundColor = [UIColor whiteColor];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(onClickChangePickerViewValue:) forControlEvents:UIControlEventValueChanged];
    [datePicker setDate:[NSDate date]];
    [self.view addSubview:datePicker];
    
    [self hideDatePickerView];
}

- (void)onClickChangePickerViewValue:(UIDatePicker *)picker
{
    NSString *dateString = [[DateFormatUtils sharedInstance].thirdDateFormatter stringFromDate:picker.date];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    [self sendMsgToCellTextFieldWithIndexPath:indexPath dateString:dateString];
}

- (void)sendMsgToCellTextFieldWithIndexPath:(NSIndexPath *)indexPath dateString:(NSString *)dateString
{
    NormalInputTextFieldCell *cell = (NormalInputTextFieldCell *)[addRoomTableView cellForRowAtIndexPath:indexPath];
    for (UIView *subView in cell.subviews) {
        UIView *wrapperView = (UIView *)[subView viewWithTag:10086];
        for (UIView *tmpSubView in wrapperView.subviews) {
            if ([tmpSubView isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)tmpSubView;
                textField.text = dateString;
                self.apartmentRoom.expDate = dateString;
            }
        }
    }
}

- (void)showDatePickerView
{
    [UIView animateWithDuration:.5 animations:^{
        [datePicker setFrame:CGRectMake(0, MainScreenHeight - 216, MainScreenWidth, 216)];
        [self.view bringSubviewToFront:datePicker];
        datePickerShowed = YES;
        [addRoomTableView setFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 216 - 64)];
    }];
}

- (void)hideDatePickerView
{
    [UIView animateWithDuration:.5 animations:^{
        [datePicker setFrame:CGRectMake(0, MainScreenHeight, MainScreenWidth, 216)];
        datePickerShowed = NO;
        [addRoomTableView setFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    }];
}

#pragma mark - AULD_passApartmentUser
- (void)AULD_passApartmentUser:(NSMutableArray *)aryApartmentUser
{
    for (ApartmentUser *user in aryApartmentUser) {
        if (![apartmentRoom.aryApartmentUser containsObject:user]) {
            [apartmentRoom.aryApartmentUser addObject:user];
        }
    }
    
    [addRoomTableView reloadData];
}

#pragma mark - AddApartmentUserDelegate
- (void)AAUD_passApartmentUser:(ApartmentUser *)apartmentUser
{
    for (int i = 0; i < [apartmentRoom.aryApartmentUser count]; i++) {
        ApartmentUser *user = [apartmentRoom.aryApartmentUser objectAtIndex:i];
        if ([user.apartmentUserId isEqual:apartmentUser.apartmentUserId]) {
            [apartmentRoom.aryApartmentUser replaceObjectAtIndex:i withObject:apartmentUser];
        }
    }
    
    [addRoomTableView reloadData];
}

#pragma mark - ApartmentWaterList
- (void)AWLD_passApartmentWater:(Water *)water
{
    apartmentRoom.water = water;
    
    [addRoomTableView reloadData];
}

#pragma mark - ApartmentElecList
- (void)AELD_passApartmentElec:(Elec *)elec
{
    apartmentRoom.elec = elec;
    
    [addRoomTableView reloadData];
}

#pragma mark - ApartmentGasList
- (void)AGLD_passApartmentGas:(Gas *)gas
{
    apartmentRoom.gas = gas;
    
    [addRoomTableView reloadData];
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
