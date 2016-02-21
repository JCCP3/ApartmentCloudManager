//
//  BaseSettingViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/2/20.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "BaseSettingViewController.h"
#import "LeftSideViewController.h"
#import "NormalInputTextFieldCell.h"

@interface BaseSettingViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *settingTableView;
    
    NSArray *aryTitleData;
    NSArray *aryPlaceHolderData;
}

@end

@implementation BaseSettingViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"水电气基础设定" segmentArray:nil];
    
    [self adaptLeftItemWithNormalImage:ImageNamed(@"nav_menu.png") highlightedImage:ImageNamed(@"nav_menu.png")];
    [self adaptSecondRightItemWithTitle:@"保存"];
    
    aryTitleData = @[@"电费", @"水费", @"燃气"];
    aryPlaceHolderData = @[@"请输入电费", @"请输入水费", @"请输入燃气费用"];
    
    [self createTableView];
}

- (void)createTableView
{
    settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,  64, MainScreenWidth, MainScreenHeight - 64)];
    settingTableView.delegate = self;
    settingTableView.dataSource = self;
    settingTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    settingTableView.backgroundColor = [CustomColorUtils colorWithHexString:@"#f7f7f7"];
    settingTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:settingTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    NormalInputTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NormalInputTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.backgroundColor = [UIColor clearColor];
    
    cell.title = [aryTitleData objectAtIndex:indexPath.row];
    cell.placeHolderTitle = [aryPlaceHolderData objectAtIndex:indexPath.row];
    cell.isTextFiledEnable = YES;
    
    [cell loadNormalInputTextFieldCellData];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)onClickResign
{
    int i = 0 ;
    while (i < 1) {
        
        int maxNum = 3;
        
        for (int j = 0 ; j < maxNum ; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            NormalInputTextFieldCell *cell = (NormalInputTextFieldCell *)[settingTableView cellForRowAtIndexPath:indexPath];
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



#pragma mark -
- (void)onClickLeftItem
{
    [self onClickResign];
    
    LeftSideViewController *leftSideViewController = [[LeftSideViewController alloc] init];
    [[APPDELEGATE ppRevealSideViewController] pushViewController:leftSideViewController onDirection:PPRevealSideDirectionLeft animated:YES];
}

- (void)onClickSecondRightItem
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:@"" forKey:@"waterPrice"];
    [paramDic setObject:@"" forKey:@"electricityPrice"];
    [paramDic setObject:@"" forKey:@"gasPrice"];
    
    [CustomRequestUtils createNewPostRequest:@"/user/sys/setBasisHome.json" params:paramDic success:^(id responseObject) {
        NSDictionary *jsonDic = responseObject;
        if (jsonDic) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
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
