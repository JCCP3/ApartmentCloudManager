//
//  AddApartmentElecViewController.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/25.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"
#import "Elec.h"

@protocol AddApartmentElectDelegate <NSObject>

@optional
- (void)AAED_passElec:(Elec *)elec;

@end

@interface AddApartmentElecViewController : BaseViewController

@property (nonatomic, strong) Elec *currentElec;

@property (nonatomic, assign) id<AddApartmentElectDelegate> delegate;

@end
