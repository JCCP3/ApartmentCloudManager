//
//  AddDecorateViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/10.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "AddDecorateViewController.h"
#import "NormalInputTextFieldCell.h"
#import "DateFormatUtils.h"
#import "ApartmentListViewController.h"
#import "ApartmentRoomListViewController.h"

@interface AddDecorateViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, ApartmentListViewControllerDelegate, ApartmentRoomListDelegate>
{
    UITableView *addDecorateTableView;
    NSArray *aryTitleData;
    NSArray *aryPlaceHolderData;
    
    UIDatePicker *datePicker;
    BOOL datePickerShowed;
    
    NSMutableArray *apartmentRoomArray;
    Apartment *selectedApartment;
    ApartmentRoom *selectedApartmentRoom;
}

@end

@implementation AddDecorateViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [CustomColorUtils colorWithHexString:@"#f7f7f7"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    apartmentRoomArray = [[NSMutableArray alloc] init];
    
    if (self.isAddDecorate) {
        aryTitleData = @[@"公寓名称", @"装修房间", @"装修日期"];
        aryPlaceHolderData = @[@"请选择您的公寓名称", @"请选择您要装修的房间名称", @"请选择您装修的开始日期"];
    } else {
        aryTitleData = @[@"公寓名称", @"维修房间", @"维修日期"];
        aryPlaceHolderData = @[@"请选择您的公寓名称", @"请选择您要维修的房间名称", @"请选择您维修的开始日期"];
    }
    
    NSString *title = self.isAddDecorate ? @"添加装修事件" : @"添加维修事件";
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:title segmentArray:nil];
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    
    [self createTableView];
    
    [self initDatePickerView];
    [self addTableViewGesture];
}

- (void)addTableViewGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickResign)];
    tap.delegate = self;
    [addDecorateTableView addGestureRecognizer:tap];
}

- (void)createTableView
{
    addDecorateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    addDecorateTableView.delegate = self;
    addDecorateTableView.dataSource = self;
    addDecorateTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    addDecorateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:addDecorateTableView];
}

- (void)onClickResign
{
    int i = 0 ;
    while (i < 1) {
        
        int maxNum = 3;
        
        for (int j = 0 ; j < maxNum ; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            NormalInputTextFieldCell *cell = (NormalInputTextFieldCell *)[addDecorateTableView cellForRowAtIndexPath:indexPath];
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
    
    [self hideDatePickerView];
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
    
    cell.isTextFiledEnable = NO;
    
    cell.title = [aryTitleData objectAtIndex:indexPath.row];
    cell.placeHolderTitle = [aryPlaceHolderData objectAtIndex:indexPath.row];

    NSString *descText;
    if (indexPath.row == 0) {
        descText = selectedApartment.apartmentName;
    } else if (indexPath.row == 1) {
        descText = selectedApartmentRoom.homeName;
    } else {
        descText = @"";
    }
    
    cell.descTextField.text = descText;
    
    [cell loadAddDecorateCellWithIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self onClickResign];
    
    if (indexPath.row == 0) {
        //选择公寓
        ApartmentListViewController *view = [[ApartmentListViewController alloc] init];
        view.delegate = self;
        [self.navigationController pushViewController:view animated:YES];
        
    } else if (indexPath.row == 1) {
        
        if (selectedApartment && [apartmentRoomArray count] > 0) {
            ApartmentRoomListViewController *viewController = [[ApartmentRoomListViewController alloc] init];
            viewController.delegate = self;
            viewController.aryApartmentRoom = apartmentRoomArray;
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            //不存在
        }
        
    } else if (indexPath.row == 2) {
        [self showDatePickerView];
    }
}

#pragma mark - BaseAction
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [self sendMsgToCellTextFieldWithIndexPath:indexPath dateString:dateString];
}

- (void)sendMsgToCellTextFieldWithIndexPath:(NSIndexPath *)indexPath dateString:(NSString *)dateString
{
    NormalInputTextFieldCell *cell = (NormalInputTextFieldCell *)[addDecorateTableView cellForRowAtIndexPath:indexPath];
    for (UIView *subView in cell.subviews) {
        UIView *wrapperView = (UIView *)[subView viewWithTag:10086];
        for (UIView *tmpSubView in wrapperView.subviews) {
            if ([tmpSubView isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)tmpSubView;
                textField.text = dateString;
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
        [addDecorateTableView setFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 216 - 64)];
    }];
}

- (void)hideDatePickerView
{
    [UIView animateWithDuration:.5 animations:^{
        [datePicker setFrame:CGRectMake(0, MainScreenHeight, MainScreenWidth, 216)];
        datePickerShowed = NO;
        [addDecorateTableView setFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
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

#pragma mark - ApartmentListViewControllerDelegate
- (void)ALVCD_passApartment:(Apartment *)apartment withRoomArray:(NSMutableArray *)aryRoom
{
    selectedApartment = apartment;
    apartmentRoomArray = aryRoom;

    [addDecorateTableView reloadData];
}

#pragma mark - ApartmentRoomListViewControllerDelegate
- (void)ARLD_passApartmentRoom:(ApartmentRoom *)room
{
    selectedApartmentRoom = room;
    [addDecorateTableView reloadData];
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
