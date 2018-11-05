//
//  UserInfoManager.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/5.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "UserInfoManager.h"

@interface UserInfoManager () <UIAlertViewDelegate>

@property (nonatomic,copy) NSString *savePath;

@end

@implementation UserInfoManager

//创建单例
+ (instancetype)share
{
    static id instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserInfoManager alloc] init];
    });
    
    return instance;
}

//+ (void)autoLogin {
//    [[UserInfoManager share] autoLogin];
//}

////自动登录
//- (void)autoLogin {
//    //登录名
//    NSString *loginInfoPath = [self.savePath stringByAppendingPathComponent:loginInfoName];
//
//    NSDictionary *parameters = [NSKeyedUnarchiver unarchiveObjectWithFile:loginInfoPath];
//
//    NSDictionary *userData  = parameters[@"userData"];
//    NSDictionary *loginInfo = parameters[@"loginInfo"];
//    //如果没有用户 退出
//    if (userData.count < 1) return;
//    //发送登录请求
//    [self loginWithPhone:loginInfo[phoneKey] WithPassword:loginInfo[passwordKey] loginSucceed:^(UserInfoManager *user) {
//
//        DEBUG_Log(@"自动登录成功");
//
//    } loginFailed:^(id faileResult, NSError *error) {
//
//        [self saveUserInfoWithData:userData];
//
//    }];
//
//}
@end
