//
//  ZZTEditorBrightnessView.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/1/7.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import "ZZTEditorBrightnessView.h"
#define margin 15

@implementation ZZTEditorBrightnessView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self buildLayout];
        
    }
    return self;
}

-(void)buildLayout
{
    self.backgroundColor = [UIColor colorWithRed:244 green:244 blue:244 alpha:1];
    CGFloat brightnessLabelX = margin;
    CGFloat brightnessLabelY = 5;
    CGFloat brightnessLabelW = 70;
    CGFloat brightnessLabelH = 20;
    UILabel *brightnessLabel =[[UILabel alloc] initWithFrame:CGRectMake(brightnessLabelX, brightnessLabelY, brightnessLabelW, brightnessLabelH)];
    brightnessLabel.text = @"亮度";
    brightnessLabel.textColor = [UIColor blackColor];
    brightnessLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:brightnessLabel];
    
    CGFloat brightnessSliderX = CGRectGetMaxX(brightnessLabel.frame) + margin;
    CGFloat brightnessSliderY = brightnessLabelY;
    CGFloat brightnessSliderW = self.width - brightnessSliderX - margin;
    CGFloat brightnessSliderH = 20;
    
    UISlider *brightnessSlider =[[UISlider alloc] initWithFrame:CGRectMake(brightnessSliderX, brightnessSliderY, brightnessSliderW, brightnessSliderH)];
    brightnessSlider.tag = 105;
    brightnessSlider.minimumValue = -0.5;
    brightnessSlider.maximumValue = 0.5;
    brightnessSlider.value = 0;
    brightnessSlider.minimumTrackTintColor =[UIColor colorWithRed:17 / 255.0 green:195 / 255.0 blue:236 / 255.0 alpha:1];
    
//    Handle
    
    [brightnessSlider setThumbImage:[UIImage imageNamed:@"Handle"] forState:UIControlStateNormal];
    [brightnessSlider addTarget:self action:@selector(sliderValueChage:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:brightnessSlider];

    CGFloat SaturationLabelX = margin;
    CGFloat SaturationLabelY = CGRectGetMaxY(brightnessLabel.frame)+5;
    CGFloat SaturationLabelW = 70;
    CGFloat SaturationLabelH = 20;
    UILabel *SaturationLabel =[[UILabel alloc] initWithFrame:CGRectMake(SaturationLabelX, SaturationLabelY, SaturationLabelW, SaturationLabelH)];
    SaturationLabel.text = @"饱和度";
    SaturationLabel.textColor = [UIColor blackColor];
    SaturationLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:SaturationLabel];
    
    CGFloat SaturationSliderX = CGRectGetMaxX(SaturationLabel.frame) + margin;
    CGFloat SaturationSliderY = SaturationLabelY;
    CGFloat SaturationSliderW = self.width - SaturationSliderX - margin;
    CGFloat SaturationSliderH = 20;
    
    
    
    UISlider *SaturationSlider =[[UISlider alloc] initWithFrame:CGRectMake(SaturationSliderX, SaturationSliderY, SaturationSliderW, SaturationSliderH)];
    SaturationSlider.tag = 106;
    SaturationSlider.minimumValue = 0.5;
    SaturationSlider.maximumValue = 1.5;
    SaturationSlider.value = 1;
    SaturationSlider.minimumTrackTintColor =[UIColor colorWithRed:17 / 255.0 green:195 / 255.0 blue:236 / 255.0 alpha:1];
    [SaturationSlider setThumbImage:[UIImage imageNamed:@"Handle"] forState:UIControlStateNormal];

    [SaturationSlider addTarget:self action:@selector(sliderValueChage:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:SaturationSlider];
    
    
    
    self.backgroundColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1];
    CGFloat ContrastLabelX = margin;
    CGFloat ContrastLabelY = CGRectGetMaxY(SaturationLabel.frame)+5;;
    CGFloat ContrastLabelW = 70;
    CGFloat ContrastLabelH = 20;
    UILabel *ContrastLabel =[[UILabel alloc] initWithFrame:CGRectMake(ContrastLabelX, ContrastLabelY, ContrastLabelW, ContrastLabelH)];
    ContrastLabel.text = @"对比度";
    ContrastLabel.textColor = [UIColor blackColor];
    ContrastLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:ContrastLabel];
    
    CGFloat ContrastSliderX = CGRectGetMaxX(ContrastLabel.frame) + margin;
    CGFloat ContrastSliderY = ContrastLabelY;
    CGFloat ContrastSliderW = self.width - ContrastSliderX - margin;
    CGFloat ContrastSliderH = 20;
    
    
    
    UISlider *ContrastSlider =[[UISlider alloc] initWithFrame:CGRectMake(ContrastSliderX, ContrastSliderY, ContrastSliderW, ContrastSliderH)];
    ContrastSlider.tag = 107;
    ContrastSlider.minimumValue = 0.5;
    ContrastSlider.maximumValue = 1.5;
    ContrastSlider.value = 1;
    ContrastSlider.minimumTrackTintColor =[UIColor colorWithRed:17 / 255.0 green:195 / 255.0 blue:236 / 255.0 alpha:1];
    [ContrastSlider setThumbImage:[UIImage imageNamed:@"Handle"] forState:UIControlStateNormal];

    [ContrastSlider addTarget:self action:@selector(sliderValueChage:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:ContrastSlider];
}

- (void)sliderValueChage:(UISlider *)slider
{
    if ([self.delegate respondsToSelector:@selector(brightnessChangeWithTag:Value:)]) {
        [self.delegate brightnessChangeWithTag:slider.tag Value:slider.value];
    }
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *view = [super hitTest:point withEvent:event];
    
    if(view == nil){
        [self removeFromSuperview];
    }
    return view;
    
}

@end
