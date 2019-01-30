//
//  UIView+DottedLine.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/1/28.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import "UIView+DottedLine.h"

@implementation UIView (DottedLine)

-(void)addBottedlineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor{
    CAShapeLayer *border = [CAShapeLayer layer];
    
    border.strokeColor = lineColor.CGColor;
    
    border.fillColor = nil;
    
    border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    
    border.frame = self.bounds;
    
    border.lineWidth = lineWidth;
    
    border.lineCap = @"square";
    //设置线宽和线间距
    border.lineDashPattern = @[@4, @5];
    
    [self.layer addSublayer:border];
}

@end
