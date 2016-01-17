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
    UIView *borderView;
    UILabel *titleLabel;
    UILabel *sepaLabel;
}

@end

@implementation NormalInputTextFieldCell
@synthesize descTextField;

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

- (void)loadNormalInputTextFieldCellData:(Apartment *)apartment withIndexPath:(NSIndexPath *)indexPath
{
    self.apartment = apartment;
    
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
    
    [self reloadApartmenCell:indexPath];
}

- (void)reloadApartmenCell:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                if (![CustomStringUtils isBlankString:self.apartment.title]) {
                    descTextField.text = self.apartment.title;
                }
            }
                break;
                
            case 1:
            {
                if (![CustomStringUtils isBlankString:self.apartment.type]) {
                    descTextField.text = self.apartment.type;
                }
            }
                break;
                
            case 2:
            {
                if (![CustomStringUtils isBlankString:self.apartment.phone]) {
                    descTextField.text = self.apartment.phone;
                }
            }
                break;
                
            case 3:
            {
                if (![CustomStringUtils isBlankString:self.apartment.region]) {
                    descTextField.text = self.apartment.region;
                }
                break;
            }
               
            case 4:
            {
                if (![CustomStringUtils isBlankString:self.apartment.roadName]) {
                    descTextField.text = self.apartment.roadName;
                }
                break;
            }
                
            case 5:
            {
                if (![CustomStringUtils isBlankString:self.apartment.parcelTitle]) {
                    descTextField.text = self.apartment.parcelTitle;
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
                if (![CustomStringUtils isBlankString:self.apartment.waterPay]) {
                    descTextField.text = self.apartment.waterPay;
                }
            }
                break;
                
            case 1:
            {
                if (![CustomStringUtils isBlankString:self.apartment.elecPay]) {
                    descTextField.text = self.apartment.elecPay;
                }
            }
                break;
                
            case 2:
            {
                if (![CustomStringUtils isBlankString:self.apartment.gasPay]) {
                    descTextField.text = self.apartment.gasPay;
                }
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

@end
