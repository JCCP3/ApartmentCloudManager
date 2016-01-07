//
//  DateFormatUtils.h
//  YouShaQi
//
//  Created by 蔡三泽 on 14-6-10.
//  Copyright (c) 2014年 HangZhou RuGuo Network Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateFormatUtils : NSObject

@property (nonatomic, strong) NSDateFormatter *firstDateFormatter;
@property (nonatomic, strong) NSDateFormatter *secondDateFormatter;
@property (nonatomic, strong) NSDateFormatter *thirdDateFormatter;
@property (nonatomic, strong) NSDateFormatter *fourthDateFormatter;
+ (DateFormatUtils *)sharedInstance;

@end
