//
//  HouseHolderInfoViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/2/21.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "HouseHolderInfoViewController.h"
#import "NormalInputTextFieldCell.h"
#import "DateFormatUtils.h"

@interface HouseHolderInfoViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
    NSArray *aryTitleData;
    NSArray *aryPlaceHolderData;
    
    UITableView *addHourseHolderTableView;
    
    BOOL datePickerShowed;
    
    CGFloat keyboardHeight;
    CGFloat keyboardOriginY;
    
    UIDatePicker *datePicker;
    
    HomeOwner *currentOwner;
}

@end

@implementation HouseHolderInfoViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    aryTitleData = @[@"房主姓名", @"联系电话", @"地址信息" , @"合同开始", @"合同结束", @"房租金额", @"押金金额"];
    aryPlaceHolderData = @[@"请输入房主姓名", @"请输入联系电话", @"请输入地址信息", @"请选择开始时间", @"请选择结束时间", @"请输入房租金额", @"请输入押金金额"];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"房主信息" segmentArray:nil];
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    

    [self adaptSecondRightItemWithTitle:@"添加"];
    
    if (!currentOwner) {
        currentOwner = [[HomeOwner alloc] init];
    }
   
    [self initDatePickerView];
    
    [self createTableView];
    
    [self addTableViewGesture];
    
    [self addKeyboardObserver];
    
    [self loadHourseHolderInfo];
    
}

- (void)loadHourseHolderInfo
{
    NSString *requestUrl = [NSString stringWithFormat:@"/apartment/home/homeownersInfo.json?homeId=%@", self.apartmentRoom.roomId];
    
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
    if ([jsonDic objectForKey:@"data"]) {
        NSDictionary *tmpDic = [jsonDic objectForKey:@"data"];
        HomeOwner *owner = [[HomeOwner alloc] initWithDictionary:tmpDic];
        currentOwner = owner;
        
        [addHourseHolderTableView reloadData];
    }
}

- (void)createTableView
{
    addHourseHolderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    addHourseHolderTableView.delegate = self;
    addHourseHolderTableView.dataSource = self;
    addHourseHolderTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 20)];
    addHourseHolderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:addHourseHolderTableView];
}

- (void)addTableViewGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickResign)];
    tap.delegate = self;
    [addHourseHolderTableView addGestureRecognizer:tap];
}

- (void)onClickResign
{
    int i = 0 ;
    while (i < 1) {
        
        int maxNum = i == 0 ? 6 : 0;
        
        for (int j = 0 ; j < maxNum ; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            NormalInputTextFieldCell *cell = (NormalInputTextFieldCell *)[addHourseHolderTableView cellForRowAtIndexPath:indexPath];
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
        
        [addHourseHolderTableView setFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 - keyboardHeight)];
    } else {
        [addHourseHolderTableView setFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NormalInputTextFieldCell *cell = (NormalInputTextFieldCell *)[addHourseHolderTableView cellForRowAtIndexPath:indexPath];
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
        [addHourseHolderTableView setFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 216 - 64)];
    }];
}

- (void)hideDatePickerView
{
    [UIView animateWithDuration:.5 animations:^{
        [datePicker setFrame:CGRectMake(0, MainScreenHeight, MainScreenWidth, 216)];
        datePickerShowed = NO;
        [addHourseHolderTableView setFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    }];
}

#pragma mark - tableView
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
    
    if (indexPath.row == 3 || indexPath.row == 4) {
        cell.isTextFiledEnable = NO;
    } else {
        cell.isTextFiledEnable = YES;
    }
    
    cell.title = [aryTitleData objectAtIndex:indexPath.row];
    cell.placeHolderTitle = [aryPlaceHolderData objectAtIndex:indexPath.row];
    
    cell.cellType = AddHourseHolderLogic;
    cell.backgroundColor = [UIColor clearColor];
    cell.owner = currentOwner;
    
    [cell loadAddHourseHolderWithIndexPath:indexPath];
    
    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self onClickResign];
    
    if (indexPath.section == 3) {
        [self showDatePickerView];
    } else if (indexPath.section == 4) {
        [self showDatePickerView];
    }
}


#pragma mark -
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickSecondRightItem
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:self.apartmentRoom.roomId forKey:@"homeId"];
    [paramDic setObject:currentOwner.name forKey:@"name"];
    [paramDic setObject:currentOwner.phone forKey:@"phone"];
    [paramDic setObject:currentOwner.address forKey:@"address"];
    [paramDic setObject:currentOwner.contractStart forKey:@"contractStart"];
    [paramDic setObject:currentOwner.contractMaturity forKey:@"contractMaturity"];
    [paramDic setObject:[NSString stringWithFormat:@"%ld", (long)currentOwner.amount] forKey:@"amount"];
    [paramDic setObject:[NSString stringWithFormat:@"%ld", (long)currentOwner.deposit] forKey:@"deposit"];
    
    [CustomRequestUtils createNewPostRequest:@"/apartment/home/seterHomeOwnersInfo.json" params:paramDic success:^(id responseObject) {
        NSDictionary *jsonDic = responseObject;
        if (jsonDic) {
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
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
