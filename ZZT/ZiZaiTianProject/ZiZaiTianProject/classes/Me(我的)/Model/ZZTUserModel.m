//
//  ZZTUserModel.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/2.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTUserModel.h"

@implementation ZZTUserModel

-(NSString *)intro{
    if(!_intro){
        _intro = @"";
    }
    return _intro;
}
@end
