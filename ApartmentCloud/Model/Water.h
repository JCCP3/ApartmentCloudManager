//
//  Water.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/25.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Water : NSObject

@property (nonatomic, strong) NSString *waterId;
@property (nonatomic, strong) NSString *mark;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, assign) NSInteger currentNumber;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *homeId;
@property (nonatomic, strong) NSString *homeName;
@property (nonatomic, assign) NSInteger uperNumber;
@property (nonatomic, strong) NSString *userId;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
