//
//  ZZTUserHeadView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/8.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTUserHeadView.h"

@interface ZZTUserHeadView ()

@property (nonatomic,strong) UIImageView *headFrame;

@property (nonatomic,strong) UIImageView *headView;

@end

@implementation ZZTUserHeadView

// 1.重写initWithFrame:方法，创建子控件并添加到自己上面
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
    {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    _headFrame = [[UIImageView alloc] init];
    [_headFrame setImage:[UIImage imageNamed:@"我的-头像框"]];
    [self addSubview:_headFrame];
    
    _headView = [[UIImageView alloc] init];
    [self addSubview:_headView];
    
    _viewClick = [[UIButton alloc] init];
    [self addSubview:_viewClick];
}

-(void)setupUserHeadImg:(NSString *)userImg placeHeadImg:(NSString *)placeHeadImg{
    _userImg = userImg;
    _placeHeadImg = placeHeadImg;
    //
    [_headFrame setImage:[UIImage imageNamed:placeHeadImg]];
    [self.headView sd_setImageWithURL:[NSURL URLWithString:userImg]];
}

-(void)setPlaceHeadImg:(NSString *)placeHeadImg{
    _placeHeadImg = placeHeadImg;
}

-(void)setUserImg:(NSString *)userImg{
    _userImg = userImg;
    
    [self.headView sd_setImageWithURL:[NSURL URLWithString:userImg]];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.headFrame mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self);
    }];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(2);
        make.right.bottom.equalTo(self).offset(-2);
    }];
    
    [self.viewClick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self);
    }];
}
@end
