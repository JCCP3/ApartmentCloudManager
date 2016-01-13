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
    UITextField *descTextField;
}

@end

@implementation NormalInputTextFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        borderView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, MainScreenWidth - 20, 45)];
        borderView.layer.borderWidth = 1;
        borderView.layer.borderColor = [CustomColorUtils colorWithHexString:@"#f7f7f7"].CGColor;
        borderView.backgroundColor = [UIColor whiteColor];
        borderView.tag = 10086;
        [self addSubview:borderView];
        
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

- (void)loadNormalInputTextFieldCellData:(Apartment *)apartment
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
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

@end
