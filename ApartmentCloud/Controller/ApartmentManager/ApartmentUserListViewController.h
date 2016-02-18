//
//  ApartmentUserListViewController.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/24.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"
#import "ApartmentUser.h"

@protocol ApartmentUserListDelegate <NSObject>

@optional
- (void)AULD_passApartmentUser:(NSMutableArray *)aryApartmentUser;

@end

@interface ApartmentUserListViewController : BaseViewController

@property (nonatomic, assign) id<ApartmentUserListDelegate> delegate;

@end
