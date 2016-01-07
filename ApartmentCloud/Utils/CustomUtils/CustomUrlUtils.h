//
//  CustomUrlUtils.h
//  YouShaQi
//
//  Created by 蔡三泽 on 15/8/19.
//  Copyright (c) 2015年 HangZhou RuGuo Network Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomUrlUtils : NSObject

//获取接口
+ (NSString *)getGlobalUrlPre;
+ (NSString *)getGlobalImageUrlPre;
+ (NSString *)getGlobalChapterUrlPre;

//对特殊字符进行编码，然后发送URL
+ (NSString *)encodeToPercentEscapeString:(NSString *)input;
+ (NSString *)decodeFromPercentEscapeString:(NSString *)input;

@end
