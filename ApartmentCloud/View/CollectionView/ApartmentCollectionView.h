//
//  ApartmentCollectionView.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/10.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApartmentCollectionView : UICollectionView <UICollectionViewDelegate, UICollectionViewDataSource>

- (void)loadApartmentCollectionViewData;

@end
