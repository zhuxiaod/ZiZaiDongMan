//
//  ZZTCartoonHeaderView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/10.
//  Copyright © 2018年 zxd. All rights reserved.
//
static const CGFloat spaceing = 10.0f;
static const CGFloat contentHeight = 22.0f;

#import "ZZTCartoonHeaderView.h"

@interface ZZTCartoonHeaderView ()

@property (weak, nonatomic)  UILabel *titleView;

@end

@implementation ZZTCartoonHeaderView

-(instancetype)init{
    self = [super init];
    if(self){
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    //标题
    UILabel *titleView = [[UILabel alloc] init];
    titleView.font = [UIFont systemFontOfSize:15];
    titleView.textColor = colorWithWhite(0.5);
    self.titleView = titleView;
    [titleView setTextColor:[UIColor blackColor]];
    [self addSubview:titleView];
    self.titleView = titleView;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-8);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.equalTo(@(30));
    }];
    
}
//先走
-(void)setTitle:(NSString *)title{
    _title = title;
    [self.titleView setText:title];
}

@end
