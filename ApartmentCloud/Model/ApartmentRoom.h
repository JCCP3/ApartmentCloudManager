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
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *tanantNumber;
@property (nonatomic, strong) Apartment *roomAtApartment;
@property (nonatomic, strong) NSString *deliverCategory;
@property (nonatomic, strong) NSString *monthlyRent;
@property (nonatomic, strong) NSString *deposit;
@property (nonatomic, strong) NSString *expDate;
@property (nonatomic, strong) NSString *rentCategory;
@property (nonatomic, strong) NSString *mark;
@property (nonatomic, strong) NSString *userIds;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
