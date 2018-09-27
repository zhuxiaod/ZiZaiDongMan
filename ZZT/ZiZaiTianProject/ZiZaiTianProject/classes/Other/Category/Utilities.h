//
//  Utilities.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "HSVWithNew.h"

@interface Utilities : NSObject
+(void)SetNSUserDefaults:(UserInfo *)userInfo;

+(UserInfo *)GetNSUserDefaults;
//传入时间与当前时间的差值
- (NSDateComponents *)deltaFrom:(NSDate *)date;
//通过path名 得到内容
+ (NSArray *)GetArrayWithPathComponent:(NSString *)path;
//通过path 得到file
+ (NSString *)fileWithPathComponent:(NSString *)path;

+(UIColor *)calculatePointInView:(CGPoint)point colorFrame:(CGRect)colorFrame brightness:(CGFloat)brightness alpha:(CGFloat)alpha;
@end
