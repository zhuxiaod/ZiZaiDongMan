//
//  ZZTEditorTextView.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/1/9.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import "ZZTEditorTextView.h"
#import "UIView+DottedLine.h"
#import "CAShapeLayer+ViewMask.h"

@interface ZZTEditorTextView ()<ZZTEditorBasisViewDelegate>{
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

@property (nonatomic,strong) UILabel *textLab;

@property(nonatomic,strong) UIImageView *imageView;

@property(nonatomic,strong) UIImageView *lineView;

@end

@implementation ZZTEditorTextView

//旁白
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
        
        self.backgroundColor = [UIColor whiteColor];

        self.delegate = self;
        
        self.fontSize = 17;
    }
    return self;
}

-(void)setupUI{

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    _imageView = imageView;
    [self addSubview:imageView];
    
    //通过2条边 来控制自身的大小
    UIView *rightBorder = [[UIView alloc] init];
    _rightBorder = rightBorder;
    rightBorder.tag = 1;
    [self addSubview:rightBorder];
    
//    UIView *leftBorder = [[UIView alloc] init];
//    _leftBorder = leftBorder;
//    leftBorder.tag = 2;
//    [self addSubview:leftBorder];
    
    //边手势
    UIPanGestureRecognizer *borderGestureOne = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapTarget:)];
//    UIPanGestureRecognizer *borderGestureTwo = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapTarget:)];
    [rightBorder addGestureRecognizer:borderGestureOne];
//    [leftBorder addGestureRecognizer:borderGestureTwo];
    
    //lab
    UILabel *textLab = [[UILabel alloc] init];
    textLab.text = @"点击输入文字";
    textLab.numberOfLines = 0;
    _textLab = textLab;
    [self addSubview:textLab];
    
    //边线
    self.layer.cornerRadius = 10.0f;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 1.0f;
    
    //删除按钮
    UIButton *closeImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeImageView setImage:[UIImage imageNamed:@"deletMartarel"] forState:UIControlStateNormal];
    _closeImageView = closeImageView;
    [self addSubview:closeImageView];
    
    [closeImageView addTarget:self action:@selector(deleteGesture) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *lineView = [[UIImageView alloc] init];
    _lineView = lineView;
    lineView.userInteractionEnabled = NO;
    [self addSubview:lineView];
}

-(void)deleteGesture{
    [self removeFromSuperview];
    
    if (self.textViewDelegate && [self.textViewDelegate respondsToSelector:@selector(textViewHidden)])
    {
        // 调用代理方法
        [self.textViewDelegate textViewHidden];
    }
}

#pragma mark - 为视图添加文本
-(void)editorText{
 
    if (self.textViewDelegate && [self.textViewDelegate respondsToSelector:@selector(textViewShowInputView:)])
    {
        // 调用代理方法
        [self.textViewDelegate textViewShowInputView:self];
    }
}

//这个View被点击了
-(void)setupViewForCurrentView:(ZZTEditorBasisView *)view{
    
    //将这个View传出去  告诉桌面是哪一个View
    if (self.textViewDelegate && [self.textViewDelegate respondsToSelector:@selector(textViewForCurrentView:)])
    {
        // 调用代理方法
        [self.textViewDelegate textViewForCurrentView:self];
    }
}

-(void)layoutSubviews{
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self);
    }];
    
    [self.rightBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
        make.width.mas_equalTo(20);
    }];
    
//    [self.leftBorder mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self);
//        make.bottom.equalTo(self);
//        make.left.equalTo(self);
//        make.width.mas_equalTo(20);
//    }];
    
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(10);
    }];
    
    [self.closeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.width.height.mas_equalTo(20);
    }];
    
    self.lineView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
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
        
    }else if(panGesture.state == UIGestureRecognizerStateEnded){
        
        selfX = self.x;
        selfY = self.y;
        selfW = self.width;
        selfH = self.height;
        
        [self setNeedsDisplay];

        
    }else if (panGesture.state == UIGestureRecognizerStateChanged){
        
        width = selfW;
        height = selfH;
        x = selfX;
        y = selfY;
        
        CGPoint point = [panGesture translationInView:self.superview];
        //换算成中心点
//        point.x += panGesture.view.frame.size.width/2.0f - prevPoint.x;
//
//        point.y += panGesture.view.frame.size.height/2.0f - prevPoint.y;
        
        //点到自己的位置
        if(panGesture.view.tag == 1){
            
            width = selfW + point.x;

            width = [self minimumlimit:width];
            
        }else if(panGesture.view.tag == 2){
            
            x = selfX + point.x;
            
            point.x = [self oppositeNumber:point.x];
            
            width = selfW + point.x;

            width = [self minimumlimit:width];
            
        }
        
        if(self.textLab.text){
            height = [self.textLab.text heightWithWidth:width - 20 font:self.fontSize];
            height += 20;
        }
        
        NSLog(@"pointX:%f , pointY:%f",point.x,point.y);
        NSLog(@"width:%f",width);
        
        //得到当前的Width
        self.frame = CGRectMake(x, y, width, height);
    }
}

//最小限制
-(CGFloat)minimumlimit:(CGFloat)num{
    //能放下当前一个字号 _fontSize
    CGFloat replyCountWidth = [@"宽" getTextWidthWithFont:self.textLab.font];
    replyCountWidth += 20;
    if(num < replyCountWidth){
        num = replyCountWidth;
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

-(void)setInputText:(NSString *)inputText{
    _inputText = inputText;
    
    self.textLab.text = inputText;
    
    [self setupViewHeight];
}

-(void)setupViewHeight{
    //适应高度
    CGFloat height = [self.textLab.text heightWithWidth:self.width - 20 font:self.fontSize];
    
    self.frame = CGRectMake(self.x, self.y, self.width, height + 20);
    
    if(_textLab.text.length == 0){
        self.frame = CGRectMake(self.x, self.y, self.width, 30);
    }
}

//设置样式
-(void)setType:(editorTextViewType)type{
    _type = type;
    //背景透明的
    if(type == editorTextViewTypeBGClear){
//        [self setNeedsDisplay];
    }else if (type == editorTextViewTypeBGWhite){
        self.backgroundColor = [UIColor whiteColor];
    }else{
        //无边框  输入完成后
        
    }
}

//设置字体颜色
-(void)setFontColor:(NSString *)fontColor{
    _fontColor = fontColor;
    self.textLab.textColor = [UIColor colorWithHexString:fontColor];
}

-(void)setFontSize:(CGFloat)fontSize{
    _fontSize = fontSize;
    self.textLab.font = [UIFont systemFontOfSize:fontSize];
    
    [self setupViewHeight];
}

-(void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

-(void)setupTapGesture{
    [self editorText];
}

-(void)textViewHiddenState
{
    [self.closeImageView setHidden:YES];
    
    self.layer.borderColor = [UIColor clearColor].CGColor;

}

-(void)textViewShowState
{
    [self.closeImageView setHidden:NO];
    
    self.layer.borderColor = [UIColor blackColor].CGColor;

}

 
@end
