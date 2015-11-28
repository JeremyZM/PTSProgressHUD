//
//  HttpManage.m
//  ZJDL
//
//  Created by 黄杰 on 15/4/24.
//  Copyright (c) 2015年 &#40644;&#26480;. All rights reserved.
//

#import "HttpManage.h"
#import "AFNetworking.h"

@implementation HttpManage

#pragma mark - 获取管理对象
+ (AFHTTPRequestOperationManager *)setupHttpManage
{
    // 创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 说明服务器返回json数据
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/javascript", @"text/json", nil];
    
    return mgr;
}

#pragma mark - 发送POST请求
+ (void)PostWithURL:(NSString *)URL parameters:(NSDictionary *)parameters success:(void (^)(id json))success failure:(void (^)(NSError * error))failure
{
    // 获取管理对象
    AFHTTPRequestOperationManager *mgr = [self setupHttpManage];
    
    [mgr POST:URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 成功则返回json
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 失败则返回失败信息
        failure(error);
        
    }];
}

#pragma mark - 发送GET请求
+ (void)GetWithURL:(NSString *)URL parameters:(NSDictionary *)parameters success:(void (^)(id json))success failure:(void (^)(NSError * error))failure
{
    // 获取管理对象
    AFHTTPRequestOperationManager *mgr = [self setupHttpManage];
    
    [mgr GET:URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 成功则返回json
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 失败则返回失败信息
        failure(error);
        
    }];
    
}

#pragma mark - 上传图片
+ (void)PostWithURL:(NSString *)URL parameters:(NSDictionary *)parameters formDataArray:(NSArray *)formDataArray success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 获取管理对象
    AFHTTPRequestOperationManager *mgr = [self setupHttpManage];
    
    [mgr POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> totalformData) {
        
        for (MyFormData *formData in formDataArray) {
            [totalformData appendPartWithFileData:formData.data name:formData.name fileName:formData.fileName mimeType:formData.mimeType];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (error) {
            failure(error);
        }
        
    }];
}

@end

@implementation MyFormData

@end
