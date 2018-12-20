//
//  Utilities.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>

//针对判断是否有网络需要的头文件
#import <CommonCrypto/CommonHMAC.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
#import <arpa/inet.h>

#import "UserInfo.h"
#import "ZZTJiXuYueDuModel.h"

@interface Utilities : NSObject


+(CGFloat)getBigCarChapterH;

+(CGFloat)getBannerH;

+(CGFloat)getCarChapterH;

+(void)SetNSUserDefaults:(UserInfo *)userInfo;

+(UserInfo *)GetNSUserDefaults;

+(void)SetJiXuYueDuDefaults:(ZZTJiXuYueDuModel *)userInfo;

+(ZZTJiXuYueDuModel *)GetJiXuYueDuDefaults;

//传入时间与当前时间的差值
- (NSDateComponents *)deltaFrom:(NSDate *)date;

//通过path名 得到内容
+ (NSArray *)GetArrayWithPathComponent:(NSString *)path;

//通过path 得到file
+ (NSString *)fileWithPathComponent:(NSString *)path;

-(void)setupNavgationStyle:(UINavigationController *)nav;

//获取存储图片的地址
+(NSString *)getCacheImagePath;

/**
 判断当前是否可以连接到网络
 */
+ (BOOL) connectedToNetwork;
//验证邮箱是否正确
+ (BOOL)validateEmail:(NSString *)strEmail;

@end
