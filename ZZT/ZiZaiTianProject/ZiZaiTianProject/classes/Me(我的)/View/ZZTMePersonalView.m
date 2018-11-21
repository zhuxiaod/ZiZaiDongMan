//
//  ZZTMePersonalView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/21.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTMePersonalView.h"
@interface ZZTMePersonalView()

@end

@implementation ZZTMePersonalView

+(instancetype)mePersonalView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
}

@end
