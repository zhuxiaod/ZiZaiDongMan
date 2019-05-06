//
//  SBAFHTTPSessionManager.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/3/18.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import "SBAFHTTPSessionManager.h"

@implementation SBAFHTTPSessionManager

//单例
+ (instancetype)sharedManager {
    
    static SBAFHTTPSessionManager *iapManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        iapManager = [SBAFHTTPSessionManager new];
    });
    
    return iapManager;
}

- (NSString *)userID{
    
    return _userID = [NSString stringWithFormat:@"%ld",(long)[Utilities GetNSUserDefaults].id];
}

- (AFHTTPSessionManager *)networkManager{
    if(_networkManager == nil){
        _networkManager = [SBAFHTTPSessionManager getManager];
    }
    return _networkManager;
}

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

        //无条件的信任服务器上的证书
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        // 客户端是否信任非法证书
        securityPolicy.allowInvalidCertificates = YES;
        // 是否在证书域字段中验证域名
        securityPolicy.validatesDomainName = NO;
        manager.securityPolicy = securityPolicy;

        // 4. 设置响应数据类型
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"image/jpeg", @"text/vnd.wap.wml", @"application/x-javascript",@"image/png", nil]];

        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    });
    return manager;
}

//POST请求
-(void)loadPostRequest:(NSString *)urlString paramDict:(NSDictionary *)paramDict finished:(void (^)(id responseObject,NSError * error))finished{
    [self.networkManager POST:[ZZTAPI stringByAppendingString:urlString] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finished(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finished(nil,error);
    }];
}

-(void)loadMultiChapterData:(NSString *)cartoonId chapterId:(NSString *)chapterId finished:(void (^)(id responseObject,NSError * error))finished{
    NSDictionary *paramDIct = @{
                                @"cartoonId":cartoonId,
                                @"chapterId":chapterId
                                };
    [self.networkManager POST:[ZZTAPI stringByAppendingString:@"cartoon/getChapterMultilist"] parameters:paramDIct progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *commenDdic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        finished(commenDdic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finished(nil,error);
    }];
}


//读取漫画内容
-(void)loadCartoonContentData:(NSString *)urlString id:(NSString *)bookId finished:(void (^)(id responseObject,NSError * error))finished{
    NSDictionary *paramDict = @{
                                @"userId":[UserInfoManager share].ID,
                                @"id":bookId,
                                @"pageNum":@"0",
                                @"pageSize":@"500"
                                };
    [self.networkManager POST:[ZZTAPI stringByAppendingString:urlString] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finished(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finished(nil,error);
    }];
}

//读取漫画评论内容
-(void)loadCartoonCommentData:(NSString *)urlString chapterId:(NSString *)chapterId type:(NSString *)type finished:(void (^)(NSDictionary *commentDict,NSError * error))finished{
    NSDictionary *dict = @{
                           @"chapterId":chapterId,
                           @"type":type,
                           @"userId":_userID,
                           @"pageNum":@"0",
                           @"pageSize":@"10",
                           @"host":@"1"
                           };
    [self.networkManager POST:[ZZTAPI stringByAppendingString:urlString] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *commenDdic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        finished(commenDdic[@"list"],nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finished(nil,error);
    }];
}

//上下篇章
-(void)loadUpDownData:(NSString *)urlString cartoonId:(NSString *)cartoonId chapterId:(NSString *)chapterId code:(NSString *)code authorId:(NSInteger)authorId upDown:(NSInteger)upDown finished:(void (^)(id  _Nullable responseObject,NSError * error))finished{
    NSString *upDownState = upDown == 1?@"2" : @"1";
    NSDictionary *dic = @{
                          @"cartoonId":cartoonId,//书ID
                          @"chapterId":chapterId,//章节ID
                          @"upDown":upDownState,//1.下 2.上
                          @"code":code,//1.漫画 2.章节
                          @"userId":self.userID,
                          @"authorId":[NSString stringWithFormat:@"%ld",authorId]
                          };
    [self.networkManager POST:[ZZTAPI stringByAppendingString:urlString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finished(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finished(nil,error);
    }];
}

//漫画点赞点赞
-(void)cartoonGiveGood:(NSString *)urlString type:(NSString *)type typeId:(NSString *)typeId cartoonId:(NSString *)cartoonId finished:(void (^)(id  _Nullable responseObject,NSError * error))finished{
    NSDictionary *dic = @{
                          @"type":type,
                          @"typeId":typeId,
                      
                          @"userId":self.userID,
                          @"cartoonId":cartoonId
                          };
    [self.networkManager POST:[ZZTAPI stringByAppendingString:urlString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finished(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finished(nil,error);
    }];
    
}

//空间 关注数据
-(void)loadStatusOrAttentionData:(NSString *)pageNum pageSize:(NSString *)pageSize type:(NSString *)type finished:(void (^)(id  _Nullable responseObject,NSError * error))finished{
    NSDictionary *dic = @{
                          @"pageNum":pageNum,
                          @"pageSize":pageSize,
                          @"userId":self.userID,
                          @"type":type//1.世界 2.关注
                          };
    [self.networkManager POST:[ZZTAPI stringByAppendingString:@"circle/selDiscover"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finished(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finished(nil,error);
    }];
}

//
//关注
-(void)sendAttentionDataWithAuthorId:(NSString *)authorId finished:(void (^)(id  _Nullable responseObject,NSError * error))finished{
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    NSDictionary *dic = @{
                          @"userId":self.userID,
                          @"authorId":authorId
                          };
    [self.networkManager POST:[ZZTAPI stringByAppendingString:@"record/ifUserAtAuthor"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finished(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finished(nil,error);
    }];
}

//用户点赞
-(void)sendUserLikeData:(NSString *)typeId finished:(void (^)(id  _Nullable responseObject,NSError * error))finished{
    NSDictionary *dict = @{
                           @"typeId":typeId,
                           @"userId":self.userID,
                           @"type":@"1"
                           };
    [self.networkManager POST:[ZZTAPI stringByAppendingString:@"great/praises"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finished(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finished(nil,error);
    }];
}

@end
