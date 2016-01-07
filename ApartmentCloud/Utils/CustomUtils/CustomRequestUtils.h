//
//  CustomRequestUtils.h
//  YouShaQi
//
//  Created by 蔡三泽 on 15/8/19.
//  Copyright (c) 2015年 HangZhou RuGuo Network Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

@interface CustomRequestUtils : NSObject

//新的HTML GET请求
+ (AFHTTPRequestOperation *)createHTMLRequest:(NSString *)urlStr
                                      success:(void (^)(AFHTTPRequestOperation *operation, NSString *responseString))successBlock
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;
//新的网络请求
+ (AFHTTPRequestOperation *)createNewRequest:(NSString *)urlStr
                                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;
//新的GET请求，但不自动开始
+ (AFHTTPRequestOperation *)createPreRequest:(NSString *)contentLink
                                     success:(void (^)(id responseObject))success
                                     failure:(void (^)(NSError *error))failure;
//新的POST请求
+ (void)createNewPostRequest:(NSString *)urlStr
                      params:(NSDictionary *)params
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;
//新的MultipartFormPOST请求
+ (void)createNewMultipartFormPostRequest:(NSString *)urlStr
                             normalParams:(NSDictionary *)normalParams
                               dataParams:(NSDictionary *)dataParams
                                  success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))failure;
//新的POST请求，但不自动开始
+ (AFHTTPRequestOperation *)createNewPrePostRequest:(NSString *)urlStr
                                             params:(NSDictionary *)params
                                            success:(void (^)(id responseObject))success
                                            failure:(void (^)(NSError *error))failure;

//新的发布请求
+ (void)createNewRequestWithMethod:(NSString *)method
                            urlStr:(NSString *)urlStr
                            params:(NSDictionary *)params
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;

@end
