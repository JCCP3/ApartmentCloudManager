//
//  ApartmentCell.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/10.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "ApartmentCell.h"

@interface ApartmentCell ()
{
    UILabel *roomNumLabel;
    UIImageView *roomImageView;
}

@end

@implementation ApartmentCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = AppThemeColor;
        roomNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 50, 60)];
        roomNumLabel.font = [UIFont systemFontOfSize:13.f];
        roomNumLabel.textColor = [UIColor whiteColor];
        [self addSubview:roomNumLabel];
        
        roomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(roomNumLabel.frame) + 5, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [self addSubview:roomImageView];
    }
    return self;
}

- (void)loadApartmentCellData
{
    
}


@end
