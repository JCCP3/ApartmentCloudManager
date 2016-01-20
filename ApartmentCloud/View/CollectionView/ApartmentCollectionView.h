//
//  ApartmentCollectionView.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/10.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Apartment.h"
#import "ApartmentRoom.h"

@protocol ApartmentCollectionViewDelegate <NSObject>

@optional
- (void)ACVD_addRoom:(Apartment *)apartment;
- (void)ACVD_goToRoom:(ApartmentRoom *)room;

@end

@interface ApartmentCollectionView : UICollectionView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) id <ApartmentCollectionViewDelegate> apartmentCollectionViewDelegate;
- (void)loadApartmentCollectionViewData;

@end
