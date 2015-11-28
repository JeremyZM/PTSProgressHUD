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
+ (AFHTTPSessionManager *)setupHttpManage
{
    // 创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 说明服务器返回json数据
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/javascript", @"text/json", nil];
    
    return mgr;
}

#pragma mark - 发送POST请求
+ (void)PostWithURL:(NSString *)URL parameters:(NSDictionary *)parameters success:(void (^)(id json))success failure:(void (^)(NSError * error))failure
{
    // 获取管理对象
    AFHTTPSessionManager *mgr = [self setupHttpManage];
    
    [mgr POST:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        // 成功则返回json
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        // 失败则返回失败信息
        failure(error);
    }];

}

@end
