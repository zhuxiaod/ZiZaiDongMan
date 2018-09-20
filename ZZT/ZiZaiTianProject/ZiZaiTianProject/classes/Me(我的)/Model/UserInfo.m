//
//  UserInfo.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
@synthesize isLogin;
@synthesize phoneNumber;
@synthesize cookie;
@synthesize tabBarSelected;
@synthesize deviceid;

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeBool:self.isLogin forKey:@"isLogin"];
    [aCoder encodeObject:self.phoneNumber forKey:@"phoneNumber"];
    [aCoder encodeObject:self.cookie forKey:@"cookie"];
    [aCoder encodeInteger:self.tabBarSelected forKey:@"tabBarSelected"];
    [aCoder encodeObject:self.deviceid forKey:@"deviceid"];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self =[super init]) {
        self.isLogin = [aDecoder decodeBoolForKey:@"isLogin"];
        self.phoneNumber = [aDecoder decodeObjectForKey:@"phoneNumber"];
        self.cookie = [aDecoder decodeObjectForKey:@"cookie"];
        self.tabBarSelected = [aDecoder decodeIntegerForKey:@"tabBarSelected"];
        self.deviceid = [aDecoder decodeObjectForKey:@"deviceid"];
    }
    return self;
}

@end
