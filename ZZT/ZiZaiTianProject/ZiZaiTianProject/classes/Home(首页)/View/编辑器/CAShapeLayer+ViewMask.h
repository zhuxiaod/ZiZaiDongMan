//
//  CAShapeLayer+ViewMask.h
//  遮罩测试
//
//  Created by zxd on 2018/12/30.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CAShapeLayer (ViewMask)
//测试layer
+ (instancetype)createMaskLayerWithView : (UIView *)view;

//正椭圆
+ (instancetype)createStraightEllipseMaskLayerWithView : (UIView *)view;

+(instancetype)createStraightEllipseBorderLayerWithView:(UIView *)view;

+(instancetype)addBottedlineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor view:(UIView *)view;

//+ (instancetype)createTriangleMaskLayerWithView : (UIView *)view;
//
//+ (instancetype)createLayerWithView:(UIView *)view;

@end
