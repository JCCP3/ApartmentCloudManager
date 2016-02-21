//
//  ExpendCell.m
//  ApartmentCloud
//
//  Created by Rose on 16/2/20.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "ExpendCell.h"
#import "CustomTimeUtils.h"

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
        payLabel.textColor = [UIColor lightGrayColor];
        payLabel.font = [UIFont systemFontOfSize:15.f];
        [self.contentView addSubview:payLabel];
        
        markLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(payLabel.frame) + 10, MainScreenWidth - 20, 15)];
        markLabel.textColor = [UIColor lightGrayColor];
        markLabel.font = [UIFont systemFontOfSize:15.f];
        [self.contentView addSubview:markLabel];
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(markLabel.frame) + 10, MainScreenWidth - 20, 13)];
        dateLabel.textColor = [UIColor lightGrayColor];
        dateLabel.font = [UIFont systemFontOfSize:13.f];
        [self.contentView addSubview:dateLabel];
    }
    
    return self;
}

- (void)loadExpendCellData:(ExpendInfo *)expendInfo
{
    NSString *status = [expendInfo.status isEqualToString:@"ING"] ? @"进行中" : @"已完成";
    NSString *firstLineString = [NSString stringWithFormat:@"%@  维修  %@", expendInfo.homeName, status];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:firstLineString];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(expendInfo.homeName.length + 2, 2)];
    firstLineLabel.attributedText = attributeString;
    
    payLabel.text = [NSString stringWithFormat:@"费用: %ld", (long)expendInfo.amount];
    markLabel.text = [NSString stringWithFormat:@"备注: %@", expendInfo.mark];
    dateLabel.text = [CustomTimeUtils changeIntervalToDate:expendInfo.successDate];
    
}

- (void)loadDeviceCellData:(DeviceInfo *)deviceInfo
{
    NSString *firstLineString = [NSString stringWithFormat:@"%@  %@  %@", deviceInfo.name, deviceInfo.homeName, deviceInfo.isHomeOwner ? @"[房东归属]" : @""];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:firstLineString];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(deviceInfo.name.length + 2, deviceInfo.homeName.length)];
    firstLineLabel.attributedText = attributeString;
    
    payLabel.text = [NSString stringWithFormat:@"费用: %ld", (long)deviceInfo.amount];
    markLabel.text = [NSString stringWithFormat:@"备注: %@", deviceInfo.mark];
    dateLabel.text = [CustomTimeUtils changeIntervalToDate:deviceInfo.payDate];
}

@end
