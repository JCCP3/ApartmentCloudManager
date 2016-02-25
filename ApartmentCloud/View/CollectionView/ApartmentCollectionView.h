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

typedef enum
{
    MyApartmentCollectionViewTag = 1,
    PayApartmentCollectionViewTag = 2,
    ExpiredApartmentCollectionViewTag = 3
    
}ApartmentCollectionViewTag;

@protocol ApartmentCollectionViewDelegate <NSObject>

@optional
- (void)ACVD_addRoom:(Apartment *)apartment;
- (void)ACVD_goToRoom:(ApartmentRoom *)room;
- (void)ACVD_requestFinishWithTag:(ApartmentCollectionViewTag)tag;

- (void)ACVD_showApartmentDetailInfo:(Apartment *)apartment;
- (void)ACVD_showTitleViewArray:(NSMutableArray *)aryApartment;
- (void)ACVD_passRoom:(ApartmentRoom *)room;

@end

@interface ApartmentCollectionView : UICollectionView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) id <ApartmentCollectionViewDelegate> apartmentCollectionViewDelegate;

- (void)loadApartmentCollectionViewData;
- (void)loadDueApartmentCollectionViewData;
- (void)loadExpireApartmentCollectionViewData;
- (void)loadApartmentRoomCountCollectionViewData;

- (void)showDataWithApartment:(Apartment *)apartment;

@end
