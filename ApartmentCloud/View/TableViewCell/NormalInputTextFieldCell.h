//
//  NormalInputTextFieldCell.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/10.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApartmentRoom.h"
#import "ApartmentUser.h"

typedef enum
{
    AddApartmentLogic = 1,
    AddSaleLogic = 2,
    AddDecorateLogic = 3,
    AddApartmentUserLogic = 4,
    AddRoomLogic = 5
    
} NormalInputTextFieldCellType;

typedef enum
{
    KeyboardNumPad = 1,
    KeyboardASCII = 2
    
} KeyBoardType;

typedef enum
{
    ShowCellData = 1,
    AddCellData = 2
}LoadDataType;

@protocol NormalInputTextFieldCellDelegate <NSObject>

@optional
- (void)NITFC_addApartmentWithApartment:(Apartment *)apartment;
- (void)NITFC_addRoomWithRoom:(ApartmentRoom *)room;
- (void)NITFC_addApartmentUser:(ApartmentUser *)apartmentUser;

@end

@interface NormalInputTextFieldCell : UITableViewCell

@property (nonatomic, strong) UITextField *descTextField;
@property (nonatomic, strong) UIView *borderView;

@property (nonatomic, assign) id <NormalInputTextFieldCellDelegate> delegate;

@property (nonatomic, assign) NormalInputTextFieldCellType cellType;
@property (nonatomic, assign) KeyBoardType keyboardType;
@property (nonatomic, strong) Apartment *apartment;
@property (nonatomic, strong) ApartmentRoom *room;
@property (nonatomic, strong) ApartmentUser *apartmentUser;


@property (nonatomic, assign) BOOL isTextFiledEnable;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *placeHolderTitle;
@property (nonatomic, assign) BOOL isSelect;

- (void)loadNormalInputTextFieldCellData;

//添加公寓
- (void)loadAddApartmentCellWithIndexPath:(NSIndexPath *)indexPath;
- (void)loadAddRoomCellWithIndexPath:(NSIndexPath *)indexPath;
- (void)loadAddUserCellWithIndexPath:(NSIndexPath *)indexPath;
- (void)loadApartmentUserListCellWithIndexPath:(NSIndexPath *)indexPath;

//添加装修后勤
- (void)loadAddDecorateCellWithIndexPath:(NSIndexPath *)indexPath;

@end
