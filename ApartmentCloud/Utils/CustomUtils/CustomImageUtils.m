//
//  CustomImageUtils.m
//  YouShaQi
//
//  Created by 纪超 on 15/8/19.
//  Copyright (c) 2015年 HangZhou RuGuo Network Technology Co.Ltd. All rights reserved.
//

#import "CustomImageUtils.h"

@implementation CustomImageUtils

//自定义颜色的按钮
+ (UIImage *)createImageFromColor:(UIColor *)color width:(CGFloat)width height:(CGFloat)height
{
    CGRect rect = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//创建评分图片
+ (UIImage *)createScoreImage:(NSInteger)rating
{
    CGSize imgSize = CGSizeMake(66, 10);
    UIGraphicsBeginImageContextWithOptions(imgSize, NO, 2.0);
    
    UIImage *redStar = ImageNamed(@"forum_red_star.png");
    UIImage *grayStar = ImageNamed(@"forum_gray_star.png");
    
    NSInteger redStarCount = rating;
    NSInteger grayStarCount = 5 - rating;
    CGFloat space = 14;
    for (int i = 0; i < redStarCount; i++) {
        [redStar drawAtPoint:CGPointMake(i * space, 0)];
    }
    CGFloat positionX = space * redStarCount;
    for (int j = 0; j < grayStarCount; j++) {
        [grayStar drawAtPoint:CGPointMake(positionX + j * space, 0)];
    }
    
    // Read the UIImage object
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//创建封面遮罩图片
+ (UIImage *)createCoverWrapper
{
    return [ImageNamed(@"cover_wrapper.png") resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
}

//设置图片路径
+ (void)setImageUrlWithCustomPre:(EGOImageView *)imageView imageUrlStr:(NSString *)imageUrlStr imageType:(NSString *)type imageSize:(NSString *)size;
{
    if ([CustomStringUtils isBlankString:imageUrlStr]) {
        [imageView setImageURL:nil];
        return;
    }
    if ([imageUrlStr hasPrefix:@"http://"]) {
        [imageView setImageURL:[NSURL URLWithString:imageUrlStr]];
    } else {
        NSString *imageUrl;
        if ([type isEqualToString:@"avatar"]) {
            NSString *avatarSize = [NSString stringWithFormat:@"avatar%@", [size isEqualToString:@"s"] ? @"s" : @"l"];
            imageUrl = [NSString stringWithFormat:@"%@-%@", imageUrlStr, avatarSize];
        } else if ([type isEqualToString:@"cover"]) {
            NSString *coverSize = [NSString stringWithFormat:@"cover%@", [size isEqualToString:@"s"] ? @"s" : @"l"];
            imageUrl = [NSString stringWithFormat:@"%@-%@", imageUrlStr, coverSize];
        } else {
            imageUrl = imageUrlStr;
        }
        [imageView setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [CustomUrlUtils getGlobalImageUrlPre], imageUrl]]];
    }
}

//根据设备获取相应图片
+ (UIImage *)getImageContentsOfFile:(NSString *)imageName imageType:(NSString *)imageType
{
    NSString *imageNameFormat;
    if (IS_IPAD) {
        imageNameFormat = [NSString stringWithFormat:@"%@_ipad@2x", imageName];
    } else if (IS_IPHONE_6P) {
        imageNameFormat = [NSString stringWithFormat:@"%@@3x", imageName];
    } else {
        imageNameFormat = [NSString stringWithFormat:@"%@@2x", imageName];
    }
    return ImageContentsOfFile(imageNameFormat, imageType);
}

//获取默认头像
+ (UIImage *)getDefaultLightAvatar
{
    return ImageNamed(@"default_avatar_light.png");
}

//获取默认封面
+ (UIImage *)getDefaultBookCover
{
    return ImageNamed(@"default_book_cover.png");
}

@end
