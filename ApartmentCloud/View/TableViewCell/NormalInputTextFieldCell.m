//
//  NormalInputTextFieldCell.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/10.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "NormalInputTextFieldCell.h"

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
                        descTextField.text = self.room.status;
                    }
                }
            }
                break;
                
            case 2:
            {
                if (type == ShowCellData) {
                    if (self.room.monthlyRent > 0) {
                        descTextField.text = [NSString stringWithFormat:@"%ld", (long) self.room.monthlyRent];
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
                    if (![CustomStringUtils isBlankString:self.room.expDate]) {
                        descTextField.text = self.room.expDate;
                    }
                }
            }
                break;
                
            case 5:
            {
                if (type == ShowCellData) {
                    if (![CustomStringUtils isBlankString:self.room.deliverCategory]) {
                        descTextField.text = self.room.deliverCategory;
                    }
                }
            }
                break;
                
            case 6:
            {
                if (type == ShowCellData) {
                    if (self.room.tanantNumber > 0) {
                        descTextField.text = [NSString stringWithFormat:@"%ld", (long)self.room.tanantNumber];
                    }
                }
            }
                break;
                
            case 7:
            {
                if (type == ShowCellData) {
                    if (![CustomStringUtils isBlankString:self.room.rentCategory]) {
                        descTextField.text = self.room.rentCategory;
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
                    }
                }
            }
                break;
                
            case 2:
            {
                if (type == ShowCellData) {
                    if (![CustomStringUtils isBlankString:self.apartmentUser.phone]) {
                        descTextField.text = self.apartmentUser.phone;
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
                    descTextField.text = self.apartment.category;
                }
            }
                break;
                
            case 2:
            {
                if (type == ShowCellData) {
                    if (![CustomStringUtils isBlankString:self.apartment.managerPhone]) {
                        descTextField.text = self.apartment.managerPhone;
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
                }
                break;
            }
                
            case 4:
            {
                if (type == ShowCellData) {
                    if (![CustomStringUtils isBlankString:self.apartment.roadName]) {
                        descTextField.text = self.apartment.roadName;
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
                    if (![CustomStringUtils isBlankString:self.apartment.waterPrice]) {
                        descTextField.text = self.apartment.waterPrice;
                    }
                } else {
                    if (![CustomStringUtils isBlankString:apartmentParam]) {
                        self.apartment.waterPrice = apartmentParam;
                    }
                }
            }
                break;
            case 1:
            {
                if (type == ShowCellData) {
                    if (![CustomStringUtils isBlankString:self.apartment.electricityPrice]) {
                        descTextField.text = self.apartment.electricityPrice;
                    }
                } else {
                    if (![CustomStringUtils isBlankString:apartmentParam]) {
                        self.apartment.electricityPrice = apartmentParam;
                    }
                }
                
            }
                break;
                
            case 2:
            {
                if (type == ShowCellData) {
                    if (![CustomStringUtils isBlankString:self.apartment.gasPrice]) {
                        descTextField.text = self.apartment.gasPrice;
                    }
                } else {
                    if (![CustomStringUtils isBlankString:apartmentParam]) {
                        self.apartment.gasPrice = apartmentParam;
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
    }
}



@end
