//
//  DateFormatUtils.m
//  YouShaQi
//
//  Created by 蔡三泽 on 14-6-10.
//  Copyright (c) 2014年 HangZhou RuGuo Network Technology Co.Ltd. All rights reserved.
//

#import "DateFormatUtils.h"

@implementation DateFormatUtils

+ (DateFormatUtils *)sharedInstance
{
    static DateFormatUtils *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[DateFormatUtils alloc] init];
    });
    
    return sharedManager;
}

- (id)init
{
    self = [super init];
    self.firstDateFormatter = [[NSDateFormatter alloc] init];
    [self.firstDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [self.firstDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'.'SSS'Z'"];
    
    self.secondDateFormatter = [[NSDateFormatter alloc] init];
    [self.secondDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    self.thirdDateFormatter = [[NSDateFormatter alloc] init];
    [self.thirdDateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.fourthDateFormatter = [[NSDateFormatter alloc] init];
    [self.fourthDateFormatter setDateFormat:@"MM-dd HH:mm"];
    return self;
}

@end
