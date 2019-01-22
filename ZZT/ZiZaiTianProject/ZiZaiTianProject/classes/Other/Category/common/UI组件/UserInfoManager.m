//
//  UserInfoManager.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/5.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "UserInfoManager.h"
#import <AdSupport/AdSupport.h>
#import "UUIDTool.h"

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

-(UserInfo *)userData{
    if(!_userData){
        _userData = [Utilities GetNSUserDefaults];
    }
    return _userData;
}

//取数据 只能取关于接口的
- (void)saveUserInfoWithData:(UserInfo *)user{
    /*
     id
     headimg
     nikeName
     sex 1
     */
    if([user.userType isEqualToString:@"3"] || user == nil){
        self.hasLogin = NO;
    }else{
        self.hasLogin = YES;
    }
    
    self.ID = [NSString stringWithFormat:@"%ld",user.id];

    self.avatar_url = user.headimg;
    
    self.nickname = user.nickName;
    
    self.phone = user.phone;
    
    self.intro = user.intro;
    
    _birthday = user.birthday;
}

//登出用户
- (void)logoutUserInfo{
    
    [Utilities removeUserData];
    
//    [Utilities SetNSUserDefaults:user];
    //更新状态
    _userData = nil;
    
    //登录游客模式
//    [self loginVisitorModelSuccess:nil];
}

//需要登录
+ (BOOL)needLogin {
    return [[UserInfoManager share] needLogin];
}

//是否需要登录 用一个值来判断
- (BOOL)needLogin{
    UserInfo *user = [Utilities GetNSUserDefaults];
    if (self.hasLogin == NO || [user.userId isEqualToString:@""] || [user.userType isEqualToString:@"3"]) {
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

-(void)setSex:(NSString *)sex{
    _sex = sex;
    UserInfo *user = [Utilities GetNSUserDefaults];
    user.sex = sex;
    [Utilities SetNSUserDefaults:user];
}

-(void)setBirthday:(NSString *)birthday{
    _birthday = birthday;
    UserInfo *user = [Utilities GetNSUserDefaults];
    user.birthday = birthday;
    [Utilities SetNSUserDefaults:user];
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

-(void)loadUserInfoDataSuccess:(void (^)(void))successBlock{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    
    NSDictionary *paramDict = @{
                                @"userId":[NSString stringWithFormat:@"%ld",self.userData.id]
                                };
    [manager POST:[ZZTAPI stringByAppendingString:@"login/usersInfo"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        
        UserInfo *model = [UserInfo mj_objectWithKeyValues:dic];
        
        model.isLogin = YES;
        self.userData = model;
        //存一下数据
        [Utilities SetNSUserDefaults:model];
        
        if (successBlock != nil) successBlock();
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//登录游客模式
-(void)loginVisitorModelSuccess:(void (^)(void))successBlock{
    NSString *adId = [UUIDTool getUUIDInKeychain];

    NSDictionary *paradict = @{
                               @"phoneIMEI":adId
                               };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[ZZTAPI stringByAppendingString:@"/login/getTouristInfo"] parameters:paradict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        UserInfo *model = [[UserInfo alloc] init];
        model.userType = [dic objectForKey:@"userType"];
        model.id = [[dic objectForKey:@"id"] integerValue];
        model.isLogin = NO;
        [Utilities SetNSUserDefaults:model];

        if (successBlock != nil) successBlock();

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
@end
