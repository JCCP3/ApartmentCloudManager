//
//  ApartmentFloor.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/13.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApartmentFloor : NSObject

@property (nonatomic, strong) NSString *apartmentFloorId;
@property (nonatomic, strong) NSString *apartmentId;
@property (nonatomic, strong) NSString *floorName;
@property (nonatomic, strong) NSString *room;
@property (nonatomic, strong) NSString *link;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
