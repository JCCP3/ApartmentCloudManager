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
#import "ExpendInfo.h"
#import "Water.h"
#import "Gas.h"
#import "Elec.h"
#import "HomeOwner.h"
#import "DeviceInfo.h"

typedef enum
{
    AddApartmentLogic = 1,
    AddSaleLogic = 2,
    AddDecorateLogic = 3,
    AddApartmentUserLogic = 4,
    AddRoomLogic = 5,
    AddExpendLogic = 6,
    AddWaterLogic = 7,
    AddElecLogic = 8,
    AddGasLogic = 9,
    AddHourseHolderLogic = 10,
    AddDeviceInfoLogic = 11
    
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
- (void)NITFC_addHouseHolder:(HomeOwner *)owner;
- (void)NITFC_addDeviceInfo:(DeviceInfo *)device;
- (void)NITFC_addGas:(Gas *)gas;
- (void)NITFC_addElec:(Elec *)elec;
- (void)NITFC_addWater:(Water *)water;
- (void)NITFC_addExpend:(ExpendInfo *)expendInfo;

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
@property (nonatomic, strong) ExpendInfo *expendInfo;

@property (nonatomic, strong) Water *water;
@property (nonatomic, strong) Elec *elec;
@property (nonatomic, strong) Gas *gas;

@property (nonatomic, strong) HomeOwner *owner;
@property (nonatomic, strong) DeviceInfo *deviceInfo;

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

//添加支出信息
- (void)loadAddExpendCellWithIndexPath:(NSIndexPath *)indexPath;

//添加水电气
- (void)loadAddWaterCellWithIndexPath:(NSIndexPath *)indexPath;
- (void)loadAddGasCellWithIndexPath:(NSIndexPath *)indexPath;
- (void)loadAddElecCellWithIndexPath:(NSIndexPath *)indexPath;

//房主信息
- (void)loadAddHourseHolderWithIndexPath:(NSIndexPath *)indexPath;

//添加设备
- (void)loadAddDeviceWithIndexPath:(NSIndexPath *)indexPath;

@end
