//
//  ExpendCell.m
//  ApartmentCloud
//
//  Created by Rose on 16/2/20.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "ExpendCell.h"

@interface ExpendCell ()
{
    UILabel *firstLineLabel;
    UILabel *payLabel;
    UILabel *markLabel;
    UILabel *dateLabel;
}

@end

@implementation ExpendCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        firstLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth - 20, 16)];
        firstLineLabel.font = [UIFont systemFontOfSize:16.f];
        [self.contentView addSubview:firstLineLabel];
        
        payLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(firstLineLabel.frame) + 10, MainScreenWidth - 20, 15)];
        payLabel.font = [UIFont systemFontOfSize:15.f];
        [self.contentView addSubview:payLabel];
        
        markLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(payLabel.frame) + 10, MainScreenWidth - 20, 15)];
        markLabel.font = [UIFont systemFontOfSize:15.f];
        [self.contentView addSubview:markLabel];
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(markLabel.frame) + 10, MainScreenWidth - 20, 13)];
        dateLabel.font = [UIFont systemFontOfSize:13.f];
        [self.contentView addSubview:dateLabel];
    }
    
    return self;
}

- (void)loadExpendCellData:(ExpendInfo *)expendInfo
{
    
}

@end
