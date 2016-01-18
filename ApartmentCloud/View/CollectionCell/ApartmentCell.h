//
//  ApartmentCell.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/10.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApartmentRoom.h"

@interface ApartmentCell : UICollectionViewCell

- (void)loadApartmentRoomCellData:(ApartmentRoom *)room;

@end
