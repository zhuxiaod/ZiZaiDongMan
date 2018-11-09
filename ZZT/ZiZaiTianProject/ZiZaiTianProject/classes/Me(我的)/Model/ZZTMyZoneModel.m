//
//  ZZTMyZoneModel.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTMyZoneModel.h"

@implementation ZZTMyZoneModel

//#pragma mark - getter
//- (NSString *)publishtime
//{
//    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
//    NSTimeInterval currentTime = [date timeIntervalSince1970];
//    NSTimeInterval createTime = [_publishtime floatValue]/1000;
//    NSTimeInterval time = currentTime - createTime;
//    NSInteger small = time / 60;
//    if(small == 0){
//        return [NSString stringWithFormat:@"刚刚"];
//    }
//    if(small < 60){
//        return [NSString stringWithFormat:@"%ld分钟前",small];
//    }
//    NSInteger hours = time / 3600;
//    if(hours < 24){
//        return [NSString stringWithFormat:@"%ld小时前",hours];
//    }
//    NSInteger days = time/3600/24;
//    if(days < 30){
//        return [NSString stringWithFormat:@"%ld天前",days];
//    }
//    NSInteger months = time/3600/24/30;
//    if(months < 12){
//        return [NSString stringWithFormat:@"%ld月前",months];
//    }
//    NSInteger years = time/3600/24/30/12;
//    return [NSString stringWithFormat:@"%ld年前",years];
//}

@end
