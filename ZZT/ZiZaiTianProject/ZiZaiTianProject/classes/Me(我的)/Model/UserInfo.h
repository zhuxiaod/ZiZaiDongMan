//
//  UserInfo.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject<NSCoding>{
    BOOL isLogin;//是否登录
    NSString *phoneNumber;//手机号
    NSString *cookie;//cookie
    NSInteger tabBarSelected;//tabbar
    NSString *deviceid;
}

@property (nonatomic,assign)BOOL isLogin;
@property (nonatomic,copy) NSString *phoneNumber;
@property (nonatomic,copy) NSString *cookie;
@property (nonatomic,assign) NSInteger tabBarSelected;
@property (nonatomic,copy) NSString *deviceid;

@end
