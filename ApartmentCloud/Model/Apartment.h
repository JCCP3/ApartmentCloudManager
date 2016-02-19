//
//  Apartment.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/13.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Apartment : NSObject

@property (nonatomic, strong) NSString *apartmentId;
@property (nonatomic, strong) NSString *apartmentName;
@property (nonatomic, strong) NSString *managerPhone;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *roadName;
@property (nonatomic, strong) NSString *communityName; //小区名称
@property (nonatomic, assign) CGFloat waterPrice;
@property (nonatomic, assign) CGFloat electricityPrice;
@property (nonatomic, assign) CGFloat gasPrice;
@property (nonatomic, strong) NSArray *roomArray;

@property (nonatomic, assign) NSInteger idleCount;
@property (nonatomic, assign) NSInteger rentCount;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
