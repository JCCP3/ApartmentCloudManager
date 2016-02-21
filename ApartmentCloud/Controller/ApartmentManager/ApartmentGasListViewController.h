//
//  ApartmentGasListViewController.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/25.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"
#import "Gas.h"

@protocol ApartmentGasListDelegate <NSObject>

@optional
- (void)AGLD_passApartmentGas:(Gas *)gas;

@end

@interface ApartmentGasListViewController : BaseViewController

@property (nonatomic, assign) BOOL fromLeftSide;
@property (nonatomic, assign) id<ApartmentGasListDelegate> delegate;

@end
