//
//  AddDeviceInfoViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/2/21.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "AddDeviceInfoViewController.h"
#import "NormalInputTextFieldCell.h"
#import "DateFormatUtils.h"

@interface AddDeviceInfoViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
{
    UITableView *deviceTableView;
    
    NSArray *aryTitleData;
    NSArray *aryPlaceHolderData;
    
    UIDatePicker *datePicker;
    BOOL datePickerShowed;
    
    CGFloat keyboardHeight;
    CGFloat keyboardOriginY;
}

@end

@implementation AddDeviceInfoViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    aryTitleData = @[@"设备名称", @"设备型号", @"设备归属", @"设备金额", @"购买时间", @"备注信息"];
    aryPlaceHolderData = @[@"请输入设备名称", @"请输入设备型号", @"请选择设备归属", @"请输入设备金额", @"请选择购买时间", @"请输入备注信息"];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"添加设备" segmentArray:nil];
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    
    if (self.currentDeviceInfo) {
        [self adaptSecondRightItemWithTitle:@"更新"];
    } else {
        [self adaptSecondRightItemWithTitle:@"添加"];
    }
    
    if (!self.currentDeviceInfo) {
        self.currentDeviceInfo = [[DeviceInfo alloc] init];
    }
    
    [self createTableView];
    
    [self initDatePickerView];
    
    [self addKeyboardObserver];
}

- (void)createTableView
{
    deviceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    deviceTableView.delegate = self;
    deviceTableView.dataSource = self;
    deviceTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    deviceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:deviceTableView];
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
        
        [deviceTableView setFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 - keyboardHeight)];
    } else {
        [deviceTableView setFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
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
    
    if (indexPath.row == 2 || indexPath.row == 4) {
        cell.isTextFiledEnable = NO;
    } else {
        cell.isTextFiledEnable = YES;
    }

    cell.title = [aryTitleData objectAtIndex:indexPath.row];
    cell.placeHolderTitle = [aryPlaceHolderData objectAtIndex:indexPath.row];
    cell.deviceInfo = self.currentDeviceInfo;
    cell.cellType = AddDeviceInfoLogic;
    
    [cell loadAddDeviceWithIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self onClickResign];
    
    if (indexPath.row == 2) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"房东归属",@"非房东归属", nil];
        [actionSheet showInView:self.view];
        
    } else if (indexPath.row == 4) {
        [self showDatePickerView];
    }
}

- (void)onClickResign
{
    int i = 0 ;
    while (i < 1) {
        
        int maxNum = 6;
        
        for (int j = 0 ; j < maxNum ; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            NormalInputTextFieldCell *cell = (NormalInputTextFieldCell *)[deviceTableView cellForRowAtIndexPath:indexPath];
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
    NormalInputTextFieldCell *cell = (NormalInputTextFieldCell *)[deviceTableView cellForRowAtIndexPath:indexPath];
    for (UIView *subView in cell.subviews) {
        UIView *wrapperView = (UIView *)[subView viewWithTag:10086];
        for (UIView *tmpSubView in wrapperView.subviews) {
            if ([tmpSubView isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)tmpSubView;
                textField.text = dateString;
                self.currentDeviceInfo.payDate = dateString;
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
        [deviceTableView setFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 216 - 64)];
    }];
}

- (void)hideDatePickerView
{
    [UIView animateWithDuration:.5 animations:^{
        [datePicker setFrame:CGRectMake(0, MainScreenHeight, MainScreenWidth, 216)];
        datePickerShowed = NO;
        [deviceTableView setFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
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
    if ([self.homeId integerValue] > 0) {
        [paramDic setObject:self.homeId forKey:@"homeId"];
    }
    if (![CustomStringUtils isBlankString:self.currentDeviceInfo.name]) {
        [paramDic setObject:self.currentDeviceInfo.name forKey:@"name"];
    }
    if (![CustomStringUtils isBlankString:self.currentDeviceInfo.model]) {
        [paramDic setObject:self.currentDeviceInfo.model forKey:@"model"];
    }
    if (self.currentDeviceInfo.amount > 0) {
        [paramDic setObject:[NSString stringWithFormat:@"%ld", (long)self.currentDeviceInfo.amount] forKey:@"amount"];
    }
    
    [paramDic setObject:self.currentDeviceInfo.payDate forKey:@"payDate"];
    
    if (self.currentDeviceInfo.isHomeOwner) {
        [paramDic setObject:@"Y" forKey:@"isHomeowners"];
    } else {
        [paramDic setObject:@"N" forKey:@"isHomeowners"];
    }
    
    [paramDic setObject:self.currentDeviceInfo.mark forKey:@"mark"];
    
    if (self.currentDeviceInfo.deviceId) {
        [paramDic setObject:self.currentDeviceInfo.deviceId forKey:@"id"];
        
        [CustomRequestUtils createNewPostRequest:@"/device/update.json" params:paramDic success:^(id responseObject) {
            NSDictionary *jsonDic = responseObject;
            
            if (jsonDic) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    } else {
        [CustomRequestUtils createNewPostRequest:@"/device/add.json" params:paramDic success:^(id responseObject) {
            NSDictionary *jsonDic = responseObject;
            
            if (jsonDic) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    }
}

#pragma mark - UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.currentDeviceInfo.isHomeOwner = YES;
    } else if (buttonIndex == 1){
        self.currentDeviceInfo.isHomeOwner = NO;
    }
    
    [deviceTableView reloadData];
}

@end
