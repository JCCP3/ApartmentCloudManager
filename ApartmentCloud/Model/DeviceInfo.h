//
//  DeviceInfo.h
//  ApartmentCloud
//
//  Created by Rose on 16/2/21.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfo : NSObject

@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) NSString *homeId;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, strong) NSString *homeName;
@property (nonatomic, strong) NSString *mark;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSString *merchantId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *payDate;
@property (nonatomic, assign) BOOL isHomeOwner;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
