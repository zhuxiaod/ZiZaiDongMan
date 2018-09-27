//
//  ZZTPaletteView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/31.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTPaletteView.h"
#import "Palette.h"

@interface ZZTPaletteView ()<PaletteDelegate,UIGestureRecognizerDelegate>
//显示颜色View
@property (nonatomic,strong) UIView *choicesColorView;
@property (nonatomic,strong) Palette *palett;

@property (nonatomic,assign) CGFloat satValue;

@property (nonatomic,assign) CGFloat brightValue;

@property (nonatomic,assign) CGFloat alphaValue;

@property (nonatomic,assign) CGPoint colorPoint;

@property (nonatomic,strong) UISlider *brightSlider;

@property (nonatomic,strong) UISlider *alphaSlider;


@end

@implementation ZZTPaletteView

#pragma mark 初始化
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSomeUI];
    }
    return self;
}

#pragma mark 添加UI
-(void)addSomeUI{
    //调色板
    //调色板Size
    CGFloat paletteW = self.bounds.size.height * 0.6;
    CGFloat space = self.bounds.size.height * 0.03;
    Palette *palette = [[Palette alloc] initWithFrame:CGRectMake(0, 0, paletteW, paletteW)];
    palette.delegate = self;
    _palett = palette;
    [self addSubview:palette];
    
    //slider 明度
    UISlider *slide2 = [self createSliderWithValue:50 minV:0 maxV:100];
    _brightSlider = slide2;
    slide2.frame = CGRectMake(CGRectGetMaxX(palette.frame), 20, 150, 20);
    slide2.tag = 2;
    _brightValue = slide2.value;

    //slider 透明度
    UISlider *slide3 = [self createSliderWithValue:100 minV:0 maxV:255];
    _alphaSlider = slide3;
    slide3.frame = CGRectMake(CGRectGetMaxX(palette.frame), 50, 150, 20);
    slide3.tag = 3;
    _alphaValue = slide3.value;
    
    //展示颜色
    CGFloat choicesColorViewW = self.bounds.size.height * 0.19;
    self.choicesColorView = [[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width - choicesColorViewW)/2, paletteW+space, choicesColorViewW, choicesColorViewW)];
    self.choicesColorView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.choicesColorView];
    
    //确定按钮
    UIButton *ture = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width/2 - 60, paletteW+space+choicesColorViewW+space, 50, choicesColorViewW - 20)];
    [ture setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ture setTitle:@"确定" forState:UIControlStateNormal];
//    [ture addTarget:self action:@selector() forControlEvents:];
    self.btn = ture;
    [self addSubview:ture];
    
    //取消按钮
    UIButton *cannel = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width/2 + 10, paletteW+space+choicesColorViewW+space, 50, choicesColorViewW - 20)];
    [cannel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cannel setTitle:@"取消" forState:UIControlStateNormal];
    [cannel addTarget:self action:@selector(clickPaletteBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cannel];
    //样式
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 1.0f;
    
//    ture.layer.borderColor = [UIColor grayColor].CGColor;
//    ture.layer.borderWidth = 1.0f;
//
//    cannel.layer.borderColor = [UIColor grayColor].CGColor;
//    cannel.layer.borderWidth = 1.0f;
    
    self.choicesColorView.layer.borderColor = [UIColor grayColor].CGColor;
    self.choicesColorView.layer.borderWidth = 1.0f;
}

-(UISlider *)createSliderWithValue:(CGFloat)value minV:(CGFloat)minV maxV:(CGFloat)maxV{
    UISlider *slide = [[UISlider alloc] init];
    [self addSubview:slide];
    slide.minimumValue = 0;
    slide.maximumValue = 255;
    slide.value = 100;
//    slide.tag = 3;
    slide.continuous = YES;
    [slide addTarget:self action:@selector(slideTarget:) forControlEvents:UIControlEventValueChanged];
    return slide;
}

-(void)slideTarget:(UISlider *)slider{
    UIColor *color = [[UIColor alloc] init];
   if(slider.tag == 2){
        color = [self calculateWithPointInView:self.colorPoint colorFrame:self.palett.frame brightness:slider.value/100.0f alpha:_alphaValue];
        _brightValue = slider.value/100.0f;
    }else{
        color = [self calculateWithPointInView:self.colorPoint colorFrame:self.palett.frame brightness:_brightValue alpha:slider.value/255.0f];
        _alphaValue = slider.value/255.0f;
    }
    self.choicesColorView.backgroundColor = color;
//    [self patette:nil choiceColor:color colorPoint:self.colorPoint];
    [self patetteView:self patette:self.palett choiceColor:color colorPoint:self.colorPoint brightness:_brightValue alpha:_alphaValue];
}

//恢复颜色
-(void)clickPaletteBtn:(UITapGestureRecognizer *)sender{
    //圆心点恢复到初始位置
    _palett.sliderCenter = CGPointMake(_palett.width/2, _palett.height/2);
    //通过初始位置的颜色来上色
    UIColor *color = [Utilities calculatePointInView:_palett.sliderCenter colorFrame:_palett.frame brightness:50 alpha:100];
    [self patette:_palett choiceColor:color colorPoint:_palett.sliderCenter];
}

#pragma mark 取色板代理方法
-(void)patetteView:(ZZTPaletteView *)patetteView patette:(Palette *)palette choiceColor:(UIColor *)color colorPoint:(CGPoint)colorPoint brightness:(CGFloat)brightness alpha:(CGFloat)alpha{
    self.choicesColorView.backgroundColor = color;
    if ([self.delegate respondsToSelector:@selector(patetteView:patette:choiceColor:colorPoint:brightness:alpha:)]){
        [self.delegate patetteView:self patette:palette choiceColor:color colorPoint:colorPoint brightness:brightness alpha:alpha];
    }
}

//移动中心点 获取颜色
-(void)patette:(Palette *)patette choiceColor:(UIColor *)color colorPoint:(CGPoint)colorPoint{
    self.colorPoint = colorPoint;
    self.choicesColorView.backgroundColor = color;
    [self patetteView:self patette:patette choiceColor:color colorPoint:colorPoint brightness:1.0 alpha:1.0];
    //恢复slider
    [self recoverSlider];
}

-(void)recoverSlider{
    self.brightSlider.value = 50;
    self.alphaSlider.value = 100;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];
    if (result == self) {
        return nil;
    }else {
        return result;
    }
}

-(UIColor *)calculateWithPointInView:(CGPoint)point colorFrame:(CGRect)colorFrame brightness:(CGFloat)brightness alpha:(CGFloat)alpha{
    NSLog(@"%@",NSStringFromCGPoint(point));
    CGPoint center=CGPointMake(colorFrame.size.width/2,colorFrame.size.height/2);  // 中心点
    double radius=colorFrame.size.width/2;          // 半径
    double dx=ABS(point.x-center.x);    //  ABS函数: int类型 取绝对值
    double dy=ABS(point.y-center.y);   //   atan pow sqrt也是对应的数学函数
    double angle=atan(dy/dx);
    if (isnan(angle)) angle=0.0;
    double dist=sqrt(pow(dx,2)+pow(dy,2));
    double saturation=MIN(dist/radius,1.0);
    
    if (dist<10) saturation=0;
    if (point.x<center.x) angle=M_PI-angle;
    if (point.y>center.y) angle=2.0*M_PI-angle;
    
    HSVType currentHSV=HSVTypeMake(angle/(2.0*M_PI), saturation, 1.0);
    
    //    [self centerPointValue:currentHSV];    // 计算中心点位置
    
    UIColor *color=[UIColor colorWithHue:currentHSV.h saturation:currentHSV.s brightness:brightness alpha:alpha];
    NSLog(@"currentHSV:%f %f brightness:%f alpha:%f",currentHSV.h,currentHSV.s,brightness,alpha);
    return color;
}
@end
