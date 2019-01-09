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
        //添加UI
        [self addUI];
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
        _tapGestureRecognizer = tapGestureRecognizer;
        tapGestureRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGestureRecognizer];
        
//        self.backgroundColor = [UIColor redColor];
        
//        //删除按钮
//        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _deleteBtn = deleteBtn;
//        [deleteBtn setImage:[UIImage imageNamed:@"deletMartarel"] forState:UIControlStateNormal];
//        [deleteBtn addTarget:self action:@selector(deleteSelf) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:deleteBtn];
        
    }
    return self;
}

-(void)deleteSelf{
    
    [self removeFromSuperview];
    
}

//-(void)layoutSubviews{
//
//    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self);
//        make.right.equalTo(self);
//        make.height.width.mas_equalTo(40);
//    }];
//}

-(void)addUI{
    
}

#pragma mark 缩放
-(void)handlePich:(UIPinchGestureRecognizer *)recognizer
{
    [self setupSelfForCurrentView];

    //代理方法
    //点击的是当前view
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    
    recognizer.scale = 1;

}

#pragma mark 旋转
-(void)handleRotate:(UIRotationGestureRecognizer *)recognizer
{

    [self setupSelfForCurrentView];

    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);

    recognizer.rotation = 0;

}

#pragma mark 移动
-(void)selfMove:(UIPanGestureRecognizer *)gesture{
    
    [self setupSelfForCurrentView];

    CGPoint translation = [gesture translationInView:self.superview];
    
    self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);

    [gesture setTranslation:CGPointZero inView:self.superview];
    
    [self layoutSubviews];

}

#pragma mark - 单击
-(void)tapView:(UITapGestureRecognizer *)tap{
  
    [self setupSelfForCurrentView];
    
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
    
    [self removeGestureRecognizer:self.pinchGestureRecognizer];
    
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
@end
