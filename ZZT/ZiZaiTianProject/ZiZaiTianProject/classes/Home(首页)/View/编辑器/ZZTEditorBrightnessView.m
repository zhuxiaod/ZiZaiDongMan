//
//  ZZTEditorBrightnessView.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/1/7.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import "ZZTEditorBrightnessView.h"
#import "ZZTEditorImageView.h"

#define margin 15

@implementation ZZTEditorBrightnessView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self buildLayout];
        
    }
    return self;
}

-(UILabel *)creatLabWithText:(NSString *)text textColor:(UIColor *)color fontSize:(NSInteger)fontSize{
    UILabel *Label =[[UILabel alloc] init];
    
    Label.text = text;
    Label.textColor = color;
    Label.font = [UIFont systemFontOfSize:fontSize];
    [self addSubview:Label];
    return Label;
}

-(UISlider *)creatSliderWithTag:(NSInteger)tag minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue value:(CGFloat)value taget:(SEL)taget{
    
    UISlider *slider =[[UISlider alloc] init];
    slider.tag = tag;
    slider.minimumValue = minValue;
    slider.maximumValue = maxValue;
    slider.value = value;
    slider.minimumTrackTintColor =[UIColor colorWithRed:17 / 255.0 green:195 / 255.0 blue:236 / 255.0 alpha:1];
    
    //    Handle
    [slider setThumbImage:[UIImage imageNamed:@"Handle"] forState:UIControlStateNormal];
    [slider addTarget:self action:taget forControlEvents:UIControlEventValueChanged];
    [self addSubview:slider];
    return slider;
}

-(void)buildLayout
{
    self.backgroundColor = [UIColor colorWithRed:244 green:244 blue:244 alpha:1];
    
    //亮度
    CGFloat LabelX = margin;
    CGFloat brightnessLabelY = 5;
    CGFloat LabelW = 70;
    CGFloat LabelH = 20;
    
    UILabel *brightnessLabel = [self creatLabWithText:@"亮度" textColor:[UIColor blackColor] fontSize:14];
    brightnessLabel.frame = CGRectMake(LabelX, brightnessLabelY, LabelW, LabelH);
    
    CGFloat SliderX = CGRectGetMaxX(brightnessLabel.frame) + margin;
    CGFloat brightnessSliderY = brightnessLabelY;
    CGFloat SliderW = self.width - SliderX - margin;
    CGFloat SliderH = 20;
    
    UISlider *brightnessSlider = [self creatSliderWithTag:105 minValue:-1 maxValue:1 value:0 taget:@selector(sliderValueChage:)];
    _brightnessSlider = brightnessSlider;
    brightnessSlider.frame = CGRectMake(SliderX, brightnessSliderY, SliderW, SliderH);

    //饱和度
    CGFloat SaturationLabelY = CGRectGetMaxY(brightnessLabel.frame)+20;
    UILabel *SaturationLabel = [self creatLabWithText:@"饱和度" textColor:[UIColor blackColor] fontSize:14];
    SaturationLabel.frame = CGRectMake(LabelX, SaturationLabelY, LabelW, LabelH);
    
    CGFloat SaturationSliderY = SaturationLabelY;
    
    UISlider *SaturationSlider = [self creatSliderWithTag:106 minValue:0 maxValue:2 value:1 taget:@selector(sliderValueChage:)];
    _saturationSlider = SaturationSlider;
    SaturationSlider.frame = CGRectMake(SliderX, SaturationSliderY, SliderW, SliderH);
    
//    //对比度
//    CGFloat ContrastLabelY = CGRectGetMaxY(SaturationLabel.frame)+5;;
//
//    UILabel *ContrastLabel = [self creatLabWithText:@"对比度" textColor:[UIColor blackColor] fontSize:14];
//    ContrastLabel.frame = CGRectMake(LabelX, ContrastLabelY, LabelW, LabelH);
//
//
//    CGFloat ContrastSliderY = ContrastLabelY;
//
//    UISlider *ContrastSlider = [self creatSliderWithTag:107 minValue:-3.14 maxValue:3.14 value:0 taget:@selector(sliderValueChage:)];
//    _contrastSlider = ContrastSlider;
//    ContrastSlider.frame = CGRectMake(SliderX, ContrastSliderY,SliderW,SliderH);
    
    //色相
    CGFloat HueLabelY = CGRectGetMaxY(SaturationLabel.frame)+20;
    
    UILabel *HueLabel = [self creatLabWithText:@"色相" textColor:[UIColor blackColor] fontSize:14];
    HueLabel.frame = CGRectMake(LabelX, HueLabelY, LabelW, LabelH);
    
    CGFloat HueSliderY = HueLabelY;
    
    UISlider *HueSlider = [self creatSliderWithTag:108 minValue:-3.14 maxValue:3.14 value:0 taget:@selector(sliderValueChage:)];
    _hueSlider = HueSlider;
    HueSlider.frame = CGRectMake(SliderX, HueSliderY,SliderW,SliderH);
    
    //透明度
    CGFloat AlphaLabelY = CGRectGetMaxY(HueLabel.frame)+20;
    UILabel *AlphaLabel = [self creatLabWithText:@"透明度" textColor:[UIColor blackColor] fontSize:14];
    AlphaLabel.frame = CGRectMake(LabelX, AlphaLabelY, LabelW, LabelH);
    
    CGFloat AlphaSliderY = AlphaLabelY;
    
    UISlider *AlphaSlider = [self creatSliderWithTag:109 minValue:0 maxValue:1 value:1 taget:@selector(sliderValueChage:)];
    _alphaSlider = AlphaSlider;
    AlphaSlider.frame = CGRectMake(SliderX, AlphaSliderY,SliderW,SliderH);
}

- (void)sliderValueChage:(UISlider *)slider
{
    if ([self.delegate respondsToSelector:@selector(brightnessChangeWithTag:Value:img:)]) {
        [self.delegate brightnessChangeWithTag:slider.tag Value:slider.value img:self.imageViewModel.originalImg];
    }
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *view = [super hitTest:point withEvent:event];
    
    if(view == nil){
        [self removeFromSuperview];
    }
    return view;
    
}
#pragma mark - 设置slider的初始化
-(void)setImageViewModel:(ZZTEditorImageView *)imageViewModel{
    _imageViewModel = imageViewModel;
    
    if(imageViewModel == nil) return;
    
    self.saturationSlider.value = imageViewModel.saturation;
//    [self sliderValueChage:self.saturationSlider];
    
    self.brightnessSlider.value = imageViewModel.brightness;
//    [self sliderValueChage:self.brightnessSlider];

    self.hueSlider.value = imageViewModel.hue;
//    [self sliderValueChage:self.hueSlider];

    self.alphaSlider.value = imageViewModel.alpha;
//    [self sliderValueChage:self.alphaSlider];
    
    NSLog(@"saturation:%lf contrast:%lf brightness:%lf hue:%lf alpha:%lf",imageViewModel.saturation,imageViewModel.contrast,imageViewModel.brightness,imageViewModel.hue,imageViewModel.alpha);
}
@end
