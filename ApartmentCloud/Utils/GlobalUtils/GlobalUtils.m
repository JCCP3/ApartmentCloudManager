//
//  GlobalUtils.m
//  YouShaQi
//
//  Created by admin on 12-9-7.
//  Copyright (c) 2012年 HangZhou RuGuo Network Technology Co.Ltd. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "GlobalUtils.h"
#import "OBCConvertor.h"
#import "UIDevice+IdentifierAddition.h"
#import "CustomUrlUtils.h"

@implementation GlobalUtils

//***********创建自定义背景图的navigationBar
+ (UINavigationBar *)createHomePageNavigationBarWithRedColor:(UIImage *)titleImage withWidth:(CGFloat)viewWidth
{
    CGFloat navHeight = 64;
    UINavigationBar *customNavigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, viewWidth, navHeight)];
    
    UIView *navigationBarBackgroundView = [[UIView alloc] initWithFrame:customNavigationBar.bounds];
    navigationBarBackgroundView.backgroundColor = RGBCOLOR(167, 10, 10);
    [customNavigationBar addSubview:navigationBarBackgroundView];
    
    UIView *naviBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, navHeight - 0.5f, viewWidth, 0.5f)];
    naviBottomLine.backgroundColor = RGBCOLOR(133, 11, 11);
    [customNavigationBar addSubview:naviBottomLine];
    
    UIImageView* titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    titleImageView.frame = CGRectMake(customNavigationBar.frame.size.width/2-titleImage.size.width, customNavigationBar.frame.size.height/2-titleImage.size.height, titleImage.size.width, titleImage.size.height);
	UINavigationItem *navigationTitle = [[UINavigationItem alloc] init];
    navigationTitle.titleView = titleImageView;
	[customNavigationBar pushNavigationItem:navigationTitle animated:NO];
	
	return customNavigationBar;
}

//创建二级导航按钮
+ (UIButton *)createSecondaryNavBtn:(CGRect)frame withTitle:(NSString *)title
{
    UIButton *navBtn = [[UIButton alloc] initWithFrame:frame];
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, CGRectGetWidth(frame), 14)];
    navLabel.tag = 99;
    navLabel.text = title;
    navLabel.textColor = [CustomColorUtils colorWithHexString:@"#888888"];
    navLabel.font = [UIFont systemFontOfSize:12.0f];
//    navLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.5f];
//    navLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    navLabel.textAlignment = NSTextAlignmentCenter;
    [navBtn addSubview:navLabel];
    
    [navBtn setBackgroundImage:ImageNamed(@"new_nav_normal.png") forState:UIControlStateNormal];
    [navBtn setBackgroundImage:ImageNamed(@"new_nav_hilighted.png") forState:UIControlStateHighlighted];
    [navBtn setBackgroundImage:ImageNamed(@"new_nav_selected.png") forState:UIControlStateSelected];
    [navBtn setBackgroundImage:ImageNamed(@"new_nav_selected.png") forState:UIControlStateSelected|UIControlStateHighlighted];
    
    return navBtn;
}

+ (void)refreshSecondaryNavBtn:(UIButton *)navBtn
{
    [(UILabel *)[navBtn viewWithTag:99] setTextColor:RGBCOLOR(85, 85, 85)];
    [navBtn setBackgroundImage:ImageNamed(@"new_nav_normal.png") forState:UIControlStateNormal];
    [navBtn setBackgroundImage:ImageNamed(@"new_nav_hilighted.png") forState:UIControlStateHighlighted];
    [navBtn setBackgroundImage:ImageNamed(@"new_nav_selected.png") forState:UIControlStateSelected];
    [navBtn setBackgroundImage:ImageNamed(@"new_nav_selected.png") forState:UIControlStateSelected|UIControlStateHighlighted];
}

//设置刷新时间
+ (NSString *)updateRefreshTime:(NSString *)refreshTitle
{
    NSString *refreshTime = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] * 1000];
    [UserDefaults setObject:refreshTime forKey:refreshTitle];
    [UserDefaults synchronize];
    return refreshTime;
}


//标记个人信息需要刷新
+ (void)updateUserInfoStatus:(BOOL)status
{
    [UserDefaults setBool:status forKey:@"userInfoNeedUpdate"];
    [UserDefaults synchronize];
}



//获取当前网络状况
+ (NSString *)getCurrentNet
{
    NSString *result;
    if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        if ([[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi]) {
            result = @"wifi";
        } else {
            result = @"3g";
        }
    }
    return result;
}

//自定义pushView
+ (void)customPushViewControllerWithVC:(UIViewController *)currentVC destinationVC:(UIViewController *)destinationVC
{
    if (![[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
        [currentVC.navigationController pushViewController:destinationVC animated:YES];
    }
}

//自定义presentView
+ (void)customPresentViewControllerWithVC:(UIViewController *)currentVC destinationVC:(UIViewController *)destinationVC
{
    if (![[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
        [currentVC presentViewController:destinationVC animated:YES completion:nil];
    }
}

//当前页面截图
+ (UIImage *)snapshotWithVC:(UIViewController *)VC
{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    UIGraphicsBeginImageContextWithOptions(viewSize, NO, [[UIScreen mainScreen] scale]);
    
    if (IOS7) {
        [VC.view drawViewHierarchyInRect:VC.view.bounds afterScreenUpdates:YES];
    } else {
        [VC.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    // Read the UIImage object
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//删除loading图
+ (void)hideAndSetNil:(MBProgressHUD *__strong *)globalProgress
{
    if (*globalProgress && [*globalProgress isKindOfClass:[MBProgressHUD class]] && [*globalProgress superview]) {
        [*globalProgress removeFromSuperview];
        *globalProgress = nil;
    }
}

+ (void)hideProgress:(MBProgressHUD *__strong *)progress withMsg:(NSString *)msg
{
    if (*progress) {
        if (msg) {
            [*progress setLabelText:msg];
            [*progress setMode:MBProgressHUDModeText];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [GlobalUtils hideAndSetNil:progress];
            });
        } else {
            [GlobalUtils hideAndSetNil:progress];
        }
    }
}

//获取父视图的ViewController
+ (UIViewController *)getParentVC:(UIView *)view
{
    UIViewController *parentVC;
    id next = [view nextResponder];
    while(![next isKindOfClass:[UIViewController class]]) {
        next = [next nextResponder];
    }
    if ([next isKindOfClass:[UIViewController class]]) {
        parentVC = (UIViewController *)next;
    }
    return parentVC;
}

//判断是不是网络错误
+ (BOOL)isNetworkError:(NSInteger)errorCode
{
    NSArray *errorCodeArr = @[@-1005, @-1009];
    if ([errorCodeArr containsObject:@(errorCode)]) {
        return YES;
    }
    return NO;
}

//判断是不是连接超时
+ (BOOL)isTimedOutError:(NSInteger)errorCode
{
    NSArray *errorCodeArr = @[@-999, @-1001];
    if ([errorCodeArr containsObject:@(errorCode)]) {
        return YES;
    }
    return NO;
}

//消除推送角标
+ (void)removeNotificationBadge
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        }
    } else {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}

//抽取书名
+ (NSString *)pickBookNameFromUrl:(NSURL *)url
{
    NSString *linkStr = [CustomUrlUtils decodeFromPercentEscapeString:[NSString stringWithFormat:@"%@", url]];
    linkStr = [linkStr stringByReplacingOccurrencesOfString:@"《" withString:@""];
    linkStr = [linkStr stringByReplacingOccurrencesOfString:@"》" withString:@""];

    return linkStr;
}


//简繁转换
+ (NSString *)translateStr:(NSString *)originStr
{
    BOOL traditionalMode = [UserDefaults boolForKey:@"TraditionalMode"];
    
    NSString *translatedStr = traditionalMode ? [[OBCConvertor getInstance] s2t:originStr] : originStr;
    return translatedStr;
}

//获取当前设备方向
+ (UIInterfaceOrientation)getCurrentRealInterfaceOrientationWithVC:(UIViewController *)VC
{
    UIInterfaceOrientation interfaceOrientation = [VC interfaceOrientation];
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIDeviceOrientationLandscapeLeft) {
        return interfaceOrientation;
    } else if (orientation == UIDeviceOrientationLandscapeRight) {
        return interfaceOrientation;
    } else if (orientation == UIDeviceOrientationPortrait) {
        return UIInterfaceOrientationPortrait;
    } else {
        return interfaceOrientation;
    }
}

//设置文件夹不被iCloud备份
+ (void)addSkipBackupAttributeToItemAtPath:(NSString *)filePathString
{
    NSURL *URL = [NSURL fileURLWithPath:filePathString];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[URL path]]) {
        NSError *error = nil;
        BOOL success = [URL setResourceValue:[NSNumber numberWithBool:YES]
                                      forKey:NSURLIsExcludedFromBackupKey error:&error];
        if(!success){
            NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }
    }
}

//利用正则表达式验证
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//打印视图大小
+ (void)logScreenSizeWithView:(UIView *)view
{
    NSLog(@"====================================");
//    NSLog(@"%@", NSStringFromCGRect([[UIScreen mainScreen] bounds]));
    NSLog(@"%@", NSStringFromCGRect([[UIApplication sharedApplication] keyWindow].frame));
    NSLog(@"%@", NSStringFromCGRect([[UIApplication sharedApplication] keyWindow].bounds));
    NSLog(@"%@", NSStringFromCGRect(view.frame));
    NSLog(@"%@", NSStringFromCGRect(view.bounds));
}

//更新版本过滤变量
+ (void)updateVersionLimitWithValue:(NSString *)value
{
    [UserDefaults setBool:[value boolValue] forKey:@"version_limit"];
    [UserDefaults synchronize];
}

+ (BOOL)versionLimitEnabled
{
    return NO;
//    return [UserDefaults boolForKey:@"version_limit"];
}



// 获取唯一设备ID
+ (NSString *)getDeviceID
{
    //获取设备id号
    UIDevice *device = [UIDevice currentDevice];//创建设备对象
    return [NSString stringWithFormat:@"%@", [device uniqueCustomIdentifier]];
}



@end
