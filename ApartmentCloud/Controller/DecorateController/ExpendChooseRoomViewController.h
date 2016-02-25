//
//  ExpendChooseRoomViewController.h
//  ApartmentCloud
//
//  Created by Rose on 16/2/23.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"
#import "ApartmentRoom.h"

@protocol ExpendChooseRoomViewControllerDelegate <NSObject>

@optional
- (void)ECRVD_passRoomInfo:(ApartmentRoom *)apartmentRoom;

@end

@interface ExpendChooseRoomViewController : BaseViewController

@property (nonatomic, assign) id<ExpendChooseRoomViewControllerDelegate> delegate;

@end
