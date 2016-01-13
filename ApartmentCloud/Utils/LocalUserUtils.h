//
//  LocalUserUtils.h
//  ApartmentCloud
//
//  Created by Rose on 16/1/12.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalUserUtils : NSObject

+ (void)setLocalUserInfo:(NSDictionary *)jsonDic;
+ (void)updateLocalUserInfo:(NSDictionary *)localInfoDic;

+ (void)removeLocalUserInfo;

+ (NSString *)getKeyId;
+ (NSString *)getUsername;

+ (BOOL)userLoggedIn;

@end
