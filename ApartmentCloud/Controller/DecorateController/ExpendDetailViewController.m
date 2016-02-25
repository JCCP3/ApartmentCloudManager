//
//  ExpendDetailViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/2/20.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "ExpendDetailViewController.h"
#import "NormalInputTextFieldCell.h"
#import "DateFormatUtils.h"
#import "CustomTimeUtils.h"
#import "ExpendChooseRoomViewController.h"

@interface ExpendDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate, ExpendChooseRoomViewControllerDelegate, NormalInputTextFieldCellDelegate>
{
    UITableView *expendDetailTableView;
    
    NSMutableArray *aryData;
    
    NSArray *aryPlaceHolder;
    NSArray *aryTitleData;
    
    UIView *datePickerView;
    UIButton *completionBtn;
    UIDatePicker *datePicker;
    BOOL datePickerShowed;
}

@end

@implementation ExpendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"支出信息" segmentArray:nil];
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    
    NSString *rightString;
    if (self.expendInfo) {
        rightString = @"更新";
    } else {
        self.expendInfo = [[ExpendInfo alloc] init];
        rightString = @"添加";
    }
    [self adaptSecondRightItemWithTitle:rightString];
    
    aryData = [[NSMutableArray alloc] init];
    aryTitleData = @[@"选择房间", @"事件类型", @"事件状态", @"花费金额", @"选择时间", @"备注信息"];
    aryPlaceHolder = @[@"请选择房间", @"请选择事件类型", @"请选择事件状态", @"请输入花费金额", @"请选择时间", @"请输入备注信息"];
    
    [self createTableView];
    
    [self addTableViewGesture];
    
    [self initDatePickerView];
}

- (void)createTableView
{
    expendDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    expendDetailTableView.delegate = self;
    expendDetailTableView.dataSource = self;
    expendDetailTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    expendDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:expendDetailTableView];
}

- (void)addTableViewGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickResign)];
    tap.delegate = self;
    [expendDetailTableView addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickResign
{
    int i = 0 ;
    while (i < 1) {
        
        int maxNum = 6;
        
        for (int j = 0 ; j < maxNum ; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            NormalInputTextFieldCell *cell = (NormalInputTextFieldCell *)[expendDetailTableView cellForRowAtIndexPath:indexPath];
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
    
    if (datePickerShowed) {
        [self hideDatePickerView];
    }
}


#pragma mark - 
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
    
    if (indexPath.row == 3 || indexPath.row == 5) {
        cell.isTextFiledEnable = YES;
    } else {
        cell.isTextFiledEnable = NO;
    }
    
    if (indexPath.row == 3) {
        cell.descTextField.keyboardType = UIKeyboardTypePhonePad;
    }
    
    cell.delegate = self;
    
    cell.title = [aryTitleData objectAtIndex:indexPath.row];
    cell.cellType = AddExpendLogic;
    cell.expendInfo = self.expendInfo;
    cell.placeHolderTitle = [aryPlaceHolder objectAtIndex:indexPath.row];
    
    [cell loadAddExpendCellWithIndexPath:indexPath];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self onClickResign];
    
    if (indexPath.row == 0) {
        
        ExpendChooseRoomViewController *view = [[ExpendChooseRoomViewController alloc] init];
        view.delegate = self;
        [self.navigationController pushViewController:view animated:YES];
        
    } else if (indexPath.row == 1) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"维修", @"装修", nil];
        actionSheet.tag = 10086;
        [actionSheet showInView:self.view];
        
    } else if (indexPath.row == 2) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"进行中", @"已完成", nil];
        actionSheet.tag = 10010;
        [actionSheet showInView:self.view];
        
    } else if (indexPath.row == 4) {
        [self showDatePickerView];
    }
}


#pragma mark - datePickerViewFunction
- (void)initDatePickerView
{
    datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight, MainScreenWidth, 216+44)];
    datePickerView.backgroundColor = [UIColor greenColor];
    completionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 44)];
    [completionBtn addTarget:self action:@selector(onClickChooseDate) forControlEvents:UIControlEventTouchUpInside];
    [completionBtn setTitle:@"完成" forState:UIControlStateNormal];
    [datePickerView addSubview:completionBtn];
    [self.view addSubview:datePickerView];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, MainScreenWidth, 216)];
    datePicker.backgroundColor = [UIColor whiteColor];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(onClickChangePickerViewValue:) forControlEvents:UIControlEventValueChanged];
    [datePicker setDate:[NSDate date]];
    [datePickerView addSubview:datePicker];
    
    [self hideDatePickerView];
}

- (void)onClickChooseDate
{
    NSString *dateString = [[DateFormatUtils sharedInstance].thirdDateFormatter stringFromDate:datePicker.date];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    [self sendMsgToCellTextFieldWithIndexPath:indexPath dateString:dateString];
    
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
    NormalInputTextFieldCell *cell = (NormalInputTextFieldCell *)[expendDetailTableView cellForRowAtIndexPath:indexPath];
    for (UIView *subView in cell.subviews) {
        UIView *wrapperView = (UIView *)[subView viewWithTag:10086];
        for (UIView *tmpSubView in wrapperView.subviews) {
            if ([tmpSubView isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)tmpSubView;
                textField.text = dateString;
                
                NSString *interval = [CustomTimeUtils changeDateToInterval:dateString];
                self.expendInfo.createTime = interval;
            }
        }
    }
}

- (void)showDatePickerView
{
    [UIView animateWithDuration:.5 animations:^{
        [datePickerView setFrame:CGRectMake(0, MainScreenHeight - 216 - 44, MainScreenWidth, 216 + 44)];
        [self.view bringSubviewToFront:datePicker];
        datePickerShowed = YES;
        [expendDetailTableView setFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 216 - 64)];
    }];
}

- (void)hideDatePickerView
{
    [UIView animateWithDuration:.5 animations:^{
        [datePickerView setFrame:CGRectMake(0, MainScreenHeight, MainScreenWidth, 216 + 44)];
        datePickerShowed = NO;
        [expendDetailTableView setFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    }];
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
    if (self.expendInfo.expendInfoId) {
        [paramDic setObject:self.expendInfo.expendInfoId forKey:@"id"];
    }
    
    if (self.expendInfo.homeId) {
        [paramDic setObject:[NSString stringWithFormat:@"%ld", (long)self.expendInfo.homeId] forKey:@"homeId"];
    }
    
    [paramDic setObject:self.expendInfo.mark forKey:@"mark"];
    [paramDic setObject:[NSString stringWithFormat:@"%ld", (long)self.expendInfo.amount] forKey:@"amount"];
    [paramDic setObject:self.expendInfo.status forKey:@"status"];
    [paramDic setObject:self.expendInfo.category forKey:@"category"];
    [paramDic setObject:[CustomTimeUtils changeIntervalToDate:self.expendInfo.createTime] forKey:@"successDate"];
    
    if (self.expendInfo.expendInfoId) {
        [CustomRequestUtils createNewPostRequest:@"/apartment/home/maintain/update.json" params:paramDic success:^(id responseObject) {
            NSDictionary *jsonDic = responseObject;
            if (jsonDic && [[jsonDic objectForKey:@"status"] isEqualToString:RequestSuccessful]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    } else {
        [CustomRequestUtils createNewPostRequest:@"/apartment/home/maintain/add.json" params:paramDic success:^(id responseObject) {
            NSDictionary *jsonDic = responseObject;
            if (jsonDic && [[jsonDic objectForKey:@"status"] isEqualToString:RequestSuccessful]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 10086) {
        
        if (buttonIndex == 0) {
            self.expendInfo.category = @"MAINTAIN";
        } else if (buttonIndex == 1) {
            self.expendInfo.category = @"DECO";
        }
        
        [expendDetailTableView reloadData];
        
    } else if (actionSheet.tag == 10010) {
        if (buttonIndex == 0) {
            self.expendInfo.status = @"ING";
        } else if (buttonIndex == 1) {
            self.expendInfo.status = @"COMPLETE";
        }
        
        [expendDetailTableView reloadData];
    }
}

#pragma mark -
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view.superview class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - ExpendChooseRoomDelegate
- (void)ECRVD_passRoomInfo:(ApartmentRoom *)apartmentRoom
{
    self.expendInfo.homeId = [apartmentRoom.apartmentId integerValue];
    self.expendInfo.homeName = apartmentRoom.homeName;
    
    [expendDetailTableView reloadData];
}

- (void)NITFC_addExpend:(ExpendInfo *)expendInfo
{
    self.expendInfo = expendInfo;
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
