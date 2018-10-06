//
//  ZZTColorPickerView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/10/6.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTColorPickerView.h"
@interface ZZTColorPickerView ()<UITextFieldDelegate>

@property (nonatomic,strong) UILabel *hueLab;
@property (nonatomic,strong) UILabel *saturationLab;
@property (nonatomic,strong) UILabel *brightnessLab;
@property (nonatomic,strong) UILabel *alphaLab;

@property (nonatomic,strong) UISlider *hueSlider;
@property (nonatomic,strong) UISlider *saturationSlider;
@property (nonatomic,strong) UISlider *brightnessSlider;
@property (nonatomic,strong) UISlider *alphaSlider;

@property (nonatomic,strong) UITextField *hueTF;
@property (nonatomic,strong) UITextField *saturationTF;
@property (nonatomic,strong) UITextField *brightnessTF;
@property (nonatomic,strong) UITextField *alphaTF;

@end

@implementation ZZTColorPickerView

#pragma mark 初始化
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSomeUI];
    }
    return self;
}

-(void)addSomeUI{
    self.backgroundColor = [UIColor whiteColor];
    //色彩lab
    UILabel *hueLab = [[UILabel alloc] init];
//    hueLab.backgroundColor = [UIColor redColor];
    [hueLab setText:@"Hue [0-360]"];
    [hueLab setTextColor:[UIColor grayColor]];
    _hueLab = hueLab;
    [self addSubview:hueLab];
    
    //slider
    UISlider *hueSlider = [[UISlider alloc] init];
//    hueSlider.backgroundColor = [UIColor redColor];
    hueSlider.minimumValue = 0.0;
    hueSlider.maximumValue = 360.0;
    hueSlider.value = 180;
    hueSlider.tag = 1;
    hueSlider.minimumTrackTintColor = [UIColor blueColor];
    [hueSlider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    _hueSlider = hueSlider;
    [self addSubview:hueSlider];
    
    //textF
    UITextField *hueTF = [[UITextField alloc] init];
//    hueTF.backgroundColor = [UIColor redColor];
    hueTF.text = [NSString stringWithFormat:@"%.f",hueSlider.value];
    _hueTF = hueTF;
    //数字键盘
    hueTF.keyboardType = UIKeyboardTypeNumberPad;
    //样式
    hueTF.borderStyle = UITextBorderStyleRoundedRect;
    //事件
    [hueTF addTarget:self action:@selector(TFChange:) forControlEvents:UIControlEventEditingChanged];
    hueTF.tag = 1;
    [self addSubview:hueTF];
    
    //色彩lab
    UILabel *saturationLab = [[UILabel alloc] init];
    [saturationLab setText:@"Saturation [0-100]"];
    [saturationLab setTextColor:[UIColor grayColor]];
    _saturationLab = saturationLab;
    [self addSubview:saturationLab];
    
    //slider
    UISlider *saturationSlider = [[UISlider alloc] init];
//    saturationSlider.backgroundColor = [UIColor redColor];
    saturationSlider.minimumValue = 0.0;
    saturationSlider.maximumValue = 100;
    saturationSlider.value = 100;
    saturationSlider.tag = 2;
    saturationSlider.minimumTrackTintColor = [UIColor blueColor];
    [saturationSlider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];

    _saturationSlider = saturationSlider;
    [self addSubview:saturationSlider];
    //textF
    UITextField *saturationTF = [[UITextField alloc] init];
    saturationTF.delegate = self;
    saturationTF.text = [NSString stringWithFormat:@"%.f",saturationSlider.value];
    _saturationTF = saturationTF;
    [saturationTF addTarget:self action:@selector(TFChange:) forControlEvents:UIControlEventEditingChanged];
    saturationTF.keyboardType = UIKeyboardTypeNumberPad;
    //样式
    saturationTF.borderStyle = UITextBorderStyleRoundedRect;
    saturationSlider.tag = 2;
    [self addSubview:saturationTF];
    
    //色彩lab
    UILabel *brightnessLab = [[UILabel alloc] init];
    [brightnessLab setText:@"Brightness [0-100]"];
    [brightnessLab setTextColor:[UIColor grayColor]];
    _brightnessLab = brightnessLab;
    [self addSubview:brightnessLab];
    
    //slider
    UISlider *brightnessSlider = [[UISlider alloc] init];
//    brightnessSlider.backgroundColor = [UIColor redColor];
    brightnessSlider.minimumValue = 0.0;
    brightnessSlider.maximumValue = 100;
    brightnessSlider.value = 100;
    brightnessSlider.tag = 3;
    brightnessSlider.minimumTrackTintColor = [UIColor blueColor];
    [brightnessSlider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    _brightnessSlider = brightnessSlider;
    [self addSubview:brightnessSlider];
    
    //textF
    UITextField *brightnessTF = [[UITextField alloc] init];
    brightnessTF.text = [NSString stringWithFormat:@"%.f",brightnessSlider.value];
    _brightnessTF = brightnessTF;
    [brightnessTF addTarget:self action:@selector(TFChange:) forControlEvents:UIControlEventEditingChanged];
    brightnessTF.keyboardType = UIKeyboardTypeNumberPad;
    //样式
    brightnessTF.borderStyle = UITextBorderStyleRoundedRect;
    brightnessTF.tag = 3;
    [self addSubview:brightnessTF];

    //色彩lab
    UILabel *alphaLab = [[UILabel alloc] init];
    [alphaLab setText:@"Alpha [0-255]"];
    [alphaLab setTextColor:[UIColor grayColor]];
    _alphaLab = alphaLab;
    [self addSubview:alphaLab];
    
    //slider
    UISlider *alphaSlider = [[UISlider alloc] init];
//    alphaSlider.backgroundColor = [UIColor redColor];
    alphaSlider.minimumValue = 0.0;
    alphaSlider.maximumValue = 255;
    alphaSlider.value = 255;
    alphaSlider.tag = 4;
    alphaSlider.minimumTrackTintColor = [UIColor purpleColor];
    [alphaSlider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    _alphaSlider = alphaSlider;
    [self addSubview:alphaSlider];
    //textF
    UITextField *alphaTF = [[UITextField alloc] init];
    alphaTF.text = [NSString stringWithFormat:@"%.f",alphaSlider.value];
    _alphaTF = alphaTF;
    [alphaTF addTarget:self action:@selector(TFChange:) forControlEvents:UIControlEventEditingChanged];
    alphaTF.keyboardType = UIKeyboardTypeNumberPad;
    //样式
    alphaTF.borderStyle = UITextBorderStyleRoundedRect;
    alphaTF.tag = 4;
    [self addSubview:alphaTF];
}



-(void)TFChange:(UITextField *)textField{
    switch (textField.tag) {
        case 1:
            if([textField.text integerValue] > 360){
                textField.text = @"360";
            }
            _hueSlider.value = [textField.text integerValue];
            [self sliderChange:nil];
            break;
        case 2:
            if([textField.text integerValue] > 100){
                textField.text = @"100";
            }
            _saturationSlider.value = [textField.text integerValue];
            [self sliderChange:nil];
            break;
        case 3:
            if([textField.text integerValue] > 100){
                textField.text = @"100";
            }
            _brightnessSlider.value = [textField.text integerValue];
            [self sliderChange:nil];
            break;
        case 4:
            if([textField.text integerValue] > 255){
                textField.text = @"255";
            }
            _alphaSlider.value = [textField.text integerValue];
            [self sliderChange:nil];
            break;
        default:
            break;
    }
}

-(void)sliderChange:(UISlider *)slider{
    switch (slider.tag) {
        case 1:
            _hueTF.text = [NSString stringWithFormat:@"%.f",slider.value];
            break;
        case 2:
            _saturationTF.text = [NSString stringWithFormat:@"%.f",slider.value];
            break;
        case 3:
            _brightnessTF.text = [NSString stringWithFormat:@"%.f",slider.value];
            break;
        case 4:
            _alphaTF.text = [NSString stringWithFormat:@"%.f",slider.value];
            break;
        default:
            break;
    }
    UIColor *color = [UIColor colorWithHue:(_hueSlider.value/360.0) saturation:(_saturationSlider.value/100.0) brightness:(_brightnessSlider.value/100.0) alpha:(_alphaSlider.value/255.0)];
//    self.backgroundColor = color;
    //设置代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(colorPickerViewWithColor:color:)]) {
        [self.delegate colorPickerViewWithColor:self color:color];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [_hueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(10);
        make.left.equalTo(self).with.offset(10);
        make.right.equalTo(self).with.offset(-10);
        make.height.mas_equalTo(20);
    }];
    [_hueSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hueLab.mas_bottom).with.offset(4);
        make.left.equalTo(self).with.offset(10);
        make.right.equalTo(self).with.offset(-70);
        make.height.mas_equalTo(20);
    }];
    [_hueTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hueLab.mas_bottom).with.offset(4);
        make.left.equalTo(self.hueSlider.mas_right).with.offset(10);
        make.right.equalTo(self).with.offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    [_saturationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hueTF.mas_bottom).with.offset(10);
        make.left.equalTo(self).with.offset(10);
        make.right.equalTo(self).with.offset(-10);
        make.height.mas_equalTo(20);
    }];
    [_saturationSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.saturationLab.mas_bottom).with.offset(4);
        make.left.equalTo(self).with.offset(10);
        make.right.equalTo(self).with.offset(-70);
        make.height.mas_equalTo(20);
    }];
    [_saturationTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.saturationLab.mas_bottom).with.offset(4);
        make.left.equalTo(self.saturationSlider.mas_right).with.offset(10);
        make.right.equalTo(self).with.offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    [_brightnessLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.saturationTF.mas_bottom).with.offset(10);
        make.left.equalTo(self).with.offset(10);
        make.right.equalTo(self).with.offset(-10);
        make.height.mas_equalTo(20);
    }];
    [_brightnessSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.brightnessLab.mas_bottom).with.offset(4);
        make.left.equalTo(self).with.offset(10);
        make.right.equalTo(self).with.offset(-70);
        make.height.mas_equalTo(20);
    }];
    [_brightnessTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.brightnessLab.mas_bottom).with.offset(4);
        make.left.equalTo(self.brightnessSlider.mas_right).with.offset(10);
        make.right.equalTo(self).with.offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    [_alphaLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.brightnessTF.mas_bottom).with.offset(10);
        make.left.equalTo(self).with.offset(10);
        make.right.equalTo(self).with.offset(-10);
        make.height.mas_equalTo(20);
    }];
    [_alphaSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alphaLab.mas_bottom).with.offset(4);
        make.left.equalTo(self).with.offset(10);
        make.right.equalTo(self).with.offset(-70);
        make.height.mas_equalTo(20);
    }];
    [_alphaTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alphaLab.mas_bottom).with.offset(4);
        make.left.equalTo(self.alphaSlider.mas_right).with.offset(10);
        make.right.equalTo(self).with.offset(-10);
        make.height.mas_equalTo(20);
    }];
}
//#pragma mark - textFieldDelegate（别忘了遵守协议设置代理）
//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    self.y = self.y - 216;  //216是输入框在最底部时view移动的距离，具体移动多少距离，需要根据实际情况而定
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    self.y = self.y + 216;
//}
@end
