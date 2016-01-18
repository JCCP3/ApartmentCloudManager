//
//  AddApartmentViewController.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/13.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"
#import "Apartment.h"

@protocol AddApartmentViewControllerDelegate <NSObject>

@optional
- (void)AAVCD_passApartment:(Apartment *)apartment;

@end

@interface AddApartmentViewController : BaseViewController

@property (nonatomic, strong) Apartment *addApartment;
@property (nonatomic, assign) id<AddApartmentViewControllerDelegate> delegate;

@end
