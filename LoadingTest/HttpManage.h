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

/**
 *  发送GET请求
 */
+ (void)GetWithURL:(NSString *)URL parameters:(NSDictionary *)parameters success:(void (^)(id json))success failure:(void (^)(NSError * error))failure;

/**
 *  上传图片
 */
+ (void)PostWithURL:(NSString *)URL parameters:(NSDictionary *)parameters formDataArray:(NSArray *)formDataArray success:(void (^)(id json))success failure:(void (^)(NSError * error))failure;
@end

@interface MyFormData : NSObject
/**
 *  图片数据
 */
@property (nonatomic, strong) NSData *data;
/**
 *  参数名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  文件名称
 */
@property (nonatomic, copy) NSString *fileName;
/**
 *  文件类型
 */
@property (nonatomic, copy) NSString *mimeType;
@end