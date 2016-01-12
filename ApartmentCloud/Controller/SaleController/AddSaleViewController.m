//
//  AddSaleViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/12.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "AddSaleViewController.h"
#import "NormalInputTextFieldCell.h"
#import "NormalTextViewCell.h"

@interface AddSaleViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *aryTitleData;
    NSArray *aryPlaceHolderData;
    
    UITableView *addSaleTableView;
    
    CGFloat keyboardOriginY;
    CGFloat keyboardHeight;
}


@end

@implementation AddSaleViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [CustomColorUtils colorWithHexString:@"#f7f7f7"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    aryTitleData = @[@"公寓名称", @"楼层选择", @"房间名称", @"日期选择", @"支出金额", @"费用描述"];
    aryPlaceHolderData = @[@"请选择您的公寓名称", @"请选择您的支出楼层", @"请输入您的支出房间名称", @"请选择您的支出日期", @"请选择您的支出金额", @"你可以添加此笔支出的具体描述"];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"添加支出" segmentArray:nil];
    
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    
    [self createTableView];
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

- (void)createTableView
{
    addSaleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    addSaleTableView.delegate = self;
    addSaleTableView.dataSource = self;
    addSaleTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    addSaleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:addSaleTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIKeyboardNotification
- (void)changeKeyboardFrame:(NSNotification *)notification
{
    keyboardOriginY = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    if (keyboardOriginY != MainScreenHeight) {
        [addSaleTableView setFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - keyboardHeight - 64)];
    } else {
        [addSaleTableView setFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    }
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
    if (indexPath.row < 5) {
        static NSString *cellIdentifier = @"NormalInputTextFieldCell";
        
        NormalInputTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NormalInputTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.row == 2 || indexPath.row == 4) {
            cell.isTextFiledEnable = YES;
        } else {
            cell.isTextFiledEnable = NO;
        }
        
        cell.title = [aryTitleData objectAtIndex:indexPath.row];
        cell.placeHolderTitle = [aryPlaceHolderData objectAtIndex:indexPath.row];
        
        [cell loadNormalInputTextFieldCellData];
        
        return cell;
    } else {
        static NSString *cellIdentifier = @"NormalTextViewCell";
        
        NormalTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NormalTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        cell.title = [aryTitleData objectAtIndex:indexPath.row];
        cell.placeHolderTitle = [aryPlaceHolderData objectAtIndex:indexPath.row];
        
        [cell loadNormalTextViewCell];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 5) {
        return 50;
    } else {
        return 110;
    }
}

#pragma mark - BaseAction
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
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
