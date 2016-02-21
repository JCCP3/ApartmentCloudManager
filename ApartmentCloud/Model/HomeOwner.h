//
//  HomeOwner.h
//  ApartmentCloud
//
//  Created by Rose on 16/2/21.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeOwner : NSObject

@property (nonatomic, strong) NSString *homeId;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, strong) NSString *contractMaturity;
@property (nonatomic, strong) NSString *contractStart;
@property (nonatomic, assign) NSInteger deposit;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
