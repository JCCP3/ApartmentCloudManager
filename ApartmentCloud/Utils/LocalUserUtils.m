//
//  LocalUserUtils.m
//  ApartmentCloud
//
//  Created by Rose on 16/1/12.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#define LocalUserInfo @"LocalUserInfo"
#import "LocalUserUtils.h"

@implementation LocalUserUtils

+ (void)setLocalUserInfo:(NSDictionary *)jsonDic
{
    [UserDefaults removeObjectForKey:LocalUserInfo];

    NSMutableDictionary *localUserInfoDic = [[NSMutableDictionary alloc] init];
    
    if ([jsonDic objectForKey:@"logon"]) {
        NSDictionary *tmpDic = [jsonDic objectForKey:@"logon"];
        [localUserInfoDic setObject:[tmpDic objectForKey:@"keyId"] forKey:@"keyId"];
        
        if ([tmpDic objectForKey:@"user"]) {
            NSDictionary *secondTmpDic = [tmpDic objectForKey:@"user"];
            [localUserInfoDic setObject:[secondTmpDic objectForKey:@"realName"] forKey:@"userName"];
            [localUserInfoDic setObject:[secondTmpDic objectForKey:@"createTime"] forKey:@"createTime"];
            [localUserInfoDic setObject:[secondTmpDic objectForKey:@"userAccount"] forKey:@"account"];
        }
    }
    
    [UserDefaults setObject:localUserInfoDic forKey:LocalUserInfo];
    [UserDefaults synchronize];
}

+ (void)updateLocalUserInfo:(NSDictionary *)jsonDic
{
    
}

+ (void)removeLocalUserInfo
{
    [UserDefaults removeObjectForKey:LocalUserInfo];
}

+ (NSString *)getKeyId
{
    NSMutableDictionary *localUserInfoDic = [UserDefaults objectForKey:LocalUserInfo];
    return localUserInfoDic ? [localUserInfoDic objectForKey:@"keyId"] : @"";
}

+ (NSString *)getUsername
{
    NSMutableDictionary *localUserInfoDic = [UserDefaults objectForKey:LocalUserInfo];
    return localUserInfoDic ? [localUserInfoDic objectForKey:@"userName"] : @"";
}

+ (BOOL)userLoggedIn
{
    if ([UserDefaults objectForKey:LocalUserInfo]) {
        return YES;
    }
    return NO;
}

@end
