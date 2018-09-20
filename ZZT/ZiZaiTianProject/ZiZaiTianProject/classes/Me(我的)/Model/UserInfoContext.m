//
//  UserInfoContext.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "UserInfoContext.h"


@implementation UserInfoContext

@synthesize userInfo;
static UserInfoContext *shareUserInfoContext = nil;

+(UserInfoContext *)sharedUserInfoContext{
    static dispatch_once_t token;
    dispatch_once(&token,^{
        if(shareUserInfoContext == nil){
            shareUserInfoContext = [[self alloc] init];
        }
    });
    return shareUserInfoContext;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t token;
    dispatch_once(&token,^{
        if(shareUserInfoContext == nil){
            shareUserInfoContext = [super allocWithZone:zone];
        }
    });
    return shareUserInfoContext;
}

-(instancetype)init{
    self = [super init];
    if(self){
        shareUserInfoContext.userInfo = [[UserInfo alloc] init];
    }
    return self;
}
-(id)copy{
    return self;
}

-(id)mutableCopy{
    return self;
}

@end
