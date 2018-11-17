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

//取数据 只能取关于接口的
- (void)saveUserInfoWithData:(UserInfo *)user{
    /*
     id
     headimg
     nikeName
     sex 1
     */
    if([user.userId isEqualToString:@""] || user == nil){
        self.hasLogin = NO;
    }else{
        self.hasLogin = YES;
    }
    
    self.ID = [NSString stringWithFormat:@"%ld",user.id];
    
    self.avatar_url = user.headimg;
    
    self.nickname = user.nickName;
}

//登出用户
- (void)logoutUserInfo{
    
    self.hasLogin = NO;
    
    self.ID = nil;
    
    self.avatar_url = nil;
    
    self.nickname = nil;
    
    UserInfo *user = [[UserInfo alloc] init];
    
    user.userId = @"";
    
    [Utilities SetNSUserDefaults:user];
}

//需要登录
+ (BOOL)needLogin {
    return [[UserInfoManager share] needLogin];
}

//是否需要登录 用一个值来判断
- (BOOL)needLogin{
    UserInfo *user = [Utilities GetNSUserDefaults];
    if (self.hasLogin == NO || [user.userId isEqualToString:@""] || [user.userId isEqualToString:@"0"]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未登录" message:@"是否登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
//        [alert show];
        [ZZTLoginRegisterViewController show];
        return YES;
    }
    return NO;
}

//如果是点第一个 确认登录 展示登录页面
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [ZZTLoginRegisterViewController show];
    }
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
