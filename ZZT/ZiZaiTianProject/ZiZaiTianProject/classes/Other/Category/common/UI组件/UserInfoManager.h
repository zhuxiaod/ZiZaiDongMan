//
//  UserInfoManager.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/5.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>

//接口
@class UserInfo;

@interface UserInfoManager : NSObject

+(instancetype)share;

@property (nonatomic)        BOOL hasLogin;

@property (nonatomic,copy)   NSString *avatar_url;      //头像

@property (nonatomic,strong) NSString *ID;              //ID

@property (nonatomic,copy)   NSString *nickname;        //昵称

@property (nonatomic,copy)   NSString *phone;           //手机号

@property (nonatomic,copy)   NSString *intro;           //简介

@property (nonatomic,copy)   NSString *sex;              //性别

@property (nonatomic,copy)   NSString *birthday;         //生日

@property (nonatomic,strong) UserInfo *userData;

- (void)saveUserInfoWithData:(UserInfo *)user;

- (void)logoutUserInfo;

+ (BOOL)needLogin;

//更新数据
-(void)loadUserInfoDataSuccess:(void (^)(void))successBlock;

@end
