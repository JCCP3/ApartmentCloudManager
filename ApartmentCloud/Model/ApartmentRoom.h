//
//  ApartmentRoom.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/18.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Apartment.h"

@interface ApartmentRoom : NSObject

@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *roomUsers;
@property (nonatomic, strong) Apartment *roomAtApartment;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
