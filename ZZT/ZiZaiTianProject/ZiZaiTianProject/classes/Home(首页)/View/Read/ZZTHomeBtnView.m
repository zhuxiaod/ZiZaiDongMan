//
//  ZZTHomeBtnView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/12.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTHomeBtnView.h"
@interface ZZTHomeBtnView ()

@property (nonatomic,strong) UIButton *hotBtn;
@property (nonatomic,strong) UIButton *rankBtn;
@property (nonatomic,strong) UIButton *classifyBtn;

@property (nonatomic,strong) UILabel *hotLab;
@property (nonatomic,strong) UILabel *rankLab;
@property (nonatomic,strong) UILabel *classifyLab;

@end
@implementation ZZTHomeBtnView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        
        [self setupUI];
        
    } return self;
    
}

-(void)setupUI{
    self.backgroundColor = [UIColor whiteColor];

    //热门
    UIButton *hotBtn = [[UIButton alloc] init];
//    hotBtn.backgroundColor = [UIColor redColor];
    [hotBtn setImage:[UIImage imageNamed:@"hotIcon"] forState:UIControlStateNormal];
    [hotBtn addTarget:self action:@selector(btnTarget:) forControlEvents:UIControlEventTouchUpInside];
    _hotBtn = hotBtn;
    hotBtn.tag = 1;
    [self addSubview:hotBtn];
    
    //热门lab
    UILabel *hotLab = [[UILabel alloc] init];
    hotLab.text = @"热门";
    hotLab.attributedText = [NSString addStrSpace:hotLab.text];
    _hotLab = hotLab;
//    hotLab.backgroundColor = [UIColor blueColor];
    hotLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:hotLab];
    
    //排行
    UIButton *rankBtn = [[UIButton alloc] init];
//    rankBtn.backgroundColor = [UIColor redColor];
    [rankBtn setImage:[UIImage imageNamed:@"rankIcon"] forState:UIControlStateNormal];
    [rankBtn addTarget:self action:@selector(btnTarget:) forControlEvents:UIControlEventTouchUpInside];
    rankBtn.tag = 2;
    _rankBtn = rankBtn;
    [self addSubview:rankBtn];
    
    //排行
    UILabel *rankLab = [[UILabel alloc] init];
    rankLab.text = @"排行";
    rankLab.attributedText = [NSString addStrSpace:rankLab.text];
    _rankLab = rankLab;
    rankLab.textAlignment = NSTextAlignmentCenter;
//    rankLab.backgroundColor = [UIColor blueColor];
    [self addSubview:rankLab];
    
    //分类
    UIButton *classifyBtn = [[UIButton alloc] init];
//    classifyBtn.backgroundColor = [UIColor redColor];
    [classifyBtn setImage:[UIImage imageNamed:@"classifyIcon"] forState:UIControlStateNormal];
    [classifyBtn addTarget:self action:@selector(btnTarget:) forControlEvents:UIControlEventTouchUpInside];
    _classifyBtn = classifyBtn;
    classifyBtn.tag = 3;
    [self addSubview:classifyBtn];
    
    //分类
    UILabel *classifyLab = [[UILabel alloc] init];
    classifyLab.text = @"分类";
    classifyLab.attributedText = [NSString addStrSpace:classifyLab.text];

    _classifyLab = classifyLab;
    classifyLab.textAlignment = NSTextAlignmentCenter;
//    classifyLab.backgroundColor = [UIColor blueColor];
    [self addSubview:classifyLab];
}

-(void)btnTarget:(UIButton *)btn{
    if(self.homeBtnClick){
        self.homeBtnClick(btn);
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat HW = self.height - 50;
    CGFloat space = (self.width - HW * 3)/4;

    [_rankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(14);
        make.bottom.equalTo(self).offset(-36);
        make.centerX.equalTo(self);
        make.height.width.mas_equalTo(HW);
    }];
    
    [_hotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rankBtn);
        make.bottom.equalTo(self.rankBtn);
        make.right.equalTo(self.rankBtn.mas_left).offset(-space);
        make.height.width.mas_equalTo(HW);
    }];
    
    [_classifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rankBtn);
        make.bottom.equalTo(self.rankBtn);
        make.left.equalTo(self.rankBtn.mas_right).offset(space);
        make.height.width.mas_equalTo(HW);
    }];
    
    [_hotLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hotBtn.mas_bottom).offset(4);
        make.height.mas_equalTo(20);
        make.centerX.equalTo(self.hotBtn);
        make.width.equalTo(self.hotBtn);
    }];
    
    [_rankLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rankBtn.mas_bottom).offset(4);
        make.height.mas_equalTo(20);
        make.centerX.equalTo(self.rankBtn);
        make.width.equalTo(self.rankBtn);
    }];
    
    [_classifyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classifyBtn.mas_bottom).offset(4);
        make.height.mas_equalTo(20);
        make.centerX.equalTo(self.classifyBtn);
        make.width.equalTo(self.classifyBtn);
    }];
}
@end
