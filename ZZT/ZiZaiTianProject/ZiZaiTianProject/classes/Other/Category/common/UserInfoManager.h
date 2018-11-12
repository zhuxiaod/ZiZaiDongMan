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

@property (nonatomic,strong) NSNumber *ID;              //ID

@property (nonatomic,copy)   NSString *nickname;        //昵称

@end