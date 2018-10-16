//
//  ZZTCircleModel.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/13.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTCircleModel.h"

@implementation ZZTCircleModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"replyComment" : @"ZZTUserReplyModel"};//前边，是属性数组的名字，后边就是类名
}

#pragma mark - getter
- (NSString *)commentDate
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval currentTime = [date timeIntervalSince1970];
    NSTimeInterval createTime = [_commentDate floatValue]/1000;
    NSTimeInterval time = currentTime - createTime;
    NSInteger small = time / 60;
    if(small == 0){
        return [NSString stringWithFormat:@"刚刚"];
    }
    if(small < 60){
        return [NSString stringWithFormat:@"%ld分钟前",small];
    }
    NSInteger hours = time / 3600;
    if(hours < 24){
        return [NSString stringWithFormat:@"%ld小时前",hours];
    }
    NSInteger days = time/3600/24;
    if(days < 30){
        return [NSString stringWithFormat:@"%ld天前",days];
    }
    NSInteger months = time/3600/24/30;
    if(months < 12){
        return [NSString stringWithFormat:@"%ld月前",months];
    }
    NSInteger years = time/3600/24/30/12;
    return [NSString stringWithFormat:@"%ld年前",years];
}
@end
