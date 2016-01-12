//
//  RegisterViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/8.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *registerTableView;
    
    UITextField *accountTextField;
    UITextField *pwdTextField;
    UITextField *securityCodeTextField;
    UITextField *userNameTextField;
    
    CGFloat keyboardOriginY;
    CGFloat keyboardHeight;
}

@end

@implementation RegisterViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:self.isRegisterView ? @"注册" : @"找回密码" segmentArray:nil];
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    
    [self setUpTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addKeyboardObserver];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self onClickResignKeyboard];
    [self removeObservers];

}

- (void)setUpTableView
{
    registerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    registerTableView.backgroundColor = [CustomColorUtils colorWithHexString:@"#f7f7f7"];
    registerTableView.delegate = self;
    registerTableView.dataSource = self;
    [self.view addSubview:registerTableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickResignKeyboard)];
    [registerTableView addGestureRecognizer:tap];
    
    [self setUpTableHeaderView];
}

- (void)setUpTableHeaderView
{
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    
    CGFloat marginTop = 0;
    
    if (self.isRegisterView) {
        //姓名
        UIView *userNameView = [[UIView alloc] initWithFrame:CGRectMake(20, 30, MainScreenWidth - 40, 45)];
        userNameView.layer.borderWidth = 1;
        userNameView.layer.borderColor = AppThemeColor.CGColor;
        userNameView.layer.cornerRadius = 20;
        userNameView.backgroundColor = [UIColor whiteColor];
        [tableHeaderView addSubview:userNameView];
        
        userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(userNameView.bounds) - 40, 45)];
        userNameTextField.placeholder = @"请输入您的姓名";
        [userNameView addSubview:userNameTextField];
        
        marginTop += 75;
    }
    
    //账号
    UIView *accountView = [[UIView alloc] initWithFrame:CGRectMake(20, 30 + marginTop, MainScreenWidth - 40, 45)];
    accountView.layer.borderColor = AppThemeColor.CGColor;
    accountView.layer.borderWidth = 1;
    accountView.layer.cornerRadius = 20;
    accountView.backgroundColor = [UIColor whiteColor];
    [tableHeaderView addSubview:accountView];

    accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(accountView.bounds) - 40, 45)];
    accountTextField.keyboardType = UIKeyboardTypeNumberPad;
    accountTextField.placeholder = @"请输入您的手机号码";
    [accountView addSubview:accountTextField];
    
    
    //验证码
    UIView *securityView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(accountView.frame) + 30, MainScreenWidth - 50 - 110, 45)];
    securityView.backgroundColor = [UIColor whiteColor];
    [tableHeaderView addSubview:securityView];
    securityView.layer.borderWidth = 1;
    securityView.layer.borderColor = AppThemeColor.CGColor;
    securityView.layer.cornerRadius = 20;
    securityCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(securityView.bounds) - 40, 45)];
    securityCodeTextField.placeholder = @"请输入验证码";
    [securityView addSubview:securityCodeTextField];
    
    UIButton *securityBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(securityView.frame) + 10, CGRectGetMinY(securityView.frame), 110, 45)];
    securityBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    securityBtn.layer.cornerRadius = 20;
    [securityBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    @weakify (self);
    [[securityBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify (self);
        [self addSecrityBtnTimer:securityBtn];
        
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:accountTextField.text forKey:@"phone"];
        [paramDic setObject:@"REGISTER" forKey:@"category"];
        [CustomRequestUtils createNewPostRequest:@"/sendSMS.json" params:paramDic success:^(id responseObject) {
            
            NSDictionary *jsonDic = responseObject;
            if (jsonDic) {
                
            }
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }];
    [securityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [securityBtn setBackgroundColor:AppThemeColor];
    [tableHeaderView addSubview:securityBtn];
    
    //密码
    UIView *pwdView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(securityView.frame) + 30, MainScreenWidth - 40, 45)];
    pwdView.backgroundColor = [UIColor whiteColor];
    pwdView.layer.cornerRadius = 20;
    pwdView.layer.borderColor = AppThemeColor.CGColor;
    pwdView.layer.borderWidth = 1;
    [tableHeaderView addSubview:pwdView];
    
    UIImageView *pwdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 45 / 4, 45 / 2, 45 / 2)];
    [pwdImageView setImage:ImageNamed(@"loginPwd.png")];
    [pwdView addSubview:pwdImageView];
    
    pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pwdImageView.frame) + 20, 0, CGRectGetWidth(pwdView.bounds) - CGRectGetWidth(pwdImageView.bounds) - 40, 45)];
    pwdTextField.placeholder = @"请输入您的密码";
    pwdTextField.secureTextEntry = YES;
    [pwdView addSubview:pwdTextField];
    
    //确认提交
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(pwdView.frame) + 30, MainScreenWidth - 40, 45)];
    registerBtn.layer.cornerRadius = 20;
    registerBtn.enabled = NO;
    registerBtn.backgroundColor = AppThemeColor;
    [registerBtn setTitle:self.isRegisterView ? @"注册" : @"确认提交" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [[registerBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify (self);
        if (self.isRegisterView) {
            NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
            [paramDic setObject:userNameTextField.text forKey:@"realName"];
            [paramDic setObject:accountTextField.text forKey:@"phone"];
            [paramDic setObject:securityCodeTextField.text forKey:@"phoneCode"];
            [paramDic setObject:pwdTextField.text forKey:@"logonPassword"];
            
            [CustomRequestUtils createNewPostRequest:@"/user/register.json" params:paramDic success:^(id responseObject) {
                NSDictionary *jsonDic = responseObject;
                if ([[jsonDic objectForKey:@"status"] isEqualToString:RequestSuccessful]) {
                    //发送验证码成功
                }
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            }];
            
        }
    }];
    [tableHeaderView addSubview:registerBtn];
    
    registerTableView.tableHeaderView = tableHeaderView;
}

- (void)addSecrityBtnTimer:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
                btn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60 == 0 ? timeout : timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [btn setTitle:[NSString stringWithFormat:@"%@秒后重新获取",strTime] forState:UIControlStateNormal];
                btn.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - ValidLogin
- (BOOL)userNameIsValid:(NSString *)text
{
    return ![CustomStringUtils isBlankString:text] && text.length > 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [registerTableView setFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - keyboardHeight - 64)];
    } else {
        [registerTableView setFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    }
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
    [userNameTextField resignFirstResponder];
    [accountTextField resignFirstResponder];
    [pwdTextField resignFirstResponder];
    [securityCodeTextField resignFirstResponder];
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
