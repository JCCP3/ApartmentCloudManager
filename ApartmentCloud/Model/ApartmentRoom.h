//
//  ApartmentRoom.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/18.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Apartment.h"

@interface ApartmentRoom : NSObject

@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, strong) NSString *homeName;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, assign) NSInteger tanantNumber;
@property (nonatomic, strong) Apartment *roomAtApartment;
@property (nonatomic, strong) NSString *deliverCategory;
@property (nonatomic, assign) NSInteger monthlyRent;
@property (nonatomic, assign) NSInteger deposit;
@property (nonatomic, strong) NSString *expDate;
@property (nonatomic, strong) NSString *rentCategory;
@property (nonatomic, strong) NSString *mark;
@property (nonatomic, strong) NSString *userIds;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSMutableArray *aryApartmentUser;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
