//
//  HomeOwner.m
//  ApartmentCloud
//
//  Created by Rose on 16/2/21.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "HomeOwner.h"

@implementation HomeOwner

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [self setValuesForKeysWithDictionary:dic];
        }
    }
    
    return self;
}

@end
