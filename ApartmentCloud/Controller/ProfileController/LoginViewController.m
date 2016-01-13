//
//  LoginViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/7.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "LeftSideViewController.h"
#import "LocalUserUtils.h"
#import "ApartmentManagerViewController.h"

@interface LoginViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITextField *accountTextField;
    UITextField *pwdTextField;
    
    CGFloat keyboardHeight;
    CGFloat keyboardOriginY;
    
    UITableView *loginTableView;
}

@end

@implementation LoginViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:nil segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(@"nav_menu.png") highlightedImage:ImageNamed(@"nav_menu.png")];
    [self removeSepaLine];
    
    [self setTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [self addKeyboardObserver];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self onClickResignKeyboard];
    [self removeObservers];
}

- (void)setTableView
{
    loginTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    loginTableView.delegate = self;
    loginTableView.dataSource = self;
    loginTableView.backgroundColor = [CustomColorUtils colorWithHexString:@"#fb5d6b"];
    [self.view addSubview:loginTableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickResignKeyboard)];
    [loginTableView addGestureRecognizer:tap];
    
    [self setTableHeaderView];
}

- (void)setTableHeaderView
{
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((MainScreenWidth - 130) / 2, 76, 130, 95)];
    logoImageView.image = ImageNamed(@"loginLogo.png");
    [tableHeaderView addSubview:logoImageView];
    
    //账号
    UIView *accountView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(logoImageView.frame) + 30, MainScreenWidth - 40, 45)];
    accountView.layer.cornerRadius = 20;
    accountView.backgroundColor = [CustomColorUtils colorWithHexString:@"#fc8e97"];
    [tableHeaderView addSubview:accountView];
    
    UIImageView *accountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 45 / 4, 45 / 2, 45 / 2)];
    [accountImageView setImage:ImageNamed(@"loginAccount.png")];
    [accountView addSubview:accountImageView];
    
    accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(accountImageView.frame) + 20, 0, CGRectGetWidth(accountView.bounds) - CGRectGetWidth(accountImageView.bounds) - 40, 45)];
    accountTextField.textColor = [UIColor whiteColor];
    accountTextField.keyboardType = UIKeyboardTypeNumberPad;
    accountTextField.placeholder = @"请输入您的手机号码";
    [accountView addSubview:accountTextField];
    
    //密码
    UIView *pwdView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(accountView.frame) + 30, MainScreenWidth - 40, 45)];
    pwdView.layer.cornerRadius = 20;
    pwdView.backgroundColor = [CustomColorUtils colorWithHexString:@"#fc8e97"];
    [tableHeaderView addSubview:pwdView];
    
    UIImageView *pwdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 45 / 4, 45 / 2, 45 / 2)];
    [pwdImageView setImage:ImageNamed(@"loginPwd.png")];
    [pwdView addSubview:pwdImageView];
    
    pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pwdImageView.frame) + 20, 0, CGRectGetWidth(pwdView.bounds) - CGRectGetWidth(pwdImageView.bounds) - 40, 45)];
    pwdTextField.textColor = [UIColor whiteColor];
    pwdTextField.placeholder = @"请输入您的密码";
    pwdTextField.secureTextEntry = YES;
    [pwdView addSubview:pwdTextField];
    
    //登陆
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(pwdView.frame) + 30, MainScreenWidth - 40, 45)];
    loginBtn.layer.cornerRadius = 20;
    [[loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (![CustomStringUtils isBlankString:accountTextField.text] && ![CustomStringUtils isBlankString:pwdTextField.text]) {
            NSString *requestUrl = [NSString stringWithFormat:@"/user/logon.json?account=%@&logonPassword=%@",accountTextField.text,pwdTextField.text];
            [CustomRequestUtils createNewRequest:requestUrl success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *jsonDic = responseObject;
                if ([[jsonDic objectForKey:@"status"] isEqualToString:RequestSuccessful]) {
                    [LocalUserUtils setLocalUserInfo:jsonDic];
                    
                    ApartmentManagerViewController *viewController = [[ApartmentManagerViewController alloc] init];
                    BaseNavController *nav = [[BaseNavController alloc] initWithRootViewController:viewController];
                    [[APPDELEGATE ppRevealSideViewController] popViewControllerWithNewCenterController:nav animated:YES];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",error);
            }];
        }
    }];
    loginBtn.backgroundColor = [UIColor whiteColor];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[CustomColorUtils colorWithHexString:@"#fb5d6b"] forState:UIControlStateNormal];
    [tableHeaderView addSubview:loginBtn];
    
    //忘记密码
    UIButton *forgetPwdBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(loginBtn.frame) + 5, CGRectGetMaxY(loginBtn.frame) + 10, 100, 14)];
    [[forgetPwdBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        RegisterViewController *view = [[RegisterViewController alloc] init];
        view.isRegisterView = NO;
        [self.navigationController pushViewController:view animated:YES];
    }];
    [forgetPwdBtn setTitle:@". 忘记密码" forState:UIControlStateNormal];
    [forgetPwdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    forgetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [tableHeaderView addSubview:forgetPwdBtn];
    
    //注册账号
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(loginBtn.frame) - 100 - 5, CGRectGetMaxY(loginBtn.frame) + 10, 100, 14)];
    [[registerBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        RegisterViewController *view = [[RegisterViewController alloc] init];
        view.isRegisterView = YES;
        [self.navigationController pushViewController:view animated:YES];
    }];
    [registerBtn setTitle:@". 注册账号" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    registerBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [tableHeaderView addSubview:registerBtn];
    
    loginTableView.tableHeaderView = tableHeaderView;
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
        [loginTableView setFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - keyboardHeight)];
    } else {
        [loginTableView setFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UITapGesture
- (void)onClickResignKeyboard
{
    [accountTextField resignFirstResponder];
    [pwdTextField resignFirstResponder];
}

#pragma mark - BaseAction
- (void)onClickLeftItem
{
    LeftSideViewController *leftSideViewController = [[LeftSideViewController alloc] init];
    [[APPDELEGATE ppRevealSideViewController] pushViewController:leftSideViewController onDirection:PPRevealSideDirectionLeft animated:YES];
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
