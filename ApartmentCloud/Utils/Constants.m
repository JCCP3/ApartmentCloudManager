//
//  Constants.m
//  YouShaQi
//
//  Created by admin on 12-9-7.
//  Copyright (c) 2012年 HangZhou RuGuo Network Technology Co.Ltd. All rights reserved.
//

#import "Constants.h"

@implementation Constants

NSString *const kURL_Pre_Test = @"http://42.62.64.88:8099";//测试服务器前缀
NSString *const kURL_ImagePre_Test= @"http://42.62.64.88:8099"; //测试服务器接口
NSString *const kURL_ChapterPre_Test= @"http://42.62.64.88:8282"; //测试服务器接口
  

NSString *const kURL_Pre = @"http://114.215.93.158:8080"; //线上接口
NSString *const kURL_ImagePre = @"http://statics.zhuishushenqi.com"; //线上接口
NSString *const kURL_ChapterPre = @"http://chapter.zhuishushenqi.com"; //线上接口
NSString *const kURL_ChapterPre2 = @"http://chapter2.zhuishushenqi.com"; //线上接口
NSString *const kURL_CategoryListFormat = @"/book?view=typelist&type=%@"; //新的列表接口
NSString *const kURL_ResourseListFormat = @"/toc?view=summary&book=%@"; //新的资源列表接口
NSString *const kURL_ThirdParty_ResourseListFormat = @"/aggregation-source/by-book?book=%@&v=5"; //第三方资源列表接口
NSString *const kURL_Cp_ResourseListFormat = @"/book/%@/sources"; //新的第三方资源列表接口

NSString *const kURL_Pre_Online = @"api"; //线上接口
NSString *const kURL_ImagePre_Online = @"statics"; //线上接口
NSString *const kURL_ChapterPre_Online = @"chapter"; //线上接口
NSString *const kURL_ChapterPre_Online2 = @"chapter2"; //线上接口

NSString *const kURL_BaiduDirectory = @"http://m.baidu.com/tc?appui=alaxs&ajax=1&src="; //百度优化-获取目录接口
NSString *const kURL_BaiduChapter = @"http://m.baidu.com/tc?appui=alaxs&ajax=1&src="; //百度优化-获取文章接口

@end
