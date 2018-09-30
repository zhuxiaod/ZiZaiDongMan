//
//  ZZTMEXuHuaCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/30.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTMEXuHuaCell.h"
@interface ZZTMEXuHuaCell ()

@property (nonatomic,strong) UILabel *dateLab;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UIView *bottomView;


@end

@implementation ZZTMEXuHuaCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    UILabel *dateLab = [GlobalUI createLabelFont:25 titleColor:[UIColor blackColor] bgColor:[UIColor whiteColor]];
    _dateLab = dateLab;
//    dateLab.frame = CGRectMake(10, 10, 100, 30);
    dateLab.text = @"今天";
    [self.contentView addSubview:dateLab];
    //编写button
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor greenColor];
    _button = button;
    [button setBackgroundImage:[UIImage imageNamed:@"正文-续"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    //底线
    UIView *bottomView = [[UIView alloc] init];
    _bottomView = bottomView;
    bottomView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:bottomView];
}

-(void)btnClick:(UIButton *)sender{
    if(self.buttonAction){
        self.buttonAction(sender);
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(10);
        make.left.equalTo(self.contentView).with.offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLab.mas_bottom).with.offset(10);
        make.left.equalTo(self.contentView).with.offset(20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).with.offset(0);
        make.left.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(0);
        make.height.mas_equalTo(1);
    }];
}
//block 点击事件

@end
