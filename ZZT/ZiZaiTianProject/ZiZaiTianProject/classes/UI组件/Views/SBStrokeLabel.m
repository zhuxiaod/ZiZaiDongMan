//
//  SBStrokeLabel.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/13.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "SBStrokeLabel.h"

@implementation SBStrokeLabel

- (void)drawTextInRect:(CGRect)rect {
    if (self.strokeWidth > 0) {
        CGSize shadowOffset = self.shadowOffset;
        UIColor *textColor = self.textColor;
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(c, self.strokeWidth);
        CGContextSetLineJoin(c, kCGLineJoinRound);
        //画外边
        CGContextSetTextDrawingMode(c, kCGTextStroke);
        self.textColor = self.strokeColor;
        [super drawTextInRect:rect];
        //画内文字
        CGContextSetTextDrawingMode(c, kCGTextFill);
        self.textColor = textColor;
        self.shadowOffset = CGSizeMake(0, 0);
        [super drawTextInRect:rect];
        self.shadowOffset = shadowOffset;
    } else {
        [super drawTextInRect:rect];
    }
}

-(void)setStrokeColor:(UIColor *)strokeColor{
    _strokeColor = strokeColor;
}

-(void)setStrokeWidth:(CGFloat)strokeWidth{
    _strokeWidth = strokeWidth;
}
    

@end
