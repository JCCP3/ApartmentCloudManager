//
//  ApartmentWaterListViewController.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/25.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"

@protocol ApartmentWaterListDelegate <NSObject>

@optional
- (void)AWLD_passApartmentWaterArray:(NSMutableArray *)aryApartmentWater;

@end

@interface ApartmentWaterListViewController : BaseViewController

@property (nonatomic, assign) BOOL fromLeftSide;
@property (nonatomic, assign) id<ApartmentWaterListDelegate> delegate;

@end
