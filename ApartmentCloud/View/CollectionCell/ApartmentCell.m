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
    UIImageView *addRoomImageView;
}

@end

@implementation ApartmentCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        roomNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 50, 60)];
        roomNumLabel.font = [UIFont systemFontOfSize:13.f];
        roomNumLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:roomNumLabel];
        
        roomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(roomNumLabel.frame) + 5, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [self.contentView addSubview:roomImageView];
        
        addRoomImageView = [[UIImageView alloc] initWithFrame:CGRectMake((50 - 28) / 2, (60 - 28) / 2, 28, 28)];
        [addRoomImageView setImage:ImageNamed(@"apartment_addRoom.png")];
        [self.contentView addSubview:addRoomImageView];
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = AppThemeColor.CGColor;
    }
    return self;
}

- (void)loadApartmentRoomCellData:(ApartmentRoom *)room
{
    if (!room) {
        roomNumLabel.hidden = YES;
        roomImageView.hidden = YES;
        addRoomImageView.hidden = NO;
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = AppThemeColor;
    }
}


@end
