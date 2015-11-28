//
//  HttpManage.h
//  ZJDL
//
//  Created by 黄杰 on 15/4/24.
//  Copyright (c) 2015年 &#40644;&#26480;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpManage : NSObject
/**
 *  发送POST请求
 */
+ (void)PostWithURL:(NSString *)URL parameters:(NSDictionary *)parameters success:(void (^)(id json))success failure:(void (^)(NSError * error))failure;

@end