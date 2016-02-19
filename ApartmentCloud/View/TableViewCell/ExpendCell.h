//
//  ExpendCell.h
//  ApartmentCloud
//
//  Created by Rose on 16/2/20.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpendInfo.h"

@interface ExpendCell : UITableViewCell

- (void)loadExpendCellData:(ExpendInfo *)expendInfo;

@end
