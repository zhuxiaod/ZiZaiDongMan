//
//  Utilities.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "Utilities.h"
@implementation Utilities
//存储单例models到NSUserDefaults
+(void)SetNSUserDefaults:(UserInfo *)userInfo{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:@"user"];
    [defaults synchronize];
}

+(UserInfo *)GetNSUserDefaults{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"user"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (NSDateComponents *)deltaFrom:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *compas = [calendar components:unit fromDate:self toDate:date options:0];
    return compas;
}

+ (NSArray *)GetArrayWithPathComponent:(NSString *)path{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileName = [docDir stringByAppendingPathComponent:path];
    NSArray *models = [NSArray arrayWithContentsOfFile:fileName];
    return models;
}

+ (NSString *)fileWithPathComponent:(NSString *)path{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileName = [docDir stringByAppendingPathComponent:path];
    return fileName;
}

-(void)setupNavgationStyle:(UINavigationController *)nav{
    UIImage *image = [UIImage imageNamed:@"APP架构-作品-顶部渐变条-IOS"];
    // 设置左边端盖宽度
    NSInteger leftCapWidth = image.size.width * 0.5;
    // 设置上边端盖高度
    NSInteger topCapHeight = image.size.height * 0.5;
    UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    [nav.navigationBar setBackgroundImage:newImage forBarMetrics:UIBarMetricsDefault];
}
@end
