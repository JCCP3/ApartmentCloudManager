
//
//  ApartmentUser.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/18.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "ApartmentUser.h"

@implementation ApartmentUser

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [self setValuesForKeysWithDictionary:dic];
        }
    }
    
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"sex"]) {
        if ([value isEqualToString:@"M"]) {
            self.userSex = @"男";
        } else {
            self.userSex = @"女";
        }
    }
    
    if ([key isEqualToString:@"id"]) {
        self.apartmentUserId = value;
    }
}

@end
