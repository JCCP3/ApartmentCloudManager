//
//  CrashManager.h
//  TestCrash
//
//  Created by song on 12-12-28.
//  Copyright (c) 2012年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrashManager : NSObject
+(CrashManager*)sharedManager;
-(void)run;
@end
