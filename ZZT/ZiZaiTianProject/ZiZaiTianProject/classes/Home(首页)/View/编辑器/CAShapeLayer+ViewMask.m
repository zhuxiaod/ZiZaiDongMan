//
//  CAShapeLayer+ViewMask.m
//  遮罩测试
//
//  Created by zxd on 2018/12/30.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "CAShapeLayer+ViewMask.h"


@implementation CAShapeLayer (ViewMask)

//测试
+ (instancetype)createMaskLayerWithView : (UIView *)view{
    
    CGFloat viewWidth = CGRectGetWidth(view.frame);
    CGFloat viewHeight = CGRectGetHeight(view.frame);
    
    CGFloat rightSpace = 10.;
    CGFloat topSpace = 15.;
    
    CGPoint point1 = CGPointMake(0, 0);
    CGPoint point2 = CGPointMake(viewWidth-rightSpace, 0);
    CGPoint point3 = CGPointMake(viewWidth-rightSpace, topSpace);
    CGPoint point4 = CGPointMake(viewWidth, topSpace);
    CGPoint point5 = CGPointMake(viewWidth-rightSpace, topSpace + 10.);
    CGPoint point6 = CGPointMake(viewWidth-rightSpace, viewHeight);
    CGPoint point7 = CGPointMake(0, viewHeight);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addLineToPoint:point3];
    [path addLineToPoint:point4];
    [path addLineToPoint:point5];
    [path addLineToPoint:point6];
    [path addLineToPoint:point7];
    [path closePath];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.path           = path.CGPath;

    return shapeLayer;
}

//正椭圆 遮罩
+(instancetype)createStraightEllipseMaskLayerWithView:(UIView *)view{
    CGFloat viewWidth = CGRectGetWidth(view.frame);
    CGFloat viewHeight = CGRectGetHeight(view.frame);

    UIBezierPath *_ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, viewWidth, viewHeight)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.path           = _ovalPath.CGPath;
    return shapeLayer;
}

//正椭圆 边线
+(instancetype)createStraightEllipseBorderLayerWithView:(UIView *)view{
    CGFloat viewWidth = CGRectGetWidth(view.frame);
    CGFloat viewHeight = CGRectGetHeight(view.frame);
    
    UIBezierPath *_ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, viewWidth, viewHeight)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path           = _ovalPath.CGPath;
    shapeLayer.fillColor  = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor    = [UIColor blackColor].CGColor;
    shapeLayer.lineWidth      = 2;
    shapeLayer.frame = view.bounds;
    
    return shapeLayer;
}



//+ (instancetype)createLayerWithView:(UIView *)view{
//
//    CGFloat viewWidth = CGRectGetWidth(view.frame);
//    CGFloat viewHeight = CGRectGetHeight(view.frame);
//
//    CGPoint point1 = CGPointMake(viewWidth / 2, 0);
//    CGPoint point2 = CGPointMake(0, viewHeight);
//    CGPoint point3 = CGPointMake(viewWidth, viewHeight);;
//
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:point1];
//    [path addLineToPoint:point2];
//    [path addLineToPoint:point3];
//    [path closePath];
//
//    CAShapeLayer *borderLayer = [CAShapeLayer layer];
//    borderLayer.path    =   path.CGPath;
//    borderLayer.fillColor  = [UIColor clearColor].CGColor;
//    borderLayer.strokeColor    = [UIColor redColor].CGColor;
//    borderLayer.lineWidth      = 2;
//    borderLayer.frame = view.bounds;
//
//    return borderLayer;
//}
//
//+ (instancetype)createTriangleMaskLayerWithView : (UIView *)view{
//
//    CGFloat viewWidth = CGRectGetWidth(view.frame);
//    CGFloat viewHeight = CGRectGetHeight(view.frame);
//
//    CGPoint point1 = CGPointMake(viewWidth / 2, 0);
//    CGPoint point2 = CGPointMake(0, viewHeight);
//    CGPoint point3 = CGPointMake(viewWidth, viewHeight);;
//
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:point1];
//    [path addLineToPoint:point2];
//    [path addLineToPoint:point3];
//    [path closePath];
//
//    CAShapeLayer *layer = [CAShapeLayer layer];
//    layer.path = path.CGPath;
//
//    return layer;
//}
@end
