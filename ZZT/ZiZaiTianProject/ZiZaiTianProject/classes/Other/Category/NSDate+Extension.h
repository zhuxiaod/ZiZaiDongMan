//
//  NSDate+Extension.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/21.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

/**
 *传入时间与当前时间的差值
 */
- (NSDateComponents *)deltaFrom:(NSDate *)date;

- (NSDateComponents *)intervalToDate:(NSDate *)date;
- (NSDateComponents *)intervalToNow;

/**
 * 是否为今年
 */
- (BOOL)isThisYear;

/**
 * 是否为今天
 */
- (BOOL)isToday;

/**
 * 是否为昨天
 */
- (BOOL)isYesterday;

/**
 * 是否为明天
 */
- (BOOL)isTomorrow;

+(NSString *)updateTimeForRow:(NSString *)str;

@end
