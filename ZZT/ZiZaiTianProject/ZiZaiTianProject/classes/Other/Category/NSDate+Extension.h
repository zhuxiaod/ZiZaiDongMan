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

@end
