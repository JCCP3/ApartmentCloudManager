//
//  AddDeviceInfoViewController.h
//  ApartmentCloud
//
//  Created by Rose on 16/2/21.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"
#import "DeviceInfo.h"

@interface AddDeviceInfoViewController : BaseViewController

@property (nonatomic, strong) DeviceInfo *currentDeviceInfo;
@property (nonatomic, strong) NSString *homeId;

@end
