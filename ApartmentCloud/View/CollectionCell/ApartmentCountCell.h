//
//  ApartmentCountCell.h
//  ApartmentCloud
//
//  Created by Rose on 16/2/19.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Apartment.h"

@interface ApartmentCountCell : UICollectionViewCell

- (void)loadApartmentCountCell:(Apartment *)apartment style:(NSString *)style;

@end
