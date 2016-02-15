//
//  Elec.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/25.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Elec : NSObject

@property (nonatomic, strong) NSString *waterId;
@property (nonatomic, strong) NSString *mark;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *currentNumber;
@property (nonatomic, strong) NSString *homeId;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
