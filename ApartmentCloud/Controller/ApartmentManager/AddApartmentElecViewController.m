//
//  AddApartmentElecViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/25.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "AddApartmentElecViewController.h"
#import "NormalInputTextFieldCell.h"

@interface AddApartmentElecViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *aryTitleData;
    NSArray *aryPlaceHolderData;
    
    UITableView *addElecTableView;
}

@end

@implementation AddApartmentElecViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    aryTitleData = @[@"电表名", @"电表度数",];
    aryPlaceHolderData = @[@"请输入电表名", @"请输入电表度数"];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"添加住户" segmentArray:nil];
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    [self adaptSecondRightItemWithTitle:@"确认添加"];
    
    if (!self.currentElec) {
        self.currentElec = [[Elec alloc] init];
    }
    
    [self createTableView];
}

- (void)createTableView
{
    addElecTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    addElecTableView.delegate = self;
    addElecTableView.dataSource = self;
    addElecTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    addElecTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:addElecTableView];
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
    
    cell.title = [aryTitleData objectAtIndex:indexPath.row];
    cell.placeHolderTitle = [aryPlaceHolderData objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (void)onClickResign
{
    int i = 0 ;
    while (i < 1) {
        
        int maxNum = 2;
        
        for (int j = 0 ; j < maxNum ; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            NormalInputTextFieldCell *cell = (NormalInputTextFieldCell *)[addElecTableView cellForRowAtIndexPath:indexPath];
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
    [self setWaterByAddWaterIndexPath:[NSIndexPath indexPathForRow:0 inSection:0 ]];
    [self setWaterByAddWaterIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:self.currentElec.mark forKey:@"mark"];
    [paramDic setObject:self.currentElec.currentNumber forKey:@"currentNumber"];
    [paramDic setObject:@"COMMON" forKey:@"category"];
    
    [CustomRequestUtils createNewPostRequest:@"/device/ammeter/add.json" params:paramDic success:^(id responseObject) {
        NSDictionary *jsonDic = responseObject;
        
        if (jsonDic) {
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)setWaterByAddWaterIndexPath:(NSIndexPath *)indexPath
{
    NormalInputTextFieldCell *cell = [addElecTableView cellForRowAtIndexPath:indexPath];
    
    UIView *tmpView = [cell.contentView viewWithTag:10086];
    for (UIView *tmpSubView in tmpView.subviews) {
        if ([tmpSubView isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)tmpSubView;
            if (indexPath.row == 0) {
                self.currentElec.mark = textField.text;
            } else {
                self.currentElec.currentNumber = textField.text;
            }
        }
    }
}

@end
