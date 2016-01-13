//
//  NormalTextViewCell.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/12.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "NormalTextViewCell.h"

@interface NormalTextViewCell () <UITextViewDelegate>
{
    UIView *borderView;
    UILabel *titleLabel;
    UILabel *sepaLabel;
    UITextView *descTextView;
    
    UILabel *placeHolderLabel;
}

@end

@implementation NormalTextViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        borderView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, MainScreenWidth - 20, 110)];
        borderView.layer.borderWidth = 1;
        borderView.layer.borderColor = RGBCOLOR(243, 243, 243).CGColor;
        borderView.backgroundColor = [UIColor whiteColor];
        [self addSubview:borderView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 48, 60, 14)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:14.f];
        [borderView addSubview:titleLabel];
        
        sepaLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame) + 4, 48, 0.5, 14.f)];
        sepaLabel.backgroundColor = [UIColor blackColor];
        [borderView addSubview:sepaLabel];
        
        descTextView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame) + 10, 15.5, CGRectGetWidth(borderView.bounds) - 10 - 10 - CGRectGetMaxX(titleLabel.frame), 79)];
        descTextView.delegate = self;
        descTextView.font = [UIFont systemFontOfSize:14.f];
        [borderView addSubview:descTextView];
        
        placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(descTextView.frame), (CGRectGetHeight(borderView.bounds) - 13) / 2, CGRectGetWidth(descTextView.bounds), 13)];
        placeHolderLabel.font = [UIFont systemFontOfSize:13];
        placeHolderLabel.textColor = [CustomColorUtils colorWithHexString:@"#888888"];
        [borderView addSubview:placeHolderLabel];
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

- (void)loadNormalTextViewCell
{
    titleLabel.text = self.title;
    placeHolderLabel.text = self.placeHolderTitle;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (![CustomStringUtils isBlankString:textView.text]) {
        placeHolderLabel.hidden = YES;
    } else {
        placeHolderLabel.hidden = NO;
    }
}

@end
