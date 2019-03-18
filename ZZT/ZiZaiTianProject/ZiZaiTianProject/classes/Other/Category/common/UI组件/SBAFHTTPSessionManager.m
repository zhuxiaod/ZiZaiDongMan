//
//  SBAFHTTPSessionManager.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/3/18.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import "SBAFHTTPSessionManager.h"

@implementation SBAFHTTPSessionManager

static AFHTTPSessionManager *manager;

+ (AFHTTPSessionManager *)getManager{
    static dispatch_once_t onceToken;dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        // 缓存策略
        manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        //设置超时时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 30.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        // 4. 设置响应数据类型
        
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"image/jpeg", @"text/vnd.wap.wml", @"application/x-javascript",@"image/png", nil]];
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        
    });
    return manager;
}

@end
