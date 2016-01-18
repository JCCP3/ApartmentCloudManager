//
//  ApartmentUser.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/18.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApartmentUser : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userSex;
@property (nonatomic, strong) NSString *userPhone;
@property (nonatomic, strong) NSString *userCardId;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
