//
//  ZZTCaiNiXiHuanView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/28.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTCaiNiXiHuanView.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface ZZTCaiNiXiHuanView ()

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIButton *updateBtn;

@property (strong, nonatomic) UIView *topView;

@property (strong, nonatomic) UIView *midView;

@property (strong, nonatomic) UIView *btView;

@property (strong, nonatomic) ToolBtn *btn;

@property (strong, nonatomic) UILabel *CNXHLab;

@property (strong, nonatomic) UIView *bottomView;

@end

@implementation ZZTCaiNiXiHuanView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setupUI{
    //上
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor clearColor];
    _topView = topView;
    [self addSubview:topView];
    UILabel *CNXHLab = [GlobalUI createLabelFont:14 titleColor:[UIColor blackColor] bgColor:[UIColor clearColor]];
    [CNXHLab setText:@"猜你喜欢"];
    CNXHLab.textAlignment = NSTextAlignmentCenter;
    _CNXHLab = CNXHLab;
    [topView addSubview:CNXHLab];
    //中
    UIView *midView = [[UIView alloc] init];
    midView.backgroundColor = [UIColor clearColor];
    _midView = midView;
    [self addSubview:midView];
    //下
    UIView *btView = [[UIView alloc] init];
    btView.backgroundColor = [UIColor clearColor];
    _btView = btView;
    [self addSubview:btView];
    ToolBtn *btn = [[ToolBtn alloc] init];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;

    [btn setImage:[UIImage imageNamed:@"搜索-换一批"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:10];
    [btn setTitle:@"换一批" forState:UIControlStateNormal];
    _btn = btn;
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

    [btView addSubview:btn];
    //底线
    UIView *bottomView = [[UIView alloc] init];
    _bottomView = bottomView;
    bottomView.backgroundColor = [UIColor colorWithRed:236.0f/255.0f green:237.0f/255.0f  blue:238.0f/255.0f  alpha:0.5];
    [self addSubview:bottomView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height/3 - 10);
    _midView.frame = CGRectMake(0, self.height/3-10, SCREEN_WIDTH, self.height/3+10);
    _btView.frame = CGRectMake(0, self.height/3*2, SCREEN_WIDTH, self.height/3-10);
    _CNXHLab.frame = CGRectMake(self.width/2 - 50, self.topView.height/2 - 15, 100, 30);
    CGFloat height = self.btView.height - 4;
    CGFloat width = 40;
    _btn.frame = CGRectMake(self.width/2 - (width/2), 2, width, height);
    _bottomView.frame = CGRectMake(0, self.height - 10, SCREEN_WIDTH, 10);
}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self setupMainView];
}

-(void)setupMainView{
    CGFloat space = 5;
    CGFloat btnW = (SCREEN_WIDTH - space * 5)/6;
    CGFloat btnH = btnW;
    
    //获得数据 几个 6个
    for (int i = 0; i < 6; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(_dataArray.count != 0){
            UserInfo *userInfo = self.dataArray[i];
            [btn sd_setImageWithURL:[NSURL URLWithString:userInfo.headimg] forState:UIControlStateNormal];
        }else{
            [btn setImage:[UIImage imageNamed:@"peien"] forState:UIControlStateNormal];
        }
        CGFloat x = (btnW + space) * i;
        btn.frame = CGRectMake(x, 2, btnW, btnH);
//        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.midView addSubview:btn];
    }
}

- (void)buttonClick:(UIButton *)button{
    // 判断下这个block在控制其中有没有被实现
    if (self.buttonAction) {
        // 调用block传入参数
        self.buttonAction(button);
    }
}
@end
