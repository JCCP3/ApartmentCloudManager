//
//  CustomStringUtils.h
//  YouShaQi
//
//  Created by 蔡三泽 on 15/8/19.
//  Copyright (c) 2015年 HangZhou RuGuo Network Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomStringUtils : NSObject

//判断string是否为空
+ (BOOL)isBlankString:(NSString *)string;
+ (NSString *)platformString;


//统计字数
+ (int)countWord:(NSString*)s;

//分割字符串
+ (NSArray *)splitTextWithOriginText:(NSString *)text width:(CGFloat)width font:(UIFont *)font maxLineNum:(NSUInteger)maxLineNum;
//获取截取以后的字符a
+ (NSString *)getClipedTextWithOriginText:(NSString *)originText width:(CGFloat)width font:(UIFont *)font maxLineNum:(NSUInteger)maxLineNum;

+ (NSString *)stripSpace:(NSString *)originString;

//转换MD5
+ (NSString *)md5String:(NSString *)str;

@end
