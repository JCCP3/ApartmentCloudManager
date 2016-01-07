//
//  CustomImageUtils.h
//  YouShaQi
//
//  Created by 蔡三泽 on 15/8/19.
//  Copyright (c) 2015年 HangZhou RuGuo Network Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGOImageView.h"

@interface CustomImageUtils : NSObject

//自定义颜色的按钮
+ (UIImage *)createImageFromColor:(UIColor *)color width:(CGFloat)width height:(CGFloat)height;
//创建评分图片
+ (UIImage *)createScoreImage:(NSInteger)rating;
//创建封面遮罩图片
+ (UIImage *)createCoverWrapper;

//设置图片路径
+ (void)setImageUrlWithCustomPre:(EGOImageView *)imageView imageUrlStr:(NSString *)imageUrlStr imageType:(NSString *)type imageSize:(NSString *)size;

//根据设备获取相应图片
+ (UIImage *)getImageContentsOfFile:(NSString *)imageName imageType:(NSString *)imageType;

//获取默认头像
+ (UIImage *)getDefaultLightAvatar;
//获取默认封面
+ (UIImage *)getDefaultBookCover;

@end
