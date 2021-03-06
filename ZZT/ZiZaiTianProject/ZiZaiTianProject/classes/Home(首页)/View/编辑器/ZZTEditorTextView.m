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

@interface ZZTEditorTextView ()<ZZTEditorBasisViewDelegate,UIGestureRecognizerDelegate>{
    CGPoint prevPoint;
    
    CGFloat selfX;
    
    CGFloat selfY;
    
    CGFloat selfW;
    
    CGFloat selfH;
    
    CGAffineTransform lastTransform;
    
    CGPoint lastCenter;
    
    CGFloat proportion;
    
}

#define textSpace 20

//2条控制边
@property (nonatomic,strong) UIView *rightBorder;

@property (nonatomic,strong) UIView *leftBorder;

@property (nonatomic,strong) UILabel *textLab;

@property(nonatomic,strong) UIImageView *imageView;

@property(nonatomic,strong) UIImageView *lineView;

@property(nonatomic,strong) UIPinchGestureRecognizer *pinchGestureRecognizer;
//移动按钮
@property(nonatomic,strong) UIImageView *moveImg;

@end

@implementation ZZTEditorTextView

//旁白
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
        
        self.backgroundColor = [UIColor clearColor];

        self.delegate = self;
        
        self.fontSize = 17;
    }
    return self;
}

-(void)setupUI{
    //禁止旋转
    [self Editor_BasisViewCloseRotateGesture];

    //禁止旋转
    [self Editor_BasisViewClosePichGesture];
    
    //显示图
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    _imageView = imageView;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.borderWidth = 1.0f;
    [self addSubview:imageView];
    
    //lab
    UILabel *textLab = [[UILabel alloc] init];
    textLab.text = @"点击输入文字";
//    [textLab sizeToFit];
    textLab.numberOfLines = 0;
    _textLab = textLab;
    [self addSubview:textLab];
    
    //边线
//    self.layer.cornerRadius = 10.0f;
    textLab.layer.borderColor = [UIColor blackColor].CGColor;
    textLab.layer.borderWidth = 1.0f;
    
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
    
    //移动按钮
    UIImageView *moveImg = [[UIImageView alloc] init];
    moveImg.image = [UIImage imageNamed:@"EditorStretch"];
    _moveImg = moveImg;
    moveImg.userInteractionEnabled = YES;
    moveImg.tag = 1;
    [self addSubview:moveImg];
    
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapTarget:)];
    [moveImg addGestureRecognizer:panGR];
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
    
   
    
    [self.moveImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.width.height.mas_equalTo(20);
    }];
    
//    [self.rightBorder mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self);
//        make.bottom.equalTo(self);
//        make.right.equalTo(self);
//        make.width.mas_equalTo(30);
//    }];
//
//    [self.leftBorder mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self);
//        make.bottom.equalTo(self);
//        make.left.equalTo(self);
//        make.width.mas_equalTo(30);
//    }];
    
//    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self);
//        make.bottom.equalTo(self);
//        make.right.mas_equalTo(-10);
//        make.left.mas_equalTo(10);
//    }];

    self.textLab.frame = CGRectMake(10, 10, self.bounds.size.width - 20, self.bounds.size.height - 20);
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.textLab).offset(-1);
        make.bottom.right.equalTo(self.textLab).offset(1);
    }];
    
    [self.closeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(2);
        make.left.equalTo(self).offset(2);
        make.width.height.mas_equalTo(20);
    }];
    
    self.lineView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}

#pragma mark - 拖动按钮改变
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
            height = [self.textLab.text heightWithWidth:width - textSpace font:self.fontSize];
            height += textSpace;
        }
        
        //得到当前的Width
        self.frame = CGRectMake(x, y, width, height);
    }
}

//最小限制
-(CGFloat)minimumlimit:(CGFloat)num{
    //能放下当前一个字号 _fontSize
    CGFloat replyCountWidth = [@"宽" getTextWidthWithFont:self.textLab.font];
    replyCountWidth += textSpace;
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

//设置样式
-(void)setType:(editorTextViewType)type{
    _type = type;
    //背景透明的
    if(type == editorTextViewTypeBGClear){
        self.textLab.backgroundColor = [UIColor clearColor];
    }else if (type == editorTextViewTypeBGWhite){
        self.textLab.backgroundColor = [UIColor whiteColor];
    }else{
        //无边框  输入完成后
    }
}

//设置字体颜色
-(void)setFontColor:(NSString *)fontColor{
    _fontColor = fontColor;
    
    self.textLab.textColor = [UIColor colorWithHexString:fontColor];
}

-(void)setViewScale:(CGFloat)viewScale{
    _viewScale = viewScale;
    
//    self.frame = CGRectMake(self.x, self.y, self.width * 1.1, self.height * 1.1);
}

-(void)setFontSize:(CGFloat)fontSize{
    _fontSize = fontSize;
    
    //字体变大 label 会不会变大
    self.textLab.font = [UIFont systemFontOfSize:fontSize];
    
    //取到第一行有多少字
//    NSArray *array = [self getLinesArrayOfStringInLabel:self.textLab];
    
//    NSString *str = array[0];

//    NSString *textStr = [NSString stringWithFormat:@"%@宽",str];
    
    //计算会用到的宽度
//    CGFloat replyCountWidth = [textStr getTextWidthWithFont:self.textLab.font];
    
//    replyCountWidth = [self minimumlimit:replyCountWidth];

//    self.frame = CGRectMake(self.x, self.y, replyCountWidth + 20, self.bounds.size.height);
    
    self.frame = CGRectMake(self.x, self.y, self.bounds.size.width, self.bounds.size.height);

    [self setupViewHeight];
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

//-(void)setupViewWidth:(NSString *)str{
//    CGFloat replyCountWidth = [str getTextWidthWithFont:self.textLab.font];
//
//    replyCountWidth += 20;
//
//    CGFloat width = self.width;
//
//    if(replyCountWidth > self.width)width = replyCountWidth;
//
//    NSLog(@"width:%f   replyCountWidth:%f",width,replyCountWidth);
//
//    self.frame = CGRectMake(self.x, self.y, width, self.height);
//}

-(void)setupViewHeight{
    //适应高度
    CGFloat height = [self.textLab.text heightWithWidth:self.width - 20 font:self.fontSize];
    
    self.frame = CGRectMake(self.x, self.y, self.width, height + textSpace);

    if(_textLab.text.length == 0){
        self.frame = CGRectMake(self.x, self.y, self.width, 30);
    }
}

- (NSArray *)getLinesArrayOfStringInLabel:(UILabel *)label{
    NSString *text = [label text];
    UIFont *font = [label font];
    CGRect rect = [label frame];
    
    CTFontRef myFont = CTFontCreateWithName((CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge  id)myFont range:NSMakeRange(0, attStr.length)];
    CFRelease(myFont);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = ( NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    for (id line in lines) {
        CTLineRef lineRef = (__bridge  CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [text substringWithRange:range];
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithFloat:0.0]));
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithInt:0.0]));
        //NSLog(@"''''''''''''''''''%@",lineString);
        [linesArray addObject:lineString];
    }
    
    CGPathRelease(path);
    CFRelease( frame );
    CFRelease(frameSetter);
    return (NSArray *)linesArray;
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
    
    [self.moveImg setHidden:YES];
    
    self.textLab.layer.borderColor = [UIColor clearColor].CGColor;
    
    _imageView.layer.borderColor = [UIColor clearColor].CGColor;
}

-(void)textViewShowState
{
    [self.closeImageView setHidden:NO];
    
    [self.moveImg setHidden:NO];

    self.textLab.layer.borderColor = [UIColor blackColor].CGColor;
    
    _imageView.layer.borderColor = [UIColor whiteColor].CGColor;
}

 
@end
