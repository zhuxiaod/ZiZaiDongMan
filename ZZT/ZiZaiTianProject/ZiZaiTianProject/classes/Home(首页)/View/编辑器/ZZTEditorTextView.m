//
//  ZZTEditorTextView.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/1/9.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import "ZZTEditorTextView.h"

@interface ZZTEditorTextView (){
    CGPoint prevPoint;
    
    CGFloat selfX;
    
    CGFloat selfY;
    
    CGFloat selfW;
    
    CGFloat selfH;
    
    CGAffineTransform lastTransform;
    
    CGPoint lastCenter;
    
    CGFloat proportion;
    
}
//2条控制边
@property (nonatomic,strong) UIView *rightBorder;

@property (nonatomic,strong) UIView *leftBorder;

@end

@implementation ZZTEditorTextView

//旁白
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //禁止旋转
        [self Editor_BasisViewCloseRotateGesture];
        //禁止放大
        [self Editor_BasisViewClosePichGesture];
        
        [self setupUI];
        
    }
    return self;
}

-(void)setupUI{
    self.backgroundColor = [UIColor whiteColor];

    //通过2条边 来控制自身的大小
    UIView *rightBorder = [[UIView alloc] init];
    _rightBorder = rightBorder;
    rightBorder.tag = 1;
    [self addSubview:rightBorder];
    
    UIView *leftBorder = [[UIView alloc] init];
    _leftBorder = leftBorder;
    leftBorder.tag = 2;
    [self addSubview:leftBorder];
    
    //边手势
    UIPanGestureRecognizer *borderGestureOne = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapTarget:)];
    UIPanGestureRecognizer *borderGestureTwo = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapTarget:)];
    [rightBorder addGestureRecognizer:borderGestureOne];
    [leftBorder addGestureRecognizer:borderGestureTwo];
}

-(void)layoutSubviews{
    [self.rightBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
        make.width.mas_equalTo(30);
    }];
    
    [self.leftBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.width.mas_equalTo(30);
    }];
}

#pragma mark - 对边操作
-(void)tapTarget:(UIPanGestureRecognizer *)panGesture{
    
    //改变变量
    CGFloat width = selfW;
    CGFloat height = selfH;
    CGFloat x = selfX;
    CGFloat y = selfY;
    
    //限制这条边的移动范围
    if(panGesture.state == UIGestureRecognizerStateBegan){
        //获取当前状态
        prevPoint = [panGesture locationInView:panGesture.view];
    
        //记录一下点位
        selfX = self.x;
        selfY = self.y;
        selfW = self.width;
        selfH = self.height;
        
    }else if(panGesture.state == UIGestureRecognizerStateEnded) {
        
        selfX = self.x;
        selfY = self.y;
        selfW = self.width;
        selfH = self.height;
        
    }else if (panGesture.state == UIGestureRecognizerStateChanged){
        
        width = selfW;
        height = selfH;
        x = selfX;
        y = selfY;
        
        CGPoint point = [panGesture translationInView:self.superview];
        //换算成中心点
        point.x += panGesture.view.frame.size.width/2.0f - prevPoint.x;
        
        point.y += panGesture.view.frame.size.height/2.0f - prevPoint.y;
        
        //点到自己的位置
        if(panGesture.view.tag == 1){
            width = selfW + point.x;
            if (width >= self.superview.width - selfW) {
                width = self.superview.width - selfW;
            }
            width = [self minimumlimit:width];
            
        }else if(panGesture.view.tag == 2){
            x = selfX + point.x;
            point.x = [self oppositeNumber:point.x];
            width = selfW + point.x;

            if (width >= self.superview.width - selfX) {
                width = self.width;
            }
            width = [self minimumlimit:width];
            
        }else if (panGesture.view.tag == 2){
            x = selfX + point.x;
            point.x = [self oppositeNumber:point.x];
            width = selfW + point.x;
            if (x < 1) {
                x = 1;
                width = self.width;
            }
            width = [self minimumlimit:width];
            if(width == 100){
                x = self.x;
            }else{
                x = selfX - point.x;
            }
        }else{
            point.y = [self oppositeNumber:point.y];
            height = selfH + point.y;
            if (y < 1) {
                y = 1;
                height = self.height;
            }
            height = [self minimumlimit:height];
            if(height == 100){
                y = self.y;
            }else{
                y = selfY - point.y;
            }
        }
        self.frame = CGRectMake(x, y, width, height);
    }
}

//最小限制
-(CGFloat)minimumlimit:(CGFloat)num{
    if(num < 100){
        num = 100;
    }
    return num;
}

//相反数
-(CGFloat)oppositeNumber:(CGFloat)number{
    if(number < 0){
        number = ABS(number);
    }else{
        number = -number;
    }
    return number;
}

@end
