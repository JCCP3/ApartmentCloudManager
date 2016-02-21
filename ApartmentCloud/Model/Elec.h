//
//  Elec.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/25.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Elec : NSObject

@property (nonatomic, strong) NSString *elecId;
@property (nonatomic, strong) NSString *mark;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, assign) NSInteger currentNumber;
@property (nonatomic, strong) NSString *homeId;
@property (nonatomic, strong) NSString *homeName;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) NSInteger uperNumber;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
