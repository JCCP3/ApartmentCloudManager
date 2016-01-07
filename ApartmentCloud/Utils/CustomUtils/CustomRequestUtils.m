//
//  CustomRequestUtils.m
//  YouShaQi
//
//  Created by 蔡三泽 on 15/8/19.
//  Copyright (c) 2015年 HangZhou RuGuo Network Technology Co.Ltd. All rights reserved.
//

#import "CustomRequestUtils.h"

@implementation CustomRequestUtils

//新的HTML GET请求
+ (AFHTTPRequestOperation *)createHTMLRequest:(NSString *)urlStr
                                      success:(void (^)(AFHTTPRequestOperation *operation, NSString *responseString))successBlock
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *finalStr;
    if ([urlStr rangeOfString:@"http://"].length > 0 && [urlStr rangeOfString:@"http://"].location == 0) {
        finalStr = urlStr;
    } else {
        finalStr = [NSString stringWithFormat:@"%@%@", [CustomUrlUtils getGlobalUrlPre], urlStr];
    }
    NSMutableURLRequest *urlReq = [manager.requestSerializer requestWithMethod:@"GET"
                                                                     URLString:finalStr
                                                                    parameters:nil
                                                                         error:nil];
    [urlReq setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [urlReq setTimeoutInterval:25];
    [self setCustomRquestHeaderWithRequest:urlReq];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:urlReq
                                                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                             successBlock(operation, [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                                                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                             failureBlock(operation, error);
                                                                         }];
    
    operation.responseSerializer = [AFCompoundResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [operation.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/html", @"text/vnd.wap.wml"]];
    [operation start];
    return operation;
}

//新的GET请求
+ (AFHTTPRequestOperation *)createNewRequest:(NSString *)urlStr
                                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *finalStr;
    if ([urlStr rangeOfString:@"http://"].length > 0 && [urlStr rangeOfString:@"http://"].location == 0) {
        finalStr = urlStr;
    } else {
        finalStr = [NSString stringWithFormat:@"%@%@", [CustomUrlUtils getGlobalUrlPre], urlStr];
    }
    NSMutableURLRequest *urlReq = [manager.requestSerializer requestWithMethod:@"GET"
                                                                     URLString:finalStr
                                                                    parameters:nil
                                                                         error:nil];
    [urlReq setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [urlReq setTimeoutInterval:25];
    [self setCustomRquestHeaderWithRequest:urlReq];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:urlReq
                                                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                             successBlock(operation, responseObject);
                                                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                             failureBlock(operation, error);
                                                                         }];
    
    operation.responseSerializer.acceptableContentTypes = [operation.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/html", @"text/vnd.wap.wml"]];
    [operation start];
    return operation;
}


//新的GET请求，但不自动开始
+ (AFHTTPRequestOperation *)createPreRequest:(NSString *)urlStr
                                     success:(void (^)(id responseObject))success
                                     failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *finalStr;
    if ([urlStr rangeOfString:@"http://"].length > 0 && [urlStr rangeOfString:@"http://"].location == 0) {
        finalStr = urlStr;
    } else {
        finalStr = [NSString stringWithFormat:@"%@%@", [CustomUrlUtils getGlobalUrlPre], urlStr];
    }
    NSMutableURLRequest *urlReq = [manager.requestSerializer requestWithMethod:@"GET"
                                                                     URLString:finalStr
                                                                    parameters:nil
                                                                         error:nil];
    [urlReq setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [urlReq setTimeoutInterval:25];
    [self setCustomRquestHeaderWithRequest:urlReq];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:urlReq
                                                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                             success(responseObject);
                                                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                             failure(error);
                                                                         }];
    operation.responseSerializer.acceptableContentTypes = [operation.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/html", @"text/vnd.wap.wml"]];
    return operation;
}

//新的POST请求
+ (void)createNewPostRequest:(NSString *)urlStr
                      params:(NSDictionary *)params
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *filnalStr;
    if ([urlStr rangeOfString:@"http://"].length > 0 && [urlStr rangeOfString:@"http://"].location == 0) {
        filnalStr = urlStr;
    } else {
        filnalStr = [NSString stringWithFormat:@"%@%@", [CustomUrlUtils getGlobalUrlPre], urlStr];
    }
    
    NSMutableURLRequest *urlReq = [manager.requestSerializer requestWithMethod:@"POST"
                                                                     URLString:filnalStr
                                                                    parameters:params
                                                                         error:nil];
    [urlReq setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [urlReq setTimeoutInterval:25];
    [self setCustomRquestHeaderWithRequest:urlReq];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:urlReq
                                                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                             if (success) {
                                                                                 success(responseObject);
                                                                             }
                                                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                             if (failure) {
                                                                                 failure(error);
                                                                             }
                                                                         }];
    [operation start];
}

//新的MultipartFormPOST请求
+ (void)createNewMultipartFormPostRequest:(NSString *)urlStr
                             normalParams:(NSDictionary *)normalParams
                               dataParams:(NSDictionary *)dataParams
                                  success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *finalStr = [NSString stringWithFormat:@"%@%@", [CustomUrlUtils getGlobalUrlPre], urlStr];
    NSMutableURLRequest *urlReq = [manager.requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                                  URLString:finalStr
                                                                                 parameters:normalParams
                                                                  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                      [formData appendPartWithFileData:[dataParams objectForKey:@"avatar"]
                                                                                                  name:@"avatar"
                                                                                              fileName:[NSString stringWithFormat:@"avatar%.0f.jpg", [[NSDate date] timeIntervalSince1970]]
                                                                                              mimeType:[self getMimeTypeImageData:[dataParams objectForKey:@"avatar"]]];
                                                                  } error:nil];
    [urlReq setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [urlReq setTimeoutInterval:25];
    [self setCustomRquestHeaderWithRequest:urlReq];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:urlReq
                                                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                             if (success) {
                                                                                 success(responseObject);
                                                                             }
                                                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                             if (failure) {
                                                                                 failure(error);
                                                                             }
                                                                         }];
    [operation start];
}

//获取图片类型
+ (NSString *)getMimeTypeImageData:(NSData *)data
{
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

//新的POST请求，但不自动开始
+ (AFHTTPRequestOperation *)createNewPrePostRequest:(NSString *)urlStr
                                             params:(NSDictionary *)params
                                            success:(void (^)(id responseObject))success
                                            failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *filnalStr = [NSString stringWithFormat:@"%@%@", [CustomUrlUtils getGlobalUrlPre], urlStr];
    NSMutableURLRequest *urlReq = [manager.requestSerializer requestWithMethod:@"POST"
                                                                     URLString:filnalStr
                                                                    parameters:params
                                                                         error:nil];
    [urlReq setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [urlReq setTimeoutInterval:25];
    [self setCustomRquestHeaderWithRequest:urlReq];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:urlReq
                                                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                             if (success) {
                                                                                 success(responseObject);
                                                                             }
                                                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                             if (failure) {
                                                                                 failure(error);
                                                                             }
                                                                         }];
    return operation;
}

+ (void)setCustomRquestHeaderWithRequest:(NSMutableURLRequest *)request
{
    [request setValue:[GlobalUtils getDeviceID] forHTTPHeaderField:@"X-Device-Id"];
}

//新的发布请求
+ (void)createNewRequestWithMethod:(NSString *)method
                            urlStr:(NSString *)urlStr
                            params:(NSDictionary *)params
                           success:(void (^)(id))success
                           failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *filnalStr;
    if ([urlStr rangeOfString:@"http://"].length > 0 && [urlStr rangeOfString:@"http://"].location == 0) {
        filnalStr = urlStr;
    } else {
        filnalStr = [NSString stringWithFormat:@"%@%@", [CustomUrlUtils getGlobalUrlPre], urlStr];
    }
    
    NSMutableURLRequest *urlReq = [manager.requestSerializer requestWithMethod:method
                                                                     URLString:filnalStr
                                                                    parameters:params
                                                                         error:nil];
    [urlReq setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [urlReq setTimeoutInterval:25];
    [self setCustomRquestHeaderWithRequest:urlReq];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:urlReq
                                                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                             if (success) {
                                                                                 success(responseObject);
                                                                             }
                                                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                             if (failure) {
                                                                                 failure(error);
                                                                             }
                                                                         }];
    [operation start];
}

@end
