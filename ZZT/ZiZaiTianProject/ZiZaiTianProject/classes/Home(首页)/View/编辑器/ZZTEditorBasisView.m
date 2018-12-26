//
//  ZZTEditorBasisView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/26.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTEditorBasisView.h"

@interface ZZTEditorBasisView ()<UIGestureRecognizerDelegate>{
    BOOL isMove;
    CGPoint legend_point;
    
    CGPoint touchLocation;
    
    CGPoint prevPoint;

    CGPoint beginningPoint;
    
    CGPoint beginningCenter;
    
    CGRect beginBounds;
}

@end

@implementation ZZTEditorBasisView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //可以进行交互
        self.userInteractionEnabled = YES;
        //添加UI
        [self addUI];
        //放大缩小
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePich:)];
        pinchGestureRecognizer.delegate = self;
        [self addGestureRecognizer:pinchGestureRecognizer];
        
        //旋转
        UIRotationGestureRecognizer *rotateRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
        rotateRecognizer.delegate = self;
        [self addGestureRecognizer:rotateRecognizer];
        
        
        //拖动
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(selfMove:)];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        panGestureRecognizer.delegate = self;
        [self addGestureRecognizer:panGestureRecognizer];
        
        self.backgroundColor = [UIColor redColor];
        
    }
    return self;
}

-(void)addUI{
    
}

#pragma mark 缩放
-(void)handlePich:(UIPinchGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(setupViewForCurrentView:)])
    {
        // 调用代理方法
        [self.delegate setupViewForCurrentView:self];
    }

    //代理方法
    //点击的是当前view
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    
    recognizer.scale = 1;

}

#pragma mark 旋转
-(void)handleRotate:(UIRotationGestureRecognizer *)recognizer
{

    if (self.delegate && [self.delegate respondsToSelector:@selector(setupViewForCurrentView:)])
    {
        // 调用代理方法
        [self.delegate setupViewForCurrentView:self];
        
    }
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);

    recognizer.rotation = 0;

}

#pragma mark 移动
-(void)selfMove:(UIPanGestureRecognizer *)gesture{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(setupViewForCurrentView:)])
    {
        // 调用代理方法
        [self.delegate setupViewForCurrentView:self];
        
    }

    CGPoint translation = [gesture translationInView:self.superview];
    
    self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);

    [gesture setTranslation:CGPointZero inView:self.superview];
    
    [self layoutSubviews];

}

#pragma mark - 代理方法实现旋转 + 缩放捏合 可同时进行
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end
