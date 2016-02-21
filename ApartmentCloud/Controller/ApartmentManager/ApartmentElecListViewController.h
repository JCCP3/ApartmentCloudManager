//
//  ApartmentElecViewController.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/25.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"
#import "Elec.h"

@protocol ApartmentElecListDelegate <NSObject>

@optional
- (void)AELD_passApartmentElec:(Elec *)elec;

@end

@interface ApartmentElecListViewController : BaseViewController

@property (nonatomic, assign) BOOL fromLeftSide;
@property (nonatomic, assign) id <ApartmentElecListDelegate> delegate;

@end
