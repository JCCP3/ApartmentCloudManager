//
//  NSObject+CustomCategory.h
//  YouShaQi
//
//  Created by 蔡三泽 on 15/1/7.
//  Copyright (c) 2015年 HangZhou RuGuo Network Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSONDeserializing)
- (id)objectFromJSONString;
@end

@interface NSString (MD5)
- (NSString *)MD5;
@end

@interface NSData (JSONDeserializing)
- (id)objectFromJSONData;
@end