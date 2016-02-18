//
//  ApartmentUser.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/18.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApartmentUser : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *userSex;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *numberId;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSNumber *apartmentUserId;
@property (nonatomic, strong) NSString *merchantId;
@property (nonatomic, assign) BOOL isSelect;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
