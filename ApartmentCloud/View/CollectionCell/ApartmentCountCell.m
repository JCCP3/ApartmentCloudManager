//
//  ApartmentCountCell.m
//  ApartmentCloud
//
//  Created by Rose on 16/2/19.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "ApartmentCountCell.h"

@interface ApartmentCountCell ()
{
    UILabel *titleLabel;
    UILabel *descLabel;
}

@end

@implementation ApartmentCountCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.contentView.backgroundColor = [CustomColorUtils colorWithHexString:@"#39c2bd"];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 16)];
        titleLabel.font = [UIFont systemFontOfSize:16.f];
        titleLabel.textColor = [CustomColorUtils colorWithHexString:@"#ffffff"];
        [self.contentView addSubview:titleLabel];
        
        descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame) + 8, 100, 16)];
        descLabel.font = [UIFont systemFontOfSize:16.f];
        descLabel.textColor = [CustomColorUtils colorWithHexString:@"#ffffff"];
        [self.contentView addSubview:descLabel];
    }
    return self;
}

- (void)loadApartmentCountCell:(Apartment *)apartment style:(NSString *)style
{
    if ([style isEqualToString:@"first"]) {
        titleLabel.text = @"居住人数";
        descLabel.text = [NSString stringWithFormat:@"%ld人",apartment.rentCount];
    } else {
        titleLabel.text = @"空置房间数";
        descLabel.text = [NSString stringWithFormat:@"%ld间",apartment.idleCount];
    }
}

@end
