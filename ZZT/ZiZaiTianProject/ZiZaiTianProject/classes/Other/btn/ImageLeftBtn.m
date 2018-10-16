//
//  ImageLeftBtn.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/10/15.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ImageLeftBtn.h"

@implementation ImageLeftBtn

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    //调整图片的位置和尺寸
    self.imageView.width = self.height * 0.8;
    self.imageView.height = self.height * 0.8;
    //位置写在后面
    self.imageView.centerY = self.height/2;
    self.imageView.x = 0;
    
    //调整文字的位置和尺寸
    [self.titleLabel sizeToFit];
    
    self.titleLabel.x = self.imageView.width + 2;
    self.titleLabel.centerY = self.height/2;
    self.titleLabel.width = self.width - self.imageView.width - 2;
    //    self.titleLabel.height = self.height * 0.2;
    self.titleLabel.height = self.height * 0.8;
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.adjustsImageWhenHighlighted = NO;
}

@end
