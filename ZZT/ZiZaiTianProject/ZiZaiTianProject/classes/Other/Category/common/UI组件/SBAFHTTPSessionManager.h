//
//  SBAFHTTPSessionManager.h
//  ZiZaiTianProject
//
//  Created by mac on 2019/3/18.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBAFHTTPSessionManager : NSObject

@property (nonatomic,strong) AFHTTPSessionManager *networkManager;

@property (nonatomic,strong) NSString *userID;

+ (AFHTTPSessionManager *)getManager;

+ (instancetype)sharedManager;

//加载Post请求
-(void)loadPostRequest:(NSString *)urlString paramDict:(NSDictionary *)paramDict finished:(void (^)(id responseObject,NSError * error))finished;

    
//读取漫画内容
-(void)loadCartoonContentData:(NSString *)urlString id:(NSString *)bookId finished:(void (^)(id responseObject,NSError * error))finished;

//读取漫画评论
-(void)loadCartoonCommentData:(NSString *)urlString chapterId:(NSString *)chapterId type:(NSString *)type finished:(void (^)(NSDictionary *commentDict,NSError * error))finished;

//上下章
-(void)loadUpDownData:(NSString *)urlString cartoonId:(NSString *)cartoonId chapterId:(NSString *)chapterId code:(NSString *)code upDown:(NSInteger)upDown finished:(void (^)(id  _Nullable responseObject,NSError * error))finished;

//点赞
-(void)cartoonGiveGood:(NSString *)urlString type:(NSString *)type typeId:(NSString *)typeId cartoonId:(NSString *)cartoonId finished:(void (^)(id  _Nullable responseObject,NSError * error))finished;

@end
