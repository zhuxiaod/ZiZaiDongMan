//
//  NSLayoutConstraint+IBDesignable.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/24.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//
//按比例获取宽度   根据375的屏幕
#define  C_WIDTH(WIDTH) WIDTH * [UIScreen mainScreen].bounds.size.width/414.0

#import "NSLayoutConstraint+IBDesignable.h"

@implementation NSLayoutConstraint (IBDesignable)

-(void)setWidthScreen:(BOOL)widthScreen{
    if (widthScreen) {
        self.constant = C_WIDTH(self.constant);
    }else{
        self.constant = self.constant;
    }
}

-(BOOL)widthScreen{
    return self.widthScreen;
}



@end
