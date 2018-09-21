//
//  Utilities.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
@interface Utilities : NSObject
+(void)SetNSUserDefaults:(UserInfo *)userInfo;

+(UserInfo *)GetNSUserDefaults;
// *传入时间与当前时间的差值
- (NSDateComponents *)deltaFrom:(NSDate *)date;
@end
