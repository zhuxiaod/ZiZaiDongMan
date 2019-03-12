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
    
    CGFloat originalW;
    
    CGFloat originalH;
}

@property (nonatomic,strong) UIPinchGestureRecognizer *pinchGestureRecognizer;

@property (nonatomic,strong) UIRotationGestureRecognizer *rotateRecognizer;

@property (nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic,strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation ZZTEditorBasisView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //可以进行交互
        self.userInteractionEnabled = YES;
        //放大缩小
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePich:)];
        pinchGestureRecognizer.delegate = self;
        _pinchGestureRecognizer = pinchGestureRecognizer;
        [self addGestureRecognizer:pinchGestureRecognizer];
        
        //旋转
        UIRotationGestureRecognizer *rotateRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
        rotateRecognizer.delegate = self;
        _rotateRecognizer = rotateRecognizer;
        [self addGestureRecognizer:rotateRecognizer];
        
        //拖动
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(selfMove:)];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        panGestureRecognizer.delegate = self;
        _panGestureRecognizer = panGestureRecognizer;
        [self addGestureRecognizer:panGestureRecognizer];
        
        //单击
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
        tapGestureRecognizer.delegate = self;
        _tapGestureRecognizer = tapGestureRecognizer;
        tapGestureRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGestureRecognizer];
        
        originalW = 0.0f;
        originalH = 0.0f;
    }
    return self;
}

-(void)deleteSelf{
    
    [self removeFromSuperview];
    
}

-(void)layoutSubviews{
    if(originalW == 0 && originalH == 0){
        originalW = self.frame.size.width;
        originalH = self.frame.size.height;
    }
    NSLog(@"originalW:%f originalH:%f",originalW , originalH);
}

#pragma mark 缩放
-(void)handlePich:(UIPinchGestureRecognizer *)recognizer
{
    [self setupSelfForCurrentView];
    
    CGFloat width = self.bounds.size.width * recognizer.scale;
    
    CGFloat height = self.bounds.size.height * recognizer.scale;
    
    BOOL isPinch = NO;
    
    if(width <= 50 || height <= 50){

    }else{

        isPinch = YES;
         self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, width, height);
    }

    if(self.delegate && [self.delegate respondsToSelector:@selector(editorBasisViewWithPich:isPinch:)]){
        [self.delegate editorBasisViewWithPich:recognizer isPinch:isPinch];
    }
    
    recognizer.scale = 1;
}

#pragma mark 旋转
-(void)handleRotate:(UIRotationGestureRecognizer *)recognizer
{
    [self setupSelfForCurrentView];

    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);

    if(self.delegate && [self.delegate respondsToSelector:@selector(editorBasisViewWithRotateGesture:)]){
        [self.delegate editorBasisViewWithRotateGesture:recognizer];
    }
    
    recognizer.rotation = 0;
}

#pragma mark 移动
-(void)selfMove:(UIPanGestureRecognizer *)gesture{
    
    [self setupSelfForCurrentView];

    CGPoint translation = [gesture translationInView:self.superview];
    
    self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);

    if(self.delegate && [self.delegate respondsToSelector:@selector(editorBasisViewWithCenter:)]){
        [self.delegate editorBasisViewWithCenter:self];
    }
    
    [gesture setTranslation:CGPointZero inView:self.superview];
    
    [self layoutSubviews];

}

#pragma mark - 单击
-(void)tapView:(UITapGestureRecognizer *)tap{
  
    [self setupSelfForCurrentView];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(setupTapGesture)])
    {
        // 调用代理方法
        [self.delegate setupTapGesture];
        
    }
}

#pragma mark - 代理方法实现旋转 + 缩放捏合 可同时进行
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

//禁止旋转
-(void)Editor_BasisViewCloseRotateGesture{

    [self removeGestureRecognizer:self.rotateRecognizer];

}

//禁止捏合
-(void)Editor_BasisViewClosePichGesture{
    
    [self removeGestureRecognizer:_pinchGestureRecognizer];
    
}
//禁止拖动
-(void)Editor_BasisViewClosePanGesture{
    
    [self removeGestureRecognizer:self.panGestureRecognizer];
    
}

//允许拖动
-(void)Editor_BasisViewAddPanGesture{
    
    [self addGestureRecognizer:self.panGestureRecognizer];
    
}

//设置此View  为当前View
-(void)setupSelfForCurrentView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(setupViewForCurrentView:)])
    {
        // 调用代理方法
        [self.delegate setupViewForCurrentView:self];
        
    }
}
//判断是什么类型的
-(void)setIsImageView:(BOOL)isImageView{
    _isImageView = isImageView;
}
@end
