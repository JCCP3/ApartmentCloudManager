//
//  NormalInputTextFieldCell.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/10.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "NormalInputTextFieldCell.h"
#import "CustomTimeUtils.h"

@interface NormalInputTextFieldCell () <UITextFieldDelegate>
{
    UILabel *titleLabel;
    UILabel *sepaLabel;
    
    NSIndexPath *currentIndexPath;
}

@end

@implementation NormalInputTextFieldCell
@synthesize descTextField, borderView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        borderView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, MainScreenWidth - 20, 45)];
        borderView.layer.borderWidth = 1;
        borderView.layer.borderColor = [CustomColorUtils colorWithHexString:@"#f7f7f7"].CGColor;
        borderView.backgroundColor = [UIColor whiteColor];
        borderView.tag = 10086;
        [self.contentView addSubview:borderView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15.5, 60, 14)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:14.f];
        [borderView addSubview:titleLabel];
        
        sepaLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame) + 4, 15.5, 0.5, 14.f)];
        sepaLabel.backgroundColor = [UIColor blackColor];
        [borderView addSubview:sepaLabel];
        
        descTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame) + 10, 15.5, CGRectGetWidth(borderView.bounds) - 10 - 10 - CGRectGetMaxX(titleLabel.frame), 14.f)];
        descTextField.delegate = self;
        descTextField.font = [UIFont systemFontOfSize:14.f];
        [borderView addSubview:descTextField];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)decorateTitleWithDesc
{
    if (self.isTextFiledEnable) {
        descTextField.enabled = YES;
    } else {
        descTextField.enabled = NO;
    }
    
    if (self.keyboardType == KeyboardNumPad) {
        descTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    titleLabel.text = self.title;
    descTextField.placeholder = self.placeHolderTitle;
    descTextField.font = [UIFont systemFontOfSize:14.f];
}

- (void)loadNormalInputTextFieldCellData
{
    [self decorateTitleWithDesc];
}

- (void)loadAddRoomCellWithIndexPath:(NSIndexPath *)indexPath
{
    currentIndexPath = indexPath;
    
    [self decorateTitleWithDesc];
    [self reloadCellWithAddRoom:indexPath loadType:ShowCellData roomParam:nil];
}

- (void)reloadCellWithAddRoom:(NSIndexPath *)indexPath loadType:(LoadDataType)type roomParam:(NSString *)roomParam
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                if (type == ShowCellData) {
                    if (![CustomStringUtils isBlankString:self.room.homeName]) {
                        descTextField.text = self.room.homeName;
                    } else {
                        descTextField.text = @"";
                    }
                } else {
                    if (![CustomStringUtils isBlankString:roomParam]) {
                        self.room.homeName = roomParam;
                    }
                }
            }
                break;
                
            case 1:
            {
                if (type == ShowCellData) {
                    if (![CustomStringUtils isBlankString:self.room.status]) {
                        NSString *status;
                        if ([self.room.status isEqualToString:@"RENT_ING"]) {
                            status = @"出租中";
                        } else if ([self.room.status isEqualToString:@"IDLE_ING"]) {
                            status = @"闲置中";
                        } else {
                            status = @"未打扫";
                        }
                        descTextField.text = status;
                    } else {
                        descTextField.text = @"";
                    }
                }
            }
                break;
                
            case 2:
            {
                if (type == ShowCellData) {
                    if (self.room.monthlyRent > 0) {
                        descTextField.text = [NSString stringWithFormat:@"%ld", (long) self.room.monthlyRent];
                    } else {
                        descTextField.text = @"";
                    }
                } else {
                    if (![CustomStringUtils isBlankString:roomParam]) {
                        self.room.monthlyRent = [roomParam intValue];
                    }
                }
            }
                break;
                
            case 3:
            {
                if (type == ShowCellData) {
                    if (self.room.deposit > 0) {
                        descTextField.text = [NSString stringWithFormat:@"%ld", (long)self.room.deposit];
                    } else {
                        descTextField.text = @"";
                    }
                } else {
                    if (![CustomStringUtils isBlankString:roomParam]) {
                        self.room.deposit = [roomParam intValue];
                    }
                }
            }
                break;
                
            case 4:
            {
                if (type == ShowCellData) {
                    if ([self.room.expDate integerValue] > 0) {
                        NSString *expDateString = [CustomTimeUtils changeIntervalToDate:self.room.expDate];
                        descTextField.text = expDateString;
                    } else {
                        descTextField.text = @"";
                    }
                }
            }
                break;
                
            case 5:
            {
                if (type == ShowCellData) {
                    if (![CustomStringUtils isBlankString:self.room.deliverCategory]) {
                        descTextField.text = self.room.deliverCategory;
                    } else {
                        descTextField.text = @"";
                    }
                }
            }
                break;
                
            case 6:
            {
                if (type == ShowCellData) {
                    if (self.room.tanantNumber > 0) {
                        descTextField.text = [NSString stringWithFormat:@"%ld", (long)self.room.tanantNumber];
                    } else {
                        descTextField.text = @"";
                    }
                }
            }
                break;
                
            case 7:
            {
                if (type == ShowCellData) {
                    if (![CustomStringUtils isBlankString:self.room.rentCategory]) {
                        NSString *category;
                        if ([self.room.rentCategory isEqualToString:@"ALL"]) {
                            category = @"整租";
                        } else if ([self.room.rentCategory isEqualToString:@"ROOMMATE"]) {
                            category = @"合租";
                        }
                        descTextField.text = category;
                    } else {
                        descTextField.text = @"";
                    }
                }
            }
                break;
                
            default:
                break;
        }
        
    } else if (indexPath.section == 1) {
        
    } else if (indexPath.section == 2) {
        
    }
}

- (void)loadAddDeviceWithIndexPath:(NSIndexPath *)indexPath
{
    currentIndexPath = indexPath;
    
    [self decorateTitleWithDesc];
    
    [self reloadAddDeviceCellWithIndexPath:indexPath loadType:ShowCellData deviceParam:nil];
}

- (void)reloadAddDeviceCellWithIndexPath:(NSIndexPath *)indexPath loadType:(LoadDataType)type deviceParam:(NSString *)deviceParam
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                if (type == ShowCellData) {
                    if (![CustomStringUtils isBlankString:self.deviceInfo.name]) {
                        descTextField.text = self.deviceInfo.name;
                    } else {
                        descTextField.text = @"";
                    }
                } else {
                    if (![CustomStringUtils isBlankString:deviceParam]) {
                        self.deviceInfo.name = deviceParam;
                    }
                }
            }
                break;
                
            case 1:
            {
                if (type == ShowCellData) {
                    if (![CustomStringUtils isBlankString:self.deviceInfo.model]) {
                        descTextField.text = self.deviceInfo.model;
                    } else {
                        descTextField.text = @"";
                    }
                } else {
                    if (![CustomStringUtils isBlankString:deviceParam]) {
                        self.deviceInfo.model = deviceParam;
                    }
                }
            }
                break;
                
            case 2:
            {
                if (type == ShowCellData) {
                    if (self.deviceInfo.isHomeOwner) {
                        if (self.deviceInfo.isHomeOwner) {
                            descTextField.text = @"房东归属";
                        } else {
                            descTextField.text = @"非房东归属";
                        }
                    } else {
                        descTextField.text = @"";
                    }
                }
            }
                break;
                
            case 3:
            {
                if (type == ShowCellData) {
                    if (self.deviceInfo.amount > 0) {
                        descTextField.text = [NSString stringWithFormat:@"%ld", (long)self.deviceInfo.amount];
                    } else {
                        descTextField.text = @"";
                    }
                } else {
                    if (![CustomStringUtils isBlankString:deviceParam]) {
                        self.deviceInfo.amount = [deviceParam integerValue];
                    }
                }
            }
                break;
                
            case 4:
            {
                if (type == ShowCellData) {
                    if ([self.deviceInfo.payDate integerValue] > 0) {
                        descTextField.text = [CustomTimeUtils changeIntervalToDate:self.deviceInfo.payDate];
                    } else {
                        descTextField.text = @"";
                    }
                }
            }
                break;
                
            case 5:
            {
                if (type == ShowCellData) {
                    if (![CustomStringUtils isBlankString:self.deviceInfo.mark]) {
                        descTextField.text = self.deviceInfo.mark;
                    } else {
                        descTextField.text = @"";
                    }
                } else {
                    if (![CustomStringUtils isBlankString:deviceParam]) {
                        self.deviceInfo.mark = deviceParam;
                    }
                }
            }
                break;
                
            default:
                break;
        }
    }
}


- (void)loadAddUserCellWithIndexPath:(NSIndexPath *)indexPath
{
    currentIndexPath = indexPath;
    
    [self decorateTitleWithDesc];
    
    [self reloadAddApartmentUserCellWithIndexPath:currentIndexPath loadType:ShowCellData userParam:nil];
}

- (void)reloadAddApartmentUserCellWithIndexPath:(NSIndexPath *)indexPath loadType:(LoadDataType)type userParam:(NSString *)userParam
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                if (type == ShowCellData) {
                    if (![CustomStringUtils isBlankString:self.apartmentUser.name]) {
                        descTextField.text = self.apartmentUser.name;
                    } else {
                        descTextField.text = @"";
                    }
                } else {
                    if (![CustomStringUtils isBlankString:userParam]) {
                        self.apartmentUser.name = userParam;
                    }
                }
            }
                break;
                
            case 1:
            {
                if (type == ShowCellData) {
                    if (![CustomStringUtils isBlankString:self.apartmentUser.userSex]) {
                        descTextField.text = self.apartmentUser.userSex;
                    } else {
                        descTextField.text = @"";
                    }
                }
            }
                break;
                
            case 2:
            {
                if (type == ShowCellData) {
                    if (![CustomStringUtils isBlankString:self.apartmentUser.phone]) {
                        descTextField.text = self.apartmentUser.phone;
                    } else {
                        descTextField.text = @"";
                    }
                } else {
                    if (![CustomStringUtils isBlankString:userParam]) {
                        self.apartmentUser.phone = userParam;
                    }
                }
            }
                break;
                
            case 3:
            {
                if (type == ShowCellData) {
                    if (![CustomStringUtils isBlankString:self.apartmentUser.numberId]) {
                        descTextField.text = self.apartmentUser.numberId;
                    } else {
                        descTextField.text = @"";
                    }
                } else {
                    if (![CustomStringUtils isBlankString:userParam]) {
                        self.apartmentUser.numberId = userParam;
                    }
                }
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)loadApartmentUserListCellWithIndexPath:(NSIndexPath *)indexPath
{
    currentIndexPath = indexPath;
    
    [self decorateTitleWithDesc];
    
    if (self.isSelect) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)loadAddApartmentCellWithIndexPath:(NSIndexPath *)indexPath
{
    currentIndexPath = indexPath;
    
    [self decorateTitleWithDesc];
    
    [self reloadCellWithAddApartment:currentIndexPath loadType:ShowCellData apartmentParam:nil];
}

- (void)reloadCellWithAddApartment:(NSIndexPath *)indexPath loadType:(LoadDataType)type apartmentParam:(NSString *)apartmentParam
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                if (type == ShowCellData) {
                    if (![CustomStringUtils isBlankString:self.apartment.apartmentName]) {
                        descTextField.text = self.apartment.apartmentName;
                    } else {
                        descTextField.text = @"";
                    }
                } else {
                    if (![CustomStringUtils isBlankString:apartmentParam]) {
                        self.apartment.apartmentName = apartmentParam;
                    }
                }
            }
                break;
            case 1:
            {
                if (![CustomStringUtils isBlankString:self.apartment.category]) {
                    NSString *category;
                    if ([self.apartment.category isEqualToString:@"CONCENTRATED"]) {
                        category = @"集中式";
                    } else if ([self.apartment.category isEqualToString:@"DISPERSION"]) {
                        category = @"分散式";
                    } else {
                        category = @"酒店";
                    }
                    descTextField.text = category;
                } else {
                    descTextField.text = @"";
                }
            }
                break;
                
            case 2:
            {
                if (type == ShowCellData) {
                    if (![CustomStringUtils isBlankString:self.apartment.managerPhone]) {
                        descTextField.text = self.apartment.managerPhone;
                    } else {
                        descTextField.text = @"";
                    }
                } else {
                    if (![CustomStringUtils isBlankString:apartmentParam]) {
                        self.apartment.managerPhone = apartmentParam;
                    }
                }
            }
                break;
                
            case 3:
            {
                if (![CustomStringUtils isBlankString:self.apartment.cityId]) {
                    descTextField.text = self.apartment.cityId;
                } else {
                    descTextField.text = @"";
                }
                break;
            }
                
            case 4:
            {
                if (type == ShowCellData) {
                    if (![CustomStringUtils isBlankString:self.apartment.roadName]) {
                        descTextField.text = self.apartment.roadName;
                    } else {
                        descTextField.text = @"";
                    }
                } else {
                    if (![CustomStringUtils isBlankString:apartmentParam]) {
                        self.apartment.roadName = apartmentParam;
                    }
                }
                break;
            }
            case 5:
            {
                if (type == ShowCellData) {
                    if (![CustomStringUtils isBlankString:self.apartment.communityName]) {
                        descTextField.text = self.apartment.communityName;
                    } else {
                        descTextField.text = @"";
                    }
                } else {
                    if (![CustomStringUtils isBlankString:apartmentParam]) {
                        self.apartment.communityName = apartmentParam;
                    }
                }
                break;
            }
                
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                if (type == ShowCellData) {
                    if (self.apartment.waterPrice > 0) {
                        descTextField.text = [NSString stringWithFormat:@"%.2f", self.apartment.waterPrice];
                    } else {
                        descTextField.text = @"";
                    }
                } else {
                    if (![CustomStringUtils isBlankString:apartmentParam]) {
                        self.apartment.waterPrice = [apartmentParam floatValue];
                    }
                }
            }
                break;
            case 1:
            {
                if (type == ShowCellData) {
                    if (self.apartment.electricityPrice > 0) {
                        descTextField.text = [NSString stringWithFormat:@"%.2f", self.apartment.electricityPrice] ;
                    } else {
                        descTextField.text = @"";
                    }
                } else {
                    if (![CustomStringUtils isBlankString:apartmentParam]) {
                        self.apartment.electricityPrice = [apartmentParam floatValue];
                    }
                }
                
            }
                break;
                
            case 2:
            {
                if (type == ShowCellData) {
                    if (self.apartment.gasPrice > 0) {
                        descTextField.text = [NSString stringWithFormat:@"%.2f",self.apartment.gasPrice];
                    } else {
                        descTextField.text = @"";
                    }
                } else {
                    if (![CustomStringUtils isBlankString:apartmentParam]) {
                        self.apartment.gasPrice = [apartmentParam floatValue];
                    }
                }
            }
                break;
                
            default:
                break;
        }
    }

}

- (void)loadAddDecorateCellWithIndexPath:(NSIndexPath *)indexPath
{
    currentIndexPath = indexPath;
    
    [self decorateTitleWithDesc];
}

- (void)loadAddExpendCellWithIndexPath:(NSIndexPath *)indexPath
{
    currentIndexPath = indexPath;
    
    [self decorateTitleWithDesc];
    
    [self reloadCellWithAddExpend:indexPath loadType:ShowCellData expendParam:nil];
}

- (void)reloadCellWithAddExpend:(NSIndexPath *)indexPath loadType:(LoadDataType)type expendParam:(NSString *)expendParam
{
    switch (indexPath.row) {
        case 0:
        {
            if (![CustomStringUtils isBlankString:self.expendInfo.category]) {
                NSString *category;
                if ([self.expendInfo.category isEqualToString:@"MAINTAIN"]) {
                    category = @"维修";
                } else {
                    category = @"装修";
                }
                descTextField.text = category;
            } else {
                descTextField.text = @"";
            }
        }
            break;
        case 1:
        {
            if (![CustomStringUtils isBlankString:self.expendInfo.status]) {
                NSString *status;
                if ([self.expendInfo.status isEqualToString:@"ING"]) {
                    status = @"进行中";
                } else {
                    status = @"已完成";
                }
                descTextField.text = status;
            } else {
                descTextField.text = @"";
            }
        }
            break;
            
        case 2:
        {
            if (type == ShowCellData) {
                if (self.expendInfo.amount > 0) {
                    descTextField.text = [NSString stringWithFormat:@"%ld", (long)self.expendInfo.amount];
                } else {
                    descTextField.text = @"";
                }
            } else {
                if (![CustomStringUtils isBlankString:expendParam]) {
                    self.expendInfo.amount = [expendParam floatValue];
                }
            }
        }
            break;
            
        case 3:
        {
            if ([self.expendInfo.successDate integerValue]> 0) {
                NSString *dateString = [CustomTimeUtils changeIntervalToDate:self.expendInfo.successDate];
                descTextField.text = dateString;
            } else {
                descTextField.text = @"";
            }
            break;
        }
            
        case 4:
        {
            if (type == ShowCellData) {
                if (![CustomStringUtils isBlankString:self.expendInfo.mark]) {
                    descTextField.text = self.expendInfo.mark;
                } else {
                    descTextField.text = @"";
                }
            } else {
                if (![CustomStringUtils isBlankString:expendParam]) {
                    self.expendInfo.mark = expendParam;
                }
            }
            break;
        }
            
        default:
            break;
    }
}

- (void)loadAddWaterCellWithIndexPath:(NSIndexPath *)indexPath
{
    [self decorateTitleWithDesc];
    
    [self reloadCellWithAddWater:indexPath loadType:ShowCellData waterParam:nil];
}

- (void)reloadCellWithAddWater:(NSIndexPath *)indexPath loadType:(LoadDataType)type waterParam:(NSString *)waterParam
{
    switch (indexPath.row) {
        case 0:
        {
            if (type == ShowCellData) {
                if (![CustomStringUtils isBlankString:self.water.mark]) {
                    descTextField.text = self.water.mark;
                } else {
                    descTextField.text = @"";
                }
            } else {
                if (![CustomStringUtils isBlankString:waterParam]) {
                    self.water.mark = waterParam;
                }
            }
        }
            break;
        case 1:
        {
            if (type == ShowCellData) {
                if (self.water.currentNumber > 0) {
                    descTextField.text = [NSString stringWithFormat:@"%ld", (long)self.water.currentNumber];
                } else {
                    descTextField.text = @"";
                }
            } else {
                if (![CustomStringUtils isBlankString:waterParam]) {
                    self.water.currentNumber = [waterParam integerValue];
                }
            }
        }
            break;
            
        default:
            break;
    }
}


- (void)loadAddElecCellWithIndexPath:(NSIndexPath *)indexPath
{
    [self decorateTitleWithDesc];
    
    [self reloadCellWithAddElec:indexPath loadType:ShowCellData waterParam:nil];
}

- (void)reloadCellWithAddElec:(NSIndexPath *)indexPath loadType:(LoadDataType)type waterParam:(NSString *)elecParam
{
    switch (indexPath.row) {
        case 0:
        {
            if (type == ShowCellData) {
                if (![CustomStringUtils isBlankString:self.elec.mark]) {
                    descTextField.text = self.elec.mark;
                } else {
                    descTextField.text = @"";
                }
            } else {
                if (![CustomStringUtils isBlankString:elecParam]) {
                    self.elec.mark = elecParam;
                }
            }
            
        }
            break;
        case 1:
        {
            if (type == ShowCellData) {
                if (self.elec.currentNumber > 0) {
                    descTextField.text = [NSString stringWithFormat:@"%ld", (long)self.elec.currentNumber];
                } else {
                    descTextField.text = @"";
                }
            } else {
                if (![CustomStringUtils isBlankString:elecParam]) {
                    self.elec.currentNumber = [elecParam integerValue];
                }
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)loadAddGasCellWithIndexPath:(NSIndexPath *)indexPath
{
    [self decorateTitleWithDesc];
    
    [self reloadCellWithAddGas:indexPath loadType:ShowCellData gasParam:nil];
    
}

- (void)reloadCellWithAddGas:(NSIndexPath *)indexPath loadType:(LoadDataType)type gasParam:(NSString *)gasParam
{
    switch (indexPath.row) {
        case 0:
        {
            if (type == ShowCellData) {
                if (![CustomStringUtils isBlankString:self.gas.mark]) {
                    descTextField.text = self.gas.mark;
                } else {
                    descTextField.text = @"";
                }
            } else {
                if (![CustomStringUtils isBlankString:gasParam]) {
                    self.gas.mark = gasParam;
                }
            }
            
        }
            break;
        case 1:
        {
            if (type == ShowCellData) {
                if (self.gas.currentNumber > 0) {
                    descTextField.text = [NSString stringWithFormat:@"%ld", (long)self.gas.currentNumber];
                } else {
                    descTextField.text = @"";
                }
            } else {
                if (![CustomStringUtils isBlankString:gasParam]) {
                    self.gas.currentNumber = [gasParam integerValue];
                }
            }
        }
            break;
            
        default:
            break;
    }
}


- (void)loadAddHourseHolderWithIndexPath:(NSIndexPath *)indexPath
{
    [self decorateTitleWithDesc];
    
    [self reloadCellWithAddHourseHolder:indexPath loadType:ShowCellData hourseParam:nil];
}

- (void)reloadCellWithAddHourseHolder:(NSIndexPath *)indexPath loadType:(LoadDataType)type hourseParam:(NSString *)hourseParam
{
    switch (indexPath.row) {
        case 0:
        {
            if (type == ShowCellData) {
                if (![CustomStringUtils isBlankString:self.owner.name]) {
                    descTextField.text = self.owner.name;
                } else {
                    descTextField.text = @"";
                }
            } else {
                if (![CustomStringUtils isBlankString:hourseParam]) {
                    self.owner.name = hourseParam;
                }
            }
        }
            break;
        case 1:
        {
            if (type == ShowCellData) {
                if (![CustomStringUtils isBlankString:self.owner.phone]) {
                    descTextField.text = self.owner.phone;
                } else {
                    descTextField.text = @"";
                }
            } else {
                if (![CustomStringUtils isBlankString:hourseParam]) {
                    self.owner.phone = hourseParam;
                }
            }
        }
            break;
            
        case 2:
        {
            if (type == ShowCellData) {
                if (![CustomStringUtils isBlankString:self.owner.address]) {
                    descTextField.text = self.owner.address;
                } else {
                    descTextField.text = @"";
                }
            } else {
                if (![CustomStringUtils isBlankString:hourseParam]) {
                    self.owner.address = hourseParam;
                }
            }
        }
            break;
            
        case 3:
        {
            if (type == ShowCellData) {
                if ([self.owner.contractStart integerValue] > 0) {
                    descTextField.text = [CustomTimeUtils changeIntervalToDate:self.owner.contractStart];
                } else {
                    descTextField.text = @"";
                }
            }
        }
            break;
            
        case 4:
        {
            if (type == ShowCellData) {
                if ([self.owner.contractMaturity integerValue] > 0) {
                    descTextField.text = [CustomTimeUtils changeIntervalToDate:self.owner.contractMaturity];
                } else {
                    descTextField.text = @"";
                }
            }
        }
            break;
            
        case 5:
        {
            if (type == ShowCellData) {
                if (self.owner.amount > 0) {
                    descTextField.text = [NSString stringWithFormat:@"%ld", (long)self.owner.amount];
                } else {
                    descTextField.text = @"";
                }
            } else {
                if (![CustomStringUtils isBlankString:hourseParam]) {
                    self.owner.amount = [hourseParam integerValue];
                }
            }
        }
            break;
            
        case 6:
        {
            if (type == ShowCellData) {
                if (self.owner.deposit > 0) {
                    descTextField.text = [NSString stringWithFormat:@"%ld", (long)self.owner.deposit];
                } else {
                    descTextField.text = @"";
                }
            } else {
                if (![CustomStringUtils isBlankString:hourseParam]) {
                    self.owner.deposit = [hourseParam integerValue];
                }
            }
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.cellType == AddApartmentLogic) {
        [self reloadCellWithAddApartment:currentIndexPath loadType:AddCellData apartmentParam:textField.text];
        
        if ([self.delegate respondsToSelector:@selector(NITFC_addApartmentWithApartment:)]) {
            [self.delegate NITFC_addApartmentWithApartment:self.apartment];
        }
    } else if (self.cellType == AddApartmentUserLogic) {
        
        [self reloadAddApartmentUserCellWithIndexPath:currentIndexPath loadType:AddCellData userParam:textField.text];
        
        if ([self.delegate respondsToSelector:@selector(NITFC_addApartmentUser:)]) {
            [self.delegate NITFC_addApartmentUser:self.apartmentUser];
        }
        
    } else if (self.cellType == AddRoomLogic) {
        [self reloadCellWithAddRoom:currentIndexPath loadType:AddCellData roomParam:textField.text];
        if ([self.delegate respondsToSelector:@selector(NITFC_addRoomWithRoom:)]) {
            [self.delegate NITFC_addRoomWithRoom:self.room];
        }
    } else if (self.cellType == AddExpendLogic) {
        [self reloadCellWithAddExpend:currentIndexPath loadType:AddCellData expendParam:textField.text];
    } else if (self.cellType == AddWaterLogic) {
        [self reloadCellWithAddWater:currentIndexPath loadType:AddCellData waterParam:textField.text];
    } else if (self.cellType == AddElecLogic) {
        [self reloadCellWithAddElec:currentIndexPath loadType:AddCellData waterParam:textField.text];
    } else if (self.cellType == AddGasLogic) {
        [self reloadCellWithAddGas:currentIndexPath loadType:AddCellData gasParam:textField.text];
    } else if (self.cellType == AddHourseHolderLogic) {
        [self reloadCellWithAddHourseHolder:currentIndexPath loadType:AddCellData hourseParam:textField.text];
    } else if (self.cellType == AddDeviceInfoLogic) {
        [self reloadAddDeviceCellWithIndexPath:currentIndexPath loadType:AddCellData deviceParam:textField.text];
    }
}



@end
