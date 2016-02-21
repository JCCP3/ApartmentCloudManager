//
//  ExpendInfo.h
//  ApartmentCloud
//
//  Created by Rose on 16/2/20.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpendInfo : NSObject

@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) NSInteger homeId;
@property (nonatomic, strong) NSString *homeName;
@property (nonatomic, strong) NSString *expendInfoId;
@property (nonatomic, strong) NSString *mark;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *successDate;
@property (nonatomic, strong) NSString *userId;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
