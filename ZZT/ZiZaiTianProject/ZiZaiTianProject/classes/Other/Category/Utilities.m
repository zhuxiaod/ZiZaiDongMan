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
    [[UserInfoManager share] saveUserInfoWithData:userInfo];
}

+(UserInfo *)GetNSUserDefaults{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"user"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

//存储单例models到NSUserDefaults
+(void)SetJiXuYueDuDefaults:(ZZTJiXuYueDuModel *)userInfo{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:@"JiXuYueDu"];
    [defaults synchronize];
}

+(ZZTJiXuYueDuModel *)GetJiXuYueDuDefaults{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"JiXuYueDu"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (NSDateComponents *)deltaFrom:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *compas = [calendar components:unit fromDate:self toDate:date options:0];
    return compas;
}

+ (NSArray *)GetArrayWithPathComponent:(NSString *)path{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileName = [docDir stringByAppendingPathComponent:path];
    NSArray *models = [NSArray arrayWithContentsOfFile:fileName];
    return models;
}

+ (NSString *)fileWithPathComponent:(NSString *)path{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
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

+(CGFloat)getBannerH{
    //6 6s 7 8
    if(SCREEN_WIDTH == 414){
        return 249;
    }else{
        return 234;
    }
}

+(CGFloat)getCarChapterH{
    //6 6s 7 8
    if(SCREEN_WIDTH == 414){
        return 174;
    }else{
        return 156;
    }
}

+(CGFloat)getBigCarChapterH{
    //6 6s 7 8
    if(SCREEN_WIDTH == 414){
        return 240;
    }else{
        return 216;
    }
}

//是否连接wang'l
+ (BOOL)connectedToNetwork{
    
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL nonWifi = flags & kSCNetworkReachabilityFlagsTransientConnection;
    BOOL moveNet = flags & kSCNetworkReachabilityFlagsIsWWAN;
    
    return ((isReachable && !needsConnection) || nonWifi || moveNet) ? YES : NO;
}

+ (BOOL)validateEmail:(NSString *)strEmail {
    NSString *regex = @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [emailTest evaluateWithObject:strEmail];
}

+(NSString *)getCacheImagePath{
    NSString *imageName = [NSString getCurrentTimes];
    
    NSString *keyRandom = [self randomString];
    
    NSString *keyString = [NSString stringWithFormat:@"%@%@.jpg",imageName,keyRandom];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:keyString];
    
    return filePath;
}

+ (NSString *)randomString {
    NSString *kRandomAlphabet = @"0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:10];
    for (int i = 0; i < 10; i++) {
        [randomString appendFormat: @"%C", [kRandomAlphabet characterAtIndex:arc4random_uniform((u_int32_t)[kRandomAlphabet length])]];
    }
    return randomString;
}
@end
