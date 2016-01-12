//
//  FeedBackViewController.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/12.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController () <UITextViewDelegate>
{
    UITextView *feedBackTextView;
    UILabel *placeHolderLabel;
}

@end

@implementation FeedBackViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [CustomColorUtils colorWithHexString:@"#f7f7f7"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorRed navTitle:@"用户反馈" segmentArray:nil];
    [self adaptLeftItemWithTitle:@"返回" backArrow:YES];
    [self adaptSecondRightItemWithTitle:@"确认提交"];
    
    [self createTextView];
}

- (void)createTextView
{
    feedBackTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10 + 64, MainScreenWidth - 20, 220)];
    feedBackTextView.delegate = self;
    feedBackTextView.layer.borderWidth = 1;
    feedBackTextView.layer.borderColor = [CustomColorUtils colorWithHexString:@"#888888"].CGColor;
    feedBackTextView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:feedBackTextView];
    
    placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, CGRectGetWidth(feedBackTextView.bounds) - 10, 12)];
    placeHolderLabel.textColor = [CustomColorUtils colorWithHexString:@"#888888"];
    placeHolderLabel.font = [UIFont systemFontOfSize:12.f];
    placeHolderLabel.text = @"使用中有任何问题都可以在这里反馈哦";
    [feedBackTextView addSubview:placeHolderLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (![CustomStringUtils isBlankString:textView.text]) {
        placeHolderLabel.hidden = YES;
    } else {
        placeHolderLabel.hidden = NO;
    }
}

#pragma mark - Base Action
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
