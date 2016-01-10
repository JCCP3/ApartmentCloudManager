//
//  NormalInputTextFieldCell.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/10.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NormalInputTextFieldCell : UITableViewCell

@property (nonatomic, assign) BOOL isTextFiledEnable;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *placeHolderTitle;

- (void)loadNormalInputTextFieldCellData;

@end
