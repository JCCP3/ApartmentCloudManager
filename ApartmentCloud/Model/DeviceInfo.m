//
//  DeviceInfo.m
//  ApartmentCloud
//
//  Created by Rose on 16/2/21.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "DeviceInfo.h"

@implementation DeviceInfo

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
    if ([key isEqualToString:@"id"]) {
        self.deviceId = value;
    }
    
    if ([key isEqualToString:@"isHomeowners"]) {
        if ([value isEqualToString:@"Y"]) {
            self.isHomeOwner = YES;
        } else {
            self.isHomeOwner = NO;
        }
    }
}

@end
