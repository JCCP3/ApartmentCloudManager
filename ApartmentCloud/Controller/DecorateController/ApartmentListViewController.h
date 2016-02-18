//
//  ApartmentListViewController.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/25.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"
#import "Apartment.h"

@protocol ApartmentListViewControllerDelegate <NSObject>

@optional
- (void)ALVCD_passApartment:(Apartment *)apartment withRoomArray:(NSMutableArray *)aryRoom;

@end

@interface ApartmentListViewController : BaseViewController

@property (nonatomic, assign) id<ApartmentListViewControllerDelegate> delegate;

@end
