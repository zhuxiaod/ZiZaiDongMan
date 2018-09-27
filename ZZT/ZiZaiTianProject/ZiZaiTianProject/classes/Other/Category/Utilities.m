//
//  Utilities.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "Utilities.h"
#import "HSVWithNew.h"
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




+(UIColor *)calculatePointInView:(CGPoint)point colorFrame:(CGRect)colorFrame brightness:(CGFloat)brightness alpha:(CGFloat)alpha{
    
    CGPoint center=CGPointMake(colorFrame.size.width/2,colorFrame.size.height/2);  // 中心点
    double radius=colorFrame.size.width/2;          // 半径
    double dx=ABS(point.x-center.x);    //  ABS函数: int类型 取绝对值
    double dy=ABS(point.y-center.y);   //   atan pow sqrt也是对应的数学函数
    double angle=atan(dy/dx);
    if (isnan(angle)) angle=0.0;
    double dist=sqrt(pow(dx,2)+pow(dy,2));
    double saturation=MIN(dist/radius,1.0);
    
    if (dist<10) saturation=0;
    if (point.x<center.x) angle=M_PI-angle;
    if (point.y>center.y) angle=2.0*M_PI-angle;
    
    HSVType currentHSV=HSVTypeMake(angle/(2.0*M_PI), saturation, 1.0);
    
    //    [self centerPointValue:currentHSV];    // 计算中心点位置
    
    UIColor *color=[UIColor colorWithHue:currentHSV.h saturation:currentHSV.s brightness:brightness alpha:alpha];

    return color;
}
@end
