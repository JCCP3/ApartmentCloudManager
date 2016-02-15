//
//  Gas.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/25.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gas : NSObject

@property (nonatomic, strong) NSString *gasId;
@property (nonatomic, strong) NSString *mark;
@property (nonatomic, strong) NSString *homeId;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *currentNumber;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
