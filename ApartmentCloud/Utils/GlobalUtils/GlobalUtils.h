//
//  GlobalUtils.h
//  YouShaQi
//
//  Created by admin on 12-9-7.
//  Copyright (c) 2012年 HangZhou RuGuo Network Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "TTTAttributedLabel.h"
#import <objc/runtime.h>

@interface GlobalUtils : NSObject

+ (UINavigationBar *)createHomePageNavigationBarWithRedColor:(UIImage *)titleImage withWidth:(CGFloat)viewWidth;
//创建二级导航按钮
+ (UIButton *)createSecondaryNavBtn:(CGRect)frame withTitle:(NSString *)title;
+ (void)refreshSecondaryNavBtn:(UIButton *)navBtn;

//设置刷新时间
+ (NSString *)updateRefreshTime:(NSString *)refreshTitle;

//获取个人信息状态
+ (BOOL)getUserInfoStatus;
//标记个人信息需要刷新
+ (void)updateUserInfoStatus:(BOOL)status;

//广告跳转
+ (void)customOpenUrl:(NSString *)urlStr;

//应用评价经验增加
+ (void)addUserExpRequestByRateApp;
//获取当前网络状况
+ (NSString *)getCurrentNet;
//自定义pushView
+ (void)customPushViewControllerWithVC:(UIViewController *)currentVC destinationVC:(UIViewController *)destinationVC;
//自定义presentView
+ (void)customPresentViewControllerWithVC:(UIViewController *)currentVC destinationVC:(UIViewController *)destinationVC;
//当前页面截图
+ (UIImage *)snapshotWithVC:(UIViewController *)VC;

//删除loading图
+ (void)hideAndSetNil:(MBProgressHUD *__strong *)progress;
+ (void)hideProgress:(MBProgressHUD *__strong *)progress withMsg:(NSString *)msg;

//获取父视图的ViewController
+ (UIViewController *)getParentVC:(UIView *)view;

//判断是不是网络错误
+ (BOOL)isNetworkError:(NSInteger)errorCode;
//判断是不是连接超时
+ (BOOL)isTimedOutError:(NSInteger)errorCode;

//获取自定义Item的所有变量名
+ (NSArray *)getAllPropertyNames:(Class)itemClass;

//重新设置推送
+ (void)resetRemoteNotification;
//消除推送角标
+ (void)removeNotificationBadge;

//抽取书名
+ (NSString *)pickBookNameFromUrl:(NSURL *)url;
//设置链接
+ (void)replaceTitleToLinkWithLabel:(TTTAttributedLabel *)tmpLabel isOffical:(BOOL)isOffical;
//获取官方链接信息
+ (NSDictionary *)getMatchedDicFromOfficalLinkWithStr:(NSString *)originContent matchLength:(NSUInteger)matchLength;

//简繁转换
+ (NSString *)translateStr:(NSString *)originStr;

//获取当前设备方向
+ (UIInterfaceOrientation)getCurrentRealInterfaceOrientationWithVC:(UIViewController *)VC;

//设置文件夹不被iCloud备份
+ (void)addSkipBackupAttributeToItemAtPath:(NSString *)filePathString;

//漫画岛变量
+ (BOOL)allowShowComicIsland;
+ (void)updateComicIslandWithStatus:(BOOL)show;

//登录变量
+ (BOOL)allowShowEmailLogin;
+ (void)updateEmailLoginWithStatus:(BOOL)show;

//加密秘钥
+ (NSString *)encryptedPassword:(NSString *)originPassword;

//利用正则表达式验证
+ (BOOL)isValidateEmail:(NSString *)email;

//打印视图大小
+ (void)logScreenSizeWithView:(UIView *)view;

//更新版本过滤变量
+ (void)updateVersionLimitWithValue:(NSString *)value;
+ (BOOL)versionLimitEnabled;

// 获取唯一设备ID
+ (NSString *)getDeviceID;

//分辨新老用户
+ (void)setNewUserTag;
//判断是否为新用户
+ (BOOL)isNewUser;

//获取标签颜色
+ (UIColor *)getTagColorWithIndex:(NSInteger)index;

//友盟计数事件
+ (void)uploadCountEventWithId:(NSString *)eventId label:(NSString *)eventLabel;

//友盟计算事件
+ (void)uploadCaculateEventWithId:(NSString *)eventId attributes:(NSDictionary *)eventAttributes;

+ (void)unSubScribeAll;

@end
