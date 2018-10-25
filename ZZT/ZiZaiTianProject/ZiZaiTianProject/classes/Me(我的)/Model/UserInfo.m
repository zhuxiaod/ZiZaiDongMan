//
//  UserInfo.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

-(NSString *)cover{
    if(!cover){
        cover = @"";
    }
    return cover;
}

-(NSString *)intro{
    if(!intro){
        intro = @"";
    }
    return intro;
}

-(NSString *)birthday{
    NSTimeInterval time = [_birthday floatValue];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *timeString=[formatter stringFromDate:d];
    return timeString;
}

@synthesize isLogin;
@synthesize phoneNumber;
@synthesize cookie;
@synthesize tabBarSelected;
@synthesize deviceid;
@synthesize id;
@synthesize headimg;
@synthesize intro;
@synthesize cover;
@synthesize nickName;
@synthesize phone;

// 归档属性
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    // c语言特点：函数的参数如果是基本数据类型，基本是需要函数内部修改他的值
    // 申明一个变量，便于内部将内部参数数量返回给count
    unsigned int count = 0;
    // C语言函数带有copy字样会在堆内存开辟一块空间 此区域ARC不管 需要手动释放！！
    Ivar *ivars = class_copyIvarList([self class], &count); for (int i = 0; i < count; i++) {
        // 拿到ivar
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
        
    } free(ivars);
    
}
// 解档属性
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i++) {
            // 拿到ivar
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:name];
            // 解档
            id value = [aDecoder decodeObjectForKey:key];
            // kvc 赋值
            [self setValue:value forKey:key];
            
        } free(ivars);
        
    } return self;
}

@end
