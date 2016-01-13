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
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *roadName;
@property (nonatomic, strong) NSString *parcelTitle;
@property (nonatomic, strong) NSString *waterPay;
@property (nonatomic, strong) NSString *elecPay;
@property (nonatomic, strong) NSString *gasPay;



- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
