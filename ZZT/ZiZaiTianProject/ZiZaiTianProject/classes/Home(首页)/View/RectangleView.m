//
//  RectangleView.m
//  手势改动的多边形
//
//  Created by mac on 2018/8/1.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "RectangleView.h"
#import "UIView+Extension.h"
#import "Masonry.h"

@interface RectangleView (){
    //当前的比例
    CGFloat currentProportion;
    
    CGFloat startX;
    CGFloat startY;
    CGFloat startWidth;
    CGFloat startHeight;

    CGFloat selfWidth;
    CGFloat selfHeight;
    CGFloat proportion;
    CGRect lastFrame;
    CGRect nowFrame;

    CGPoint lastCenter;
    CGPoint _startTouchPoint;
    CGPoint _startTouchCenter;
    CGAffineTransform lastTransform;
    
    CGFloat deltaAngle;
    CGRect initialBounds;
    CGFloat initialDistance;
    CGPoint prevPoint;
}

@property (nonatomic,weak) UIView *topBorder;
@property (nonatomic,weak) UIView *leftBorder;
@property (nonatomic,weak) UIView *rightBorder;
@property (nonatomic,weak) UIView *bottomBorder;

@property (nonatomic,weak) UIView *leftOne;
@property (nonatomic,weak) UIView *leftTwo;
@property (nonatomic,weak) UIView *rightOne;
@property (nonatomic,weak) UIView *rightTwo;

@property (nonatomic,strong) UIPanGestureRecognizer *click1;
@property (nonatomic,strong) UIPanGestureRecognizer *click2;
@property (nonatomic,strong) UIPanGestureRecognizer *click3;
@property (nonatomic,strong) UIPanGestureRecognizer *click4;
@property (nonatomic,strong) UIPanGestureRecognizer *angle1;
@property (nonatomic,strong) UIPanGestureRecognizer *angle2;
@property (nonatomic,strong) UIPanGestureRecognizer *angle3;
@property (nonatomic,strong) UIPanGestureRecognizer *angle4;
@property (nonatomic,strong) UIButton *centerBtn;
@property (nonatomic,strong) UIPinchGestureRecognizer *PinchGestureRecognizer;
@property (nonatomic,assign) CGFloat scale;

@end

@implementation RectangleView

int i = 0;

-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.userInteractionEnabled = YES;
        //添加UI
        [self addUI];
        currentProportion = 0;
        self.isBig = NO;
        self.isClick = NO;
        self.scale = 0;
    }
    return self;
}

-(void)setIsBig:(BOOL)isBig{
    _isBig = isBig;
    //没有变大
    if(isBig == NO){
        if(self.isCircle == NO){
            self.mainView.userInteractionEnabled = NO;
            [self.topBorder addGestureRecognizer:self.click1];
            [self.leftBorder addGestureRecognizer:self.click2];
            [self.rightBorder addGestureRecognizer:self.click3];
            [self.bottomBorder addGestureRecognizer:self.click4];
            [self.centerBtn setTitle:@"编辑" forState:UIControlStateNormal];
            self.centerBtn.alpha = 1;
            
            [self.rightOne addGestureRecognizer:self.angle1];
            [self.rightTwo addGestureRecognizer:self.angle2];
            [self.leftOne addGestureRecognizer:self.angle3];
            [self.leftTwo addGestureRecognizer:self.angle4];
        }
    }else{
        //变大
        self.mainView.userInteractionEnabled = YES;
        //边失去控制
        [self.topBorder removeGestureRecognizer:self.click1];
        
        [self.leftBorder removeGestureRecognizer:self.click2];
        
        [self.rightBorder removeGestureRecognizer:self.click3];
        
        [self.bottomBorder removeGestureRecognizer:self.click4];
        
        [self.rightOne removeGestureRecognizer:self.angle1];
        
        [self.rightTwo removeGestureRecognizer:self.angle2];
        
        [self.leftOne removeGestureRecognizer:self.angle3];
        
        [self.leftTwo removeGestureRecognizer:self.angle4];
    }
}

#pragma mark - 对边操作
-(void)tapTarget:(UIPanGestureRecognizer *)panGesture{
    if(self.delegate && [self.delegate respondsToSelector:@selector(checkRectangleView:)]){
        [self.delegate checkRectangleView:self];
    }
    if(![self.curType isEqualToString:self.type])return;
        //改变变量
        CGFloat width = startWidth;
        CGFloat height = startHeight;
        CGFloat x = startX;
        CGFloat y = startY;
    
    //限制这条边的移动范围
    if(panGesture.state == UIGestureRecognizerStateBegan){
        //获取当前状态
        startHeight = self.height;
        startWidth = self.width;
        startX = self.x;
        startY = self.y;
        
        //记录在自己的那个点
        legend_point = [panGesture locationInView:panGesture.view];
        
    }else if(panGesture.state == UIGestureRecognizerStateEnded) {
        
        startHeight = self.height;
        startWidth = self.width;
        startX = self.x;
        startY = self.y;
        //结束时
        lastFrame = self.frame;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateRectangleViewFrame:)]) {
            [self.delegate updateRectangleViewFrame:self];
        }
        
    }else if (panGesture.state == UIGestureRecognizerStateChanged){
        width = startWidth;
        height = startHeight;
        x = startX;
        y = startY;
        
        CGPoint point = [panGesture translationInView:self.superView];
        //换算成中心点
        point.x += panGesture.view.frame.size.width/2.0f - legend_point.x;
        point.y += panGesture.view.frame.size.height/2.0f - legend_point.y;
        //点到自己的位置
        if(panGesture.view.tag == 4){
            height = startHeight + point.y;
            if (height >= self.superView.height - startY) {
                height = self.superView.height - startY;
            }
            height = [self minimumlimit:height];
            
        }else if(panGesture.view.tag == 3){
            width = startWidth + point.x;
            if (width >= self.superView.width - startX) {
                width = self.width;
            }
            width = [self minimumlimit:width];
            
        }else if (panGesture.view.tag == 2){
            x = startX + point.x;
            point.x = [self oppositeNumber:point.x];
            width = startWidth + point.x;
            if (x < 1) {
                x = 1;
                width = self.width;
            }
            width = [self minimumlimit:width];
            if(width == 100){
                x = self.x;
            }else{
                x = startX - point.x;
            }
        }else{
            point.y = [self oppositeNumber:point.y];
            height = startHeight + point.y;
            if (y < 1) {
                y = 1;
                height = self.height;
            }
            height = [self minimumlimit:height];
            if(height == 100){
                y = self.y;
            }else{
                y = startY - point.y;
            }
        }
        self.frame = CGRectMake(x, y, width, height);
    }
}

//成为主View
-(void)beCurrentMainView{
    //把这个view传出去 然后
    if(self.delegate && [self.delegate respondsToSelector:@selector(checkRectangleView:)]){
        [self.delegate checkRectangleView:self];
    }
}

-(void)setIsClick:(BOOL)isClick{
    _isClick = isClick;
    if(self.delegate && [self.delegate respondsToSelector:@selector(checkRectangleView:)]){
        [self.delegate checkRectangleView:self];
    }
}

-(void)setIsHide:(BOOL)isHide{
    _isHide = isHide;
    //隐藏
    if (isHide == YES) {
        self.centerBtn.hidden = YES;
    }else{
        if(self.isBig == NO){
            if([self.curType isEqualToString:self.type])self.centerBtn.hidden = NO;
        }
    }
}

#pragma mark - 初始化
-(void)addUI{
    
    UIView *mainView = [[UIView alloc] init];
    mainView.backgroundColor = [UIColor whiteColor];
    self.mainView = mainView;
    [self addSubview:mainView];
    
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
    
    //四个角落按钮
    UIView *leftOne = [[UIView alloc] init];
    self.leftOne = leftOne;
    leftOne.tag = 1;
    [self addSubview:leftOne];
    
    UIView *leftTwo = [[UIView alloc] init];
    self.leftTwo = leftTwo;
    leftTwo.tag = 2;
    [self addSubview:leftTwo];
    
    UIView *rightOne = [[UIView alloc] init];
    self.rightOne = rightOne;
    rightOne.tag = 3;
    [self addSubview:rightOne];
    
    UIView *rightTwo = [[UIView alloc] init];
    self.rightTwo = rightTwo;
    rightTwo.tag = 4;
    [self addSubview:rightTwo];
    
    //编辑按钮
    UIButton *centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [centerBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [centerBtn setTintColor:[UIColor whiteColor]];
    centerBtn.frame = CGRectMake( self.bounds.size.width / 2,self.bounds.size.height / 2, 100,  100);
    centerBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    centerBtn.backgroundColor = [UIColor colorWithHexString:@"#91EDF2"];
    centerBtn.layer.borderColor = [UIColor colorWithHexString:@"#62C7AC"].CGColor;
    centerBtn.layer.borderWidth = 1.0f;
    centerBtn.layer.cornerRadius = centerBtn.frame.size.height / 2;
    centerBtn.layer.masksToBounds = YES;
    _centerBtn = centerBtn;
    [self addSubview:centerBtn];
    
    //边线
    self.layer.borderWidth = 2.0f;
    
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    //先定四个角  再定四条线
    [leftOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    [leftTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    [rightOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    [rightTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    [topBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(leftOne.mas_right);
        make.right.mas_equalTo(rightOne.mas_left);
    }];
    
    [leftBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(leftOne.mas_bottom);
        make.bottom.mas_equalTo(leftTwo.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.width.mas_equalTo(30);
    }];
    
    [rightBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(rightOne.mas_bottom);
        make.bottom.mas_equalTo(rightTwo.mas_top);
        make.right.mas_equalTo(self.mas_right);
        make.width.mas_equalTo(30);
    }];
    
    [bottomBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(leftTwo.mas_right);
        make.right.mas_equalTo(rightTwo.mas_left);
        make.height.mas_equalTo(30);
    }];
    
    [centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(100);

    }];
    
    //角手势
    UIPanGestureRecognizer *angle1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(angleTarget:)];
    UIPanGestureRecognizer *angle2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(angleTarget:)];

    UIPanGestureRecognizer *angle3 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(angleTarget:)];
    UIPanGestureRecognizer *angle4 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(angleTarget:)];

    [rightOne addGestureRecognizer:angle1];
    [rightTwo addGestureRecognizer:angle2];
    [leftOne addGestureRecognizer:angle3];
    [leftTwo addGestureRecognizer:angle4];

    self.angle1 = angle1;
    self.angle2 = angle2;
    self.angle3 = angle3;
    self.angle4 = angle4;
    
    //边手势
    UIPanGestureRecognizer *click1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapTarget:)];
    UIPanGestureRecognizer *click2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapTarget:)];
    UIPanGestureRecognizer *click3 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapTarget:)];
    UIPanGestureRecognizer *click4 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapTarget:)];

    
    [topBorder addGestureRecognizer:click1];
    [leftBorder addGestureRecognizer:click2];
    [rightBorder addGestureRecognizer:click3];
    [bottomBorder addGestureRecognizer:click4];

    self.click1 = click1;
    self.click2 = click2;
    self.click3 = click3;
    self.click4 = click4;
    
    UIPinchGestureRecognizer *PinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [self addGestureRecognizer:PinchGestureRecognizer];
    _PinchGestureRecognizer = PinchGestureRecognizer;

    //移动
    UIPanGestureRecognizer *PanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(selfMove:)];
    [self addGestureRecognizer:PanGestureRecognizer];
    
    self.layer.masksToBounds = YES;
    
    //单击
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkView:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGestureRecognizer];
    
    [self.centerBtn addTarget:self action:@selector(tapGestureTarget) forControlEvents:UIControlEventTouchUpInside];
}

-(void)angleTarget:(UIPanGestureRecognizer *)gesture{
    if(![self.curType isEqualToString:self.type])return;

    //当前的点
    CGPoint point = [gesture locationInView:self];
    float wChange = 0.0 , hChange = 0.0;

    //原来的点
    //现在的点
    if([gesture state] == UIGestureRecognizerStateBegan){
        
        prevPoint = [gesture locationInView:self];
        
    }else if([gesture state] == UIGestureRecognizerStateChanged){
        //距离
        wChange = (point.x - prevPoint.x);
        hChange = (point.y - prevPoint.y);
        
        CGFloat w = self.width, h = self.height;
        if(self.bounds.size.width < 100){
            w = 100;
        }else if(self.bounds.size.height < 100){
            h = 100;
        }else if(gesture.view.tag == 4){
            w += wChange;
            h += hChange;
        }else if (gesture.view.tag == 1){
            w -= wChange;
            h -= hChange;
        }else if (gesture.view.tag == 2){
            w -= wChange;
            h += hChange;
        }else if (gesture.view.tag == 3){
            w += wChange;
            h -= hChange;
        }
        self.bounds = CGRectMake(self.bounds.origin.x , self.bounds.origin.y , w , h);
        prevPoint = [gesture locationInView:self];
    }else if([gesture state] == UIGestureRecognizerStateEnded){
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateRectangleViewFrame:)]) {
            [self.delegate updateRectangleViewFrame:self];
        }
    }
}

-(void)checkView:(UITapGestureRecognizer *)gesture{
    if(self.delegate && [self.delegate respondsToSelector:@selector(checkRectangleView:)]){
        [self.delegate checkRectangleView:self];
    }
    if([self.curType isEqualToString:self.type]){
        self.isHide = NO;
    }
}

#pragma mark 移动
BOOL isMove;
CGPoint legend_point;
-(void)selfMove:(UIPanGestureRecognizer *)gesture{
    if(gesture.state == UIGestureRecognizerStateBegan){
        if(self.isBig == NO){
                self.isClick = YES;
                if(self.delegate && [self.delegate respondsToSelector:@selector(checkRectangleView:)]){
                    [self.delegate checkRectangleView:self];
                }
                //默认状态为no
            isMove = NO;
            if([self.curType isEqualToString:self.type]){
                self.isHide = NO;
            }
                //获取响应事件的对象
                //获取在屏幕上的点
                CGPoint point = [gesture locationInView:self.superView];
                //如果这个点在V2的范围里面
                //也就是说点击到了V2
                if (CGRectContainsPoint(self.frame, point)) {
                    //记录这个点
                    legend_point = [gesture locationInView:self];
                    //可移动状态
                    isMove = YES;
                }
            }
    }else if (gesture.state == UIGestureRecognizerStateChanged){
        if(self.isBig == NO && [self.curType isEqualToString:self.type]){
                if(self.delegate && [self.delegate respondsToSelector:@selector(setupMainView:)]){
                    [self.delegate setupMainView:self];
                }
                //    如果是可移动状态
                if (!isMove) {
                    return;
                }
                //自动释放池
                @autoreleasepool {
                    CGPoint translation = [gesture translationInView:self.superView];
                    gesture.view.transform = CGAffineTransformTranslate(gesture.view.transform, translation.x, translation.y);
                    [gesture setTranslation:CGPointZero inView:self.superView];
                }
            }
        }else if (gesture.state == UIGestureRecognizerStateEnded){
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateRectangleViewFrame:)]) {
                [self.delegate updateRectangleViewFrame:self];
            }
        }
}

-(void)closeView{
    [self tapGestureTarget];
}

#pragma mark - 删除事件
-(void)removeGestureRecognizer{
    self.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeRectangleView" object:self];
}

#pragma mark - 双击事件
-(void)tapGestureTarget{
    //放大后 frame 的值 有所变化
    //计算倍数
    CGFloat pW = self.superView.width / self.width;
    CGFloat pH = self.superView.height / self.height;

    //如果没有放大  那么放大
    if(self.isBig == NO){
        //原来的大小
        selfHeight = self.height;
        selfWidth = self.width;

        lastTransform = self.transform;
        lastCenter = self.center;
        if(self.isCircle == YES || pW < pH){
            //圆
            proportion = self.superView.width / selfWidth;
            self.transform = CGAffineTransformScale(self.transform, proportion, proportion);
        NSLog(@"22222:%@",NSStringFromCGSize(CGSizeApplyAffineTransform(self.bounds.size,self.transform)));
        }else{
            //方型
            proportion = self.superView.height / selfHeight;
            self.transform = CGAffineTransformScale(self.transform, proportion, proportion);
        }
        self.x = 0;
        self.y = 0;

        //放大了
        [self removeGestureRecognizer:_PinchGestureRecognizer];

        //放大后代理
        self.isBig = YES;
        if(self.delegate && [self.delegate respondsToSelector:@selector(enlargedAfterEditView:isBig:proportion:)]){
            [self.delegate enlargedAfterEditView:self isBig:self.isBig proportion:proportion];
        }
        self.centerBtn.hidden = YES;
    }else{
        //计算比例
        NSLog(@"ppppp1%f",proportion);
        if(pW < pH){
            proportion = selfWidth/self.superView.width;
        }else{
            proportion = selfHeight/self.superView.height;
        }

        NSLog(@"ppppp2%f",proportion);
        //变回原来的样子
        self.transform = CGAffineTransformScale(self.transform, proportion, proportion);
        
        self.center = lastCenter;

        self.isBig = NO;
        if(self.delegate && [self.delegate respondsToSelector:@selector(enlargedAfterEditView:isBig:proportion:)]){
            [self.delegate enlargedAfterEditView:self isBig:self.isBig proportion:proportion];
        }
        [self addGestureRecognizer:_PinchGestureRecognizer];
        self.centerBtn.hidden = NO;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateRectangleViewFrame:)]) {
        [self.delegate updateRectangleViewFrame:self];
    }
}

#pragma mark - 捏合手势
-(void)pinch:(UIPinchGestureRecognizer *)gesture{
    if(self.delegate && [self.delegate respondsToSelector:@selector(checkRectangleView:)]){
        [self.delegate checkRectangleView:self];
    }
    if([self.curType isEqualToString:self.type]){
        gesture.view.transform = CGAffineTransformScale(gesture.view.transform, gesture.scale, gesture.scale);
        self.scale += gesture.scale;
        gesture.scale = 1;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(updatePinchRectangleView:)]) {
        [self.delegate updatePinchRectangleView:self];
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

-(void)setIsCircle:(BOOL)isCircle{
    _isCircle = isCircle;
    //边失去控制
    if(isCircle == YES){
        [self.topBorder removeGestureRecognizer:self.click1];
        
        [self.leftBorder removeGestureRecognizer:self.click2];
        
        [self.rightBorder removeGestureRecognizer:self.click3];
        
        [self.bottomBorder removeGestureRecognizer:self.click4];
        
        [self.leftOne removeGestureRecognizer:self.angle3];
        
        [self.rightOne removeGestureRecognizer:self.angle1];
        
        [self.rightTwo removeGestureRecognizer:self.angle2];
        
        [self.leftTwo removeGestureRecognizer:self.angle4];
    }
}
@end
