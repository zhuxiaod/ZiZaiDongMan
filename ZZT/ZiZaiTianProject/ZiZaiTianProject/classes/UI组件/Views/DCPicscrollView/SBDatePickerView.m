//
//  SBDatePickerView.m
//  DatePickerView
//
//  Created by mac on 2018/11/29.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "SBDatePickerView.h"
#import <Masonry.h>



@interface SBDatePickerView ()

@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) UILabel *dateLab;
@end

@implementation SBDatePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
   
        //创建UI
        [self setupUI];
        
        self.backgroundColor = ZZTSubColor;
        
        [self ba_animation_showFromPositionType:BAKit_ViewAnimationEnterDirectionTypeBottom duration:0.6f finishBlock:^{
        }];
    }
    return self;
    
}
    
-(void)setupUI{
    
    [self setupDatePicker];
    
    [self setupBtn];

    [self setupLab];
}

// 监听
- (void)dateChanged:(UIDatePicker *)picker{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:picker.date];
    NSLog(@"date:%@",dateStr);
    self.dateLab.text = dateStr;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.right.left.equalTo(self);
        make.height.mas_equalTo(self.bounds.size.height - 30);
    }];
}

//显示时间的lab  每次在外面会传一个日期  日期是什么 显示的pick将也是那个时间 如果没有传 那么为当前时期
-(void)setDate:(NSString *)date{
    _date = date;
    
    _dateLab.text = date;
    
    // 日期格式化类
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    // 设置日期格式 为了转换成功
    //    format.dateFormat = @"yyyy-MM-dd";
    format.dateFormat = @"yyyy-MM-dd";
    
    NSDate *minDate = [format dateFromString:date];

    _datePicker.date = minDate;
}

-(void)setupLab{
    UILabel *dateLab = [[UILabel alloc] init];
    _dateLab = dateLab;
    dateLab.textAlignment = NSTextAlignmentCenter;
    dateLab.textColor = [UIColor whiteColor];
    [self addSubview:dateLab];
    
    [dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(SCREEN_WIDTH - 100);
    }];
}

-(void)setupBtn{
    //确定
    UIButton *sureBtn = [[UIButton alloc] init];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self).offset(-10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    
    //取消
    UIButton *cannelBtn = [[UIButton alloc] init];
    [cannelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cannelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cannelBtn addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cannelBtn];
    
    [cannelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
}

-(void)sure{
    //确定选择
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmDate:dateStr:)]) {
        // 调用代理方法
        [self.delegate confirmDate:self dateStr:self.dateLab.text];
    }
    [self datePickerViewRemoveView];
}

-(void)removeSelf{
    
    [self datePickerViewRemoveView];
    
}

-(void)setupDatePicker{
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker = datePicker;
    // 1.1选择datePickr的显示风格
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    // 1.2查询所有可用的地区
    //NSLog(@"%@", [NSLocale availableLocaleIdentifiers]);
    // 1.3设置datePickr的地区语言, zh_Han后面是s的就为简体中文,zh_Han后面是t的就为繁体中文， zh_Hans_CN 简体中文 zh_Hant_CN 繁体中文 en_US 英文
    [datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"]];
    // 1.4监听datePickr的数值变化
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    // 1.5 设置默认时间
    [datePicker setDate:[NSDate date]];
    
    // 日期格式化类
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    // 设置日期格式 为了转换成功
    //    format.dateFormat = @"yyyy-MM-dd";
    format.dateFormat = @"yyyy-MM-dd";
    
    // NSString * -> NSDate *
    NSDate *minDate = [format dateFromString:@"1900-01-01"];
    
    NSDate *date = [NSDate date];
    
    NSString *currentTimeString = [format stringFromDate:date];
    
    NSDate *maxDate = [format dateFromString:currentTimeString];
    
    datePicker.minimumDate = minDate;
    
    datePicker.maximumDate = maxDate;
    
    datePicker.date = maxDate;
    
    [self addSubview:datePicker];
}


-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *view = [super hitTest:point withEvent:event];
    
    if(view == nil){
        
        [self datePickerViewRemoveView];
    }
    return view;
}

//出场
-(void)datePickerViewRemoveView{
    [self ba_animation_dismissFromPositionType:BAKit_ViewAnimationEnterDirectionTypeBottom duration:0.6f finishBlock:^{
        self.alpha = 0.1f;
        [self removeFromSuperview];
    }];
}
@end
