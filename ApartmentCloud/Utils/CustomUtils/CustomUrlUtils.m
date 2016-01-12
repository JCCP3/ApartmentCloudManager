//
//  CustomUrlUtils.m
//  YouShaQi
//
//  Created by 蔡三泽 on 15/8/19.
//  Copyright (c) 2015年 HangZhou RuGuo Network Technology Co.Ltd. All rights reserved.
//

#import "CustomUrlUtils.h"

@implementation CustomUrlUtils

//获取接口
+ (NSString *)getGlobalUrlPre
{
//    return kURL_Pre_Test;
    return kURL_Pre;
}

+ (NSString *)getGlobalImageUrlPre
{
    if ([UserDefaults boolForKey:@"isDevEnvironment"]) {
        return kURL_ImagePre_Test;
    } else {
        if ([UserDefaults objectForKey:@"defaultApi"]) {
            return [NSString stringWithFormat:@"http://%@.%@", kURL_ImagePre_Online, [UserDefaults objectForKey:@"defaultApi"]];
        } else {
            return kURL_ImagePre;
        }
    }
}

/* 对特殊字符进行编码，用来发送URL数据 */
+ (NSString *)encodeToPercentEscapeString:(NSString *)input
{
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}

+ (NSString *)decodeFromPercentEscapeString:(NSString *)input
{
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                              (CFStringRef)input,
                                                                              (CFStringRef)@"",
                                                                              kCFStringEncodingUTF8));
    return outputStr;
}

@end
