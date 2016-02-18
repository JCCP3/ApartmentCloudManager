//
//  AddApartmentUserViewController.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/18.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"
#import "ApartmentUser.h"

@protocol AddApartmentUserDelegate <NSObject>

@optional
- (void)AAUD_passApartmentUser:(ApartmentUser *)apartmentUser;

@end

@interface AddApartmentUserViewController : BaseViewController

@property (nonatomic, assign) id<AddApartmentUserDelegate> delegate;
@property (nonatomic, strong) ApartmentUser *currentApartmentUser;

@end
