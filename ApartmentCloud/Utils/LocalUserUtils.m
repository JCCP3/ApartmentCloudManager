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
    [localUserInfoDic setObject:[jsonDic objectForKey:@""] forKey:@"userId"];
    [localUserInfoDic setObject:[jsonDic objectForKey:@""] forKey:@"userName"];
    [localUserInfoDic setObject:[jsonDic objectForKey:@""] forKey:@""];
    
    [UserDefaults setObject:localUserInfoDic forKey:LocalUserInfo];
    [UserDefaults synchronize];
}

+ (void)updateLocalUserInfo:(NSDictionary *)jsonDic
{
    NSMutableDictionary *localUserInfoDic = [NSMutableDictionary dictionaryWithDictionary:[UserDefaults objectForKey:LocalUserInfo]];
    
    [localUserInfoDic setObject:@"" forKey:@""];
}

+ (void)removeLocalUserInfo
{
    [UserDefaults removeObjectForKey:LocalUserInfo];
}

+ (NSString *)getUserId
{
    NSMutableDictionary *localUserInfoDic = [UserDefaults objectForKey:LocalUserInfo];
    return localUserInfoDic ? [localUserInfoDic objectForKey:@""] : @"";
}

+ (NSString *)getUsername
{
    NSMutableDictionary *localUserInfoDic = [UserDefaults objectForKey:LocalUserInfo];
    return localUserInfoDic ? [localUserInfoDic objectForKey:@""] : @"";
}

+ (BOOL)userLoggedIn
{
    if ([UserDefaults objectForKey:LocalUserInfo]) {
        return YES;
    }
    return NO;
}

@end
