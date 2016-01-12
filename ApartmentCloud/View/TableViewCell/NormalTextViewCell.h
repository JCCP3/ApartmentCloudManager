//
//  NormalTextViewCell.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/12.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NormalTextViewCell : UITableViewCell

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *placeHolderTitle;

- (void)loadNormalTextViewCell;

@end
