//
//  ViewController.m
//  XDFriendShare
//
//  Created by 郎学东 on 2017/12/1.
//  Copyright © 2017年 郎学东. All rights reserved.
//

#import "GlobalUI.h"

@implementation GlobalUI

+ (UIImageView *)createImageViewbgColor:(UIColor *)bgColor {
    UIImageView * img = [[UIImageView alloc] init];
    img.backgroundColor = bgColor;
    return img;
}

+ (UILabel *)createLabelFont:(CGFloat )fontsize titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor{
    UILabel * lab = [[UILabel alloc]init];
    lab.font = [UIFont systemFontOfSize:fontsize];
    lab.textColor = titleColor;
    lab.backgroundColor = bgColor;
    return  lab;
}
+ (UIButton *)createButtonWithImg:(UIImage *)img title:(NSString *)title titleColor:(UIColor *)titleColor{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:img forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn  setTitleColor:titleColor forState:UIControlStateNormal];
    return  btn;
}

+ (UIButton *)createButtonWithTopImg:(UIImage *)img title:(NSString *)title titleColor:(UIColor *)titleColor{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:img forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:
     UIEdgeInsetsMake(btn.frame.size.height/2,
                      (btn.frame.size.width-btn.titleLabel.intrinsicContentSize.width)/2-btn.imageView.frame.size.width,
                      0,
                      (btn.frame.size.width-btn.titleLabel.intrinsicContentSize.width)/2)];
    [btn setImageEdgeInsets:
     UIEdgeInsetsMake(
                      0,
                      (btn.frame.size.width-btn.imageView.frame.size.width)/2,
                      btn.titleLabel.intrinsicContentSize.height,
                      (btn.frame.size.width-btn.imageView.frame.size.width)/2)];
    return  btn;
}
@end
