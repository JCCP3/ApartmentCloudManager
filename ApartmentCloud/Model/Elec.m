//
//  Elec.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/25.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "Elec.h"

@implementation Elec

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
        self.elecId = value;
    }
}

@end
