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
        
        roomNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 50, 13)];
        roomNumLabel.font = [UIFont systemFontOfSize:13.f];
        roomNumLabel.textAlignment = NSTextAlignmentCenter;
        roomNumLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:roomNumLabel];
        
        roomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(roomNumLabel.frame) + 5, 9, 20)];
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
        roomNumLabel.hidden = NO;
        roomImageView.hidden = NO;
        addRoomImageView.hidden = YES;
        self.backgroundColor = AppThemeColor;
    }
    
    if (![CustomStringUtils isBlankString:room.homeName]) {
        roomNumLabel.text = room.homeName;
    }
    
    if (room.tanantNumber > 0) {
        UIImage *img = nil;
        if (room.tanantNumber == 1) {
            img = ImageNamed(@"apartment_person.png");
            roomImageView.frame = CGRectMake((50 - 9) / 2, CGRectGetMinY(roomImageView.frame), 9, 20);
        } else if (room.tanantNumber == 2) {
            img = ImageNamed(@"apartment_TwoPerson.png");
            roomImageView.frame = CGRectMake((50 - 23) / 2, CGRectGetMinY(roomImageView.frame), 23, 20);
        } else if (room.tanantNumber >= 3) {
            img = ImageNamed(@"apartment_ThreePerson.png");
            roomImageView.frame = CGRectMake((50 - 33) / 2, CGRectGetMinY(roomImageView.frame), 33, 20);
        }
        
        if (img) {
            [roomImageView setImage:img];
        }
    }
}


@end
