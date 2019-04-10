
//
//  ZZTSquareRoundView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/28.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTSquareRoundView.h"
#import "CAShapeLayer+ViewMask.h"

@interface ZZTSquareRoundView ()<ZZTEditorBasisViewDelegate>{
    CGPoint prevPoint;
    
    CGFloat selfX;
    
    CGFloat selfY;
    
    CGFloat selfW;
    
    CGFloat selfH;

    CGAffineTransform lastTransform;

    CGPoint lastCenter;

    CGFloat proportion;
}

//四条边
@property (nonatomic,strong) UIView *topBorder;

@property (nonatomic,strong) UIView *leftBorder;

@property (nonatomic,strong) UIView *rightBorder;

@property (nonatomic,strong) UIView *bottomBorder;
//四个角落按钮
@property (nonatomic,strong) UIView *rightOne;//左上

@property (nonatomic,strong) UIView *leftTwo;//左下

@property (nonatomic,strong) UIView *rightTwo;//右下
//手势
@property (nonatomic,strong) UIPanGestureRecognizer *borderGestureOne;

@property (nonatomic,strong) UIPanGestureRecognizer *borderGestureTwo;

@property (nonatomic,strong) UIPanGestureRecognizer *borderGestureThree;

@property (nonatomic,strong) UIPanGestureRecognizer *borderGestureFour;

@property (nonatomic,strong) UIPanGestureRecognizer *angle1;

@property (nonatomic,strong) UIPanGestureRecognizer *angle2;

@property (nonatomic,strong) UIPanGestureRecognizer *angle3;

@property (nonatomic,strong) UIPanGestureRecognizer *angle4;

@property (nonatomic,strong) UIButton *centerBtn;

@property (nonatomic,strong) UITapGestureRecognizer *rightOnetapGesture;

@property (nonatomic,assign) CGFloat scale;

@property (nonatomic,strong) CAShapeLayer *editor_layer;

@property (nonatomic,strong) UIPinchGestureRecognizer *pinchGesture;

@property (nonatomic,strong) UIView *maskView;

@property (nonatomic,weak) UIView *leftOneView;

@end

@implementation ZZTSquareRoundView

//正方形和圆形
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //禁止旋转
        [self Editor_BasisViewCloseRotateGesture];
        //禁止放大
        [self Editor_BasisViewClosePichGesture];
    
        [self setupUI];
        //初始化是没有放大的
        self.isBig = NO;
        
        self.layer.masksToBounds = YES;
        
        self.scale = 1;
        
        self.mainView.backgroundColor = [UIColor whiteColor];
        
        self.isImageView = NO;
        //添加捏合放大手势
        [self addPinchGesture];
        
        self.delegate = self;
    }
    return self;
}

-(void)addPinchGesture{
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self addGestureRecognizer:pinchGesture];
    _pinchGesture = pinchGesture;
}

-(void)removePinchGesture{
    [self removeGestureRecognizer:_pinchGesture];
}

-(void)pinchView:(UIPinchGestureRecognizer *)gesture{
    self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width * gesture.scale, self.bounds.size.height *  gesture.scale);
    
    self.mainView.transform = CGAffineTransformScale(self.mainView.transform, gesture.scale, gesture.scale);
    
    self.maskView.transform = CGAffineTransformScale(self.maskView.transform, gesture.scale, gesture.scale);

    
    gesture.scale = 1;
}

-(void)addGesture{
    
    //边手势
    [self.topBorder addGestureRecognizer:self.borderGestureOne];
    [self.leftBorder addGestureRecognizer:self.borderGestureTwo];
    [self.rightBorder addGestureRecognizer:self.borderGestureThree];
    [self.bottomBorder addGestureRecognizer:self.borderGestureFour];
    
    [self.rightOne addGestureRecognizer:self.angle1];
    [self.rightTwo addGestureRecognizer:self.angle2];
    [self.leftOneView addGestureRecognizer:self.angle3];
    [self.leftTwo addGestureRecognizer:self.angle4];
}

-(void)removeGesture{
    
    //边手势
    [self.topBorder removeGestureRecognizer:self.borderGestureOne];
    [self.leftBorder removeGestureRecognizer:self.borderGestureTwo];
    [self.rightBorder removeGestureRecognizer:self.borderGestureThree];
    [self.bottomBorder removeGestureRecognizer:self.borderGestureFour];
    
    [self.rightOne removeGestureRecognizer:self.angle1];
    [self.rightTwo removeGestureRecognizer:self.angle2];
    [self.leftOneView removeGestureRecognizer:self.angle3];
    [self.leftTwo removeGestureRecognizer:self.angle4];
}

//移除边手势
-(void)removeBorderGesture{
    //边手势
    [self.topBorder removeGestureRecognizer:self.borderGestureOne];
    [self.leftBorder removeGestureRecognizer:self.borderGestureTwo];
    [self.rightBorder removeGestureRecognizer:self.borderGestureThree];
    [self.bottomBorder removeGestureRecognizer:self.borderGestureFour];
}

-(void)setupUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
    //主视图  控制控件的层 在编辑按钮之下
    UIView *mainView = [[UIView alloc] init];
    self.mainView = mainView;
    [self addSubview:mainView];
 
    //四个角落按钮
    UIImageView *leftOne = [[UIImageView alloc] init];
    [leftOne setImage:[UIImage imageNamed:@"deletMartarel"]];
    leftOne.userInteractionEnabled = YES;
    leftOne.contentMode = UIViewContentModeScaleAspectFit;
    self.leftOne = leftOne;
    
//    [leftOne setBackgroundColor:[UIColor blueColor]];
    
    [self addSubview:leftOne];
    
    UIView *leftOneView = [[UIView alloc] init];
    leftOneView.tag = 5;
    _leftOneView = leftOneView;
    [self addSubview:leftOneView];
    
    UIView *leftTwo = [[UIView alloc] init];
    self.leftTwo = leftTwo;
//    [leftTwo setBackgroundColor:[UIColor blueColor]];
    leftTwo.tag = 6;
    [self addSubview:leftTwo];
    
//    UIView *rightOne = [[UIView alloc] init];
////    [rightOne setBackgroundColor:[UIColor blueColor]];
//    self.rightOne = rightOne;
//    rightOne.tag = 7;
//    [self addSubview:rightOne];
    
    UIView *rightOne = [[UIView alloc] init];
    self.rightOne = rightOne;

    rightOne.tag = 7;
    [self addSubview:rightOne];
    
    UIView *rightTwo = [[UIView alloc] init];
//    [rightTwo setBackgroundColor:[UIColor blueColor]];
    self.rightTwo = rightTwo;
    rightTwo.tag = 8;
    [self addSubview:rightTwo];

    //角手势
    UIPanGestureRecognizer *rightOneGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(angleTarget:)];
    UIPanGestureRecognizer *rightTwoGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(angleTarget:)];
    UIPanGestureRecognizer *leftOneGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(angleTarget:)];
    UIPanGestureRecognizer *leftTwoGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(angleTarget:)];

    self.angle1 = rightOneGesture;
    self.angle2 = rightTwoGesture;
    self.angle3 = leftOneGesture;
    self.angle4 = leftTwoGesture;
    
    //点击手势
    UITapGestureRecognizer *rightOnetapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteSelf)];
    _rightOnetapGesture = rightOnetapGesture;

    [self addGesture];
    
    //创建4条边
    UIView *topBorder = [[UIView alloc] init];
    topBorder.tag = 1;
    topBorder.backgroundColor = [UIColor clearColor];
    self.topBorder = topBorder;
    [self addSubview:topBorder];
    
    UIView *leftBorder = [[UIView alloc] init];
    leftBorder.tag = 2;
    leftBorder.backgroundColor = [UIColor clearColor];
    self.leftBorder = leftBorder;
    [self addSubview:leftBorder];
    
    UIView *rightBorder = [[UIView alloc] init];
    rightBorder.tag = 3;
    self.rightBorder = rightBorder;
    rightBorder.backgroundColor = [UIColor clearColor];
    [self addSubview:rightBorder];
    
    UIView *bottomBorder = [[UIView alloc] init];
    bottomBorder.tag = 4;
    self.bottomBorder = bottomBorder;
    bottomBorder.backgroundColor = [UIColor clearColor];
    [self addSubview:bottomBorder];
    
    //边手势
    UIPanGestureRecognizer *borderGestureOne = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapTarget:)];
    UIPanGestureRecognizer *borderGestureTwo = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapTarget:)];
    UIPanGestureRecognizer *borderGestureThree = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapTarget:)];
    UIPanGestureRecognizer *borderGestureFour = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapTarget:)];
    
    self.borderGestureOne = borderGestureOne;
    self.borderGestureTwo = borderGestureTwo;
    self.borderGestureThree = borderGestureThree;
    self.borderGestureFour = borderGestureFour;
    
    //编辑按钮
    UIButton *centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [centerBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [centerBtn setTintColor:[UIColor whiteColor]];
    centerBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    centerBtn.backgroundColor = [UIColor colorWithHexString:@"#91EDF2"];
    centerBtn.layer.borderColor = [UIColor colorWithHexString:@"#62C7AC"].CGColor;
    centerBtn.layer.borderWidth = 1.0f;
    centerBtn.layer.cornerRadius = 50 / 2;
    centerBtn.layer.masksToBounds = YES;
    _centerBtn = centerBtn;
    [self addSubview:centerBtn];
    
    [self.centerBtn addTarget:self action:@selector(tapGestureTarget) forControlEvents:UIControlEventTouchUpInside];
    
    //边线
    self.layer.borderWidth = 2.0f;
    self.layer.borderColor = [UIColor blackColor].CGColor;

    //创建一个专门装线的View
    UIView *maskView = [[UIView alloc] init];
    maskView.userInteractionEnabled = NO;
    self.maskView = maskView;
    [self addSubview:maskView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.mainView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);

    //先定四个角  再定四条线
    [self.leftOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(2);
        make.left.equalTo(self.mas_left).offset(2);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];
    
    [self.leftOneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    [self.leftTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    [self.rightOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    [self.rightTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    [self.topBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.height.mas_equalTo(30);
        make.left.equalTo(self.leftOneView.mas_right);
        make.right.equalTo(self.rightOne.mas_left);
    }];
    
    [self.leftBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftOneView.mas_bottom);
        make.bottom.equalTo(self.leftTwo.mas_top);
        make.left.equalTo(self.mas_left);
        make.width.mas_equalTo(30);
    }];
    
    [self.rightBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftOneView.mas_bottom);
        make.bottom.equalTo(self.rightTwo.mas_top);
        make.right.equalTo(self.mas_right);
        make.width.mas_equalTo(30);
    }];
    
    [self.bottomBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.leftTwo.mas_right);
        make.right.equalTo(self.rightTwo.mas_left);
        make.height.mas_equalTo(30);
    }];
    
    [self.centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];

    self.maskView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
}

//拖动角的手势
-(void)angleTarget:(UIPanGestureRecognizer *)gesture{
    
    //禁止拖动
    [self Editor_BasisViewClosePanGesture];
    
    //当前的点
    CGPoint point = [gesture locationInView:self];
    CGPoint superPoint = [gesture locationInView:self.superview];

    CGFloat wChange = 0.0 , hChange = 0.0;
    
    //原来的点
    //现在的点
    if([gesture state] == UIGestureRecognizerStateBegan){
        
        prevPoint = [gesture locationInView:self];
        
        //记录一下点位
        selfX = self.x;
        selfY = self.y;
        selfW = self.width;
        selfH = self.height;
        
    }else if([gesture state] == UIGestureRecognizerStateChanged){
        //距离
        wChange = (point.x - prevPoint.x);
        hChange = (point.y - prevPoint.y);
        
        CGFloat w = self.width, h = self.height;
        
        NSLog(@"w:%f h:%f",w,h);
        
        CGFloat originalArea = w * h;
        
        // x坐标 y坐标
        CGFloat x = self.x;
        CGFloat y = self.y;
        
        if(gesture.view.tag == 8){
            //右下
            if(CGRectGetMaxX(self.frame) > self.x && CGRectGetMaxY(self.frame) > self.y){
                
                if(point.x > 100){
                    w += wChange;
                }
                
                if(point.y > 100){
                    h += hChange;
                }
            }
        }else if (gesture.view.tag == 5){
            //左上
            NSLog(@"我是5");
            //计算出XY的值
            selfX += wChange;
            selfY += hChange;
        
            if(superPoint.x < CGRectGetMaxX(self.frame) - 90){
                w -= wChange;
                x = selfX;
            }
            if(superPoint.y < CGRectGetMaxY(self.frame) - 90){
                h -= hChange;
                y = selfY;
            }
        }else if (gesture.view.tag == 6){
            //左下
            NSLog(@"我是6");
          
            if(point.y > 100){
                h += hChange;
            }
            //10误差
            if(superPoint.x < CGRectGetMaxX(self.frame) - 90){
                w -= wChange;
                x += wChange;
            }
            
        }else if (gesture.view.tag == 7){
            //右上
            NSLog(@"我是7");
            selfX -= wChange;
            selfY += hChange;
            if(point.x > 100){
                w += wChange;
            }
            //10误差
            if(superPoint.y < CGRectGetMaxY(self.frame) - 90){
                h -= hChange;
                y += hChange;
            }
        }
        
//        CGFloat nowArea = w * h;
        
//        CGFloat multiple = nowArea / originalArea;
        
        self.frame = CGRectMake(x, y, w, h);

        
//        self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width * multiple, self.bounds.size.height * multiple);
        
//        self.mainView.transform = CGAffineTransformScale(self.mainView.transform, multiple, multiple);
//
//        self.maskView.transform = CGAffineTransformScale(self.maskView.transform, multiple, multiple);
        
        prevPoint = [gesture locationInView:self];
        
    }else if([gesture state] == UIGestureRecognizerStateEnded){
        //开启手势
        [self Editor_BasisViewAddPanGesture];
    }
}

#pragma mark - 对边操作
-(void)tapTarget:(UIPanGestureRecognizer *)panGesture{
    
//    //改变变量
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
        if(panGesture.view.tag == 4){
            height = selfH + point.y;
            if (height >= self.superview.height - selfY) {
                height = self.superview.height - selfY;
            }
            height = [self minimumlimit:height];
            
        }else if(panGesture.view.tag == 3){
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

#pragma mark - 点击编辑按钮
-(void)tapGestureTarget{
    
    //计算倍数
    CGFloat pW = self.superview.width / self.width;
    CGFloat pH = self.superview.height / self.height;
    
    NSLog(@"pW:%f pH:%f",pW,pH);
    
    //如果没有放大  那么放大
    if(self.isBig == NO){
        [self removePinchGesture];
        //原来的大小
        selfH = self.height;
        selfW = self.width;
        
        NSLog(@"selfW:%f,selfH:%f",selfW,selfH);
        
        lastTransform = self.transform;
        lastCenter = self.center;
   
        if(pW < pH || pW == pH){
            //圆
            proportion = self.superview.width / selfW;
            self.transform = CGAffineTransformScale(self.transform, proportion, proportion);
            
        }else{

            proportion = (self.superview.height - ZZTLayoutDistance(100))/ selfH ;
            self.transform = CGAffineTransformScale(self.transform, proportion, proportion);
        
        }
        
        self.x = 0;
        self.y = ZZTLayoutDistance(100);
        
        //放大后 禁止移动
        [self Editor_BasisViewClosePanGesture];
        
        //禁止对边进行操作
        [self removeGesture];
        
        //放大后代理
        self.isBig = YES;
        
        if (self.squareRounddelegate && [self.squareRounddelegate respondsToSelector:@selector(squareRoundViewWillEditorWithView:)])
        {
            // 调用代理方法
            [self.squareRounddelegate squareRoundViewWillEditorWithView:self];
        }
        
        self.centerBtn.hidden = YES;
        
        self.leftOne.hidden = YES;
        
        //可以控制方框里面的视图
        self.mainView.userInteractionEnabled = YES;

        
    }else{
        [self addPinchGesture];

        //计算比例
        NSLog(@"ppppp1%f",proportion);
        if(pW < pH){
            proportion = selfW/self.superview.width;
        }else{
            proportion = selfH/ (self.superview.height - ZZTLayoutDistance(100));
        }
        
        //变回原来的样子
        self.transform = CGAffineTransformScale(self.transform, proportion, proportion);
        
        self.center = lastCenter;
        
        self.isBig = NO;
        
        //恢复移动
        [self Editor_BasisViewAddPanGesture];
   
        
        //如果是圆 禁止对边操作
        if(self.type == squareRoundViewTypeSquare){
            //方型
            //恢复手势
            [self addGesture];
        }
        
        if (self.squareRounddelegate && [self.squareRounddelegate respondsToSelector:@selector(squareRoundViewDidEditorWithView:)])
        {
            // 调用代理方法
            [self.squareRounddelegate squareRoundViewDidEditorWithView:self];
        }

        self.centerBtn.hidden = YES;

        //不可触摸
        self.mainView.userInteractionEnabled = NO;
        
    }
}

//添加素材
-(void)Editor_addSubView:(UIView *)view{
    [self.mainView addSubview:view];

}

//监听大小  如果是小 所有手势返回self
//in every view .m overide those methods
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView * view = [super hitTest:point withEvent:event];
    
    if(self.isBig == NO && [view isKindOfClass:[ZZTEditorBasisView class]]){
        [self.leftOne setImage:[UIImage imageNamed:@"deletMartarel"]];
        return self;
    }
    
    return view;
}

//设置编辑按钮是否隐藏
-(void)editorBtnHidden:(BOOL)isHidden{
    self.centerBtn.hidden = isHidden;
    self.leftOne.hidden = isHidden;
    
    if(self.leftOne.hidden){
        //隐藏 去除点击
        [self.leftOneView removeGestureRecognizer:_rightOnetapGesture];
    }else{
        [self.leftOneView addGestureRecognizer:_rightOnetapGesture];
    }
}

//移除自己
-(void)deleteSelf{
    
    [self removeFromSuperview];
    
}

#pragma mark - 移动上下层
-(void)SquareRound_moveCurrentImageViewToLastLayer{
    //得到桌面上的所有View
    //    NSArray *array = self.subviews;
    //知道当前view的索引
    NSInteger index = [self getCurrentViewIndex:self.currentView];
    //对换位置
    //判断是不是最后一层
    if(index == self.mainView.subviews.count - 1){
        NSLog(@"不能上一层了");
    }else{
        [self.mainView exchangeSubviewAtIndex:index withSubviewAtIndex:index + 1];
    }
}

//下一层 -- 普通视图
-(void)SquareRound_moveCurrentImageViewToNextLayer{
    //得到桌面上的所有View
    //    NSArray *array = self.subviews;
    //知道当前view的索引
    NSInteger index = [self getCurrentViewIndex:self.currentView];
    //对换位置
    //判断是不是最后一层
    if(index == 0){
        NSLog(@"不能下一层了");
    }else{
        [self.mainView exchangeSubviewAtIndex:index withSubviewAtIndex:index - 1];
    }
}

-(NSInteger)getCurrentViewIndex:(ZZTEditorBasisView *)view{
    NSInteger index = 0;
    for(NSInteger i = 0; i < self.mainView.subviews.count;i++){
        UIView *subview = self.mainView.subviews[i];
        ZZTEditorBasisView *currentView = (ZZTEditorBasisView *)subview;
        if (currentView == view) {
            index = i;
        }
    }
    return index;
}

-(void)setType:(squareRoundViewType)type{
    _type = type;
    
    if (self.type == squareRoundViewTypeStraightEllipse || self.type == squareRoundViewTypeTowardEllipse || self.type == squareRoundViewTypeRound){

        //取消边线 （后面改）
        self.layer.borderColor = [UIColor clearColor].CGColor;

        [self removeGesture];
        //正椭圆
        CAShapeLayer *editor_layer = [CAShapeLayer createStraightEllipseMaskLayerWithView:self];
        //遮罩
        self.mainView.layer.mask = editor_layer;
        //线
        CAShapeLayer *editorLayer = [CAShapeLayer createStraightEllipseBorderLayerWithView:self];

        [self.maskView.layer addSublayer:editorLayer];
    }
    
    self.backgroundColor = [UIColor clearColor];
    
}


@end
