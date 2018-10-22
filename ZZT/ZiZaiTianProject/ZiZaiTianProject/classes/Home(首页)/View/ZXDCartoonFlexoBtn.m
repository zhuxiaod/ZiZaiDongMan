//
//  ZXDCartoonFlexoBtn.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/10.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDCartoonFlexoBtn.h"
#import "UIView+Frame.h"

@implementation ZXDCartoonFlexoBtn

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    

//    self.imageView.width = self.width - 2;
    self.imageView.height = self.height * 0.6;
    self.imageView.width = self.height * 0.6;

    //调整文字的位置和尺寸
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height+5;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height * 0.3;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.adjustsImageWhenHighlighted = NO;
    
    //调整图片的位置和尺寸
    self.imageView.y = 0;
    self.imageView.centerX = self.width * 0.5;
    
}
@end
