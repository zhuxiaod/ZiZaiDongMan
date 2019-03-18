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
    NSString *deviceid;//设备id
    NSInteger id;//关键id
    NSString *headimg;//头像
    NSString *intro;//简介
    NSString *cover;//封面
    NSString *nickName;//昵称
    NSString *phone;//手机号
    NSString *vipEndtime;// Vip结束时间
    NSString *attentionNum;// 关注数量
    NSString *fansNum;//粉丝数量
    NSString *userVip;
    
}

@property (nonatomic,assign)BOOL isLogin;
@property (nonatomic,copy) NSString *phoneNumber;
@property (nonatomic,copy) NSString *cookie;
@property (nonatomic,assign) NSInteger tabBarSelected;
@property (nonatomic,copy) NSString *deviceid;

//用户ID+
@property (nonatomic,strong)NSString *userId;
//积分数量+
@property (nonatomic,assign)NSInteger integralNum;
//id+
@property (nonatomic,assign)NSInteger id;
//月票+
@property (nonatomic,strong)NSString *month_num;
//阅读卷数量+
@property (nonatomic,assign)NSInteger rollNum;
//自在币数量+
@property (nonatomic,assign)NSInteger zzbNum;
//创建时间+
@property (nonatomic,strong)NSDate *createtime;
//修改时间+
@property (nonatomic,strong)NSDate *updatetime;
//手机号码+
@property (nonatomic,strong)NSString *phone;
//昵称+
@property (nonatomic,strong)NSString *nickName;
//密码+
@property (nonatomic,strong)NSString *password;
//头像+
@property (nonatomic,strong)NSString *headimg;
//QQ+
@property (nonatomic,strong)NSString *qQ;
//+
@property (nonatomic,strong)NSString *weixin;
//用户类型+
@property (nonatomic,strong)NSString *userType;
//性别+
@property (nonatomic,strong)NSString *sex;
//签名+
@property (nonatomic,strong)NSString *intro;
//生日+
@property (nonatomic,strong)NSString *birthday;
//个人封面+
@property (nonatomic,strong)NSString *cover;
//今天是否签到   0表示没签到，1表示签到+
@property (nonatomic,assign)NSInteger ifsign;
//连续签到数+
@property (nonatomic,assign) NSInteger signCount;

@property (nonatomic,strong) NSString *vipEndtime;

@property (nonatomic,strong) NSString *attentionNum;

@property (nonatomic,strong) NSString *fansNum;
//是不是vip
@property (nonatomic,strong) NSString *userVip;


+(instancetype)initAuthorWithUserId:(NSString *)userId headImg:(NSString *)headImg nikeName:(NSString *)nikeName;

@end
