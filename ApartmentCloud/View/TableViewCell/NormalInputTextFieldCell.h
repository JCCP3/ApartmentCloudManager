//
//  NormalInputTextFieldCell.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/10.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Apartment.h"

typedef enum
{
    AddApartmentLogic = 1,
    AddSaleLogic = 2,
    AddDecorateLogic = 3
    
} NormalInputTextFieldCellType;

typedef enum
{
    KeyboardNumPad = 1,
    KeyboardASCII = 2
    
} KeyBoardType;

@interface NormalInputTextFieldCell : UITableViewCell

@property (nonatomic, strong) UITextField *descTextField;

@property (nonatomic, assign) NormalInputTextFieldCellType cellType;
@property (nonatomic, assign) KeyBoardType keyboardType;
@property (nonatomic, strong) Apartment *apartment;

@property (nonatomic, assign) BOOL isTextFiledEnable;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *placeHolderTitle;


- (void)loadNormalInputTextFieldCellData;
- (void)loadNormalInputTextFieldCellData:(Apartment *)apartment withIndexPath:(NSIndexPath *)indexPath;

@end
