//
//  ApartmentGasListViewController.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/25.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"

@protocol ApartmentGasListDelegate <NSObject>

@optional
- (void)AWLD_passApartmentGasArray:(NSMutableArray *)aryApartmentGas;

@end

@interface ApartmentGasListViewController : BaseViewController

@property (nonatomic, assign) id<ApartmentGasListDelegate> delegate;

@end
