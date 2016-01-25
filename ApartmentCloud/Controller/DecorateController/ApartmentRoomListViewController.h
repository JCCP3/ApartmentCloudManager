//
//  ApartmentRoomListViewController.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/25.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"
#import "ApartmentRoom.h"

@protocol ApartmentRoomListDelegate <NSObject>

@optional
- (void)ARLD_passApartmentRoom:(ApartmentRoom *)room;

@end

@interface ApartmentRoomListViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *aryApartmentRoom;

@property (nonatomic, assign) id <ApartmentRoomListDelegate> delegate;

@end
