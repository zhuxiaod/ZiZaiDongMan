//
//  ZZTFindAttentionView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/8.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTFindAttentionView.h"
#import "ZZTUserHeadView.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface ZZTFindAttentionView ()

@property (nonatomic,strong) UIButton *backgroundBtn;

@property (nonatomic,strong) UIImageView *waveView;

@property (nonatomic,strong) ZZTUserHeadView *userHead;
//头像框
//头像
//用户名
@end

@implementation ZZTFindAttentionView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    _backgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backgroundBtn setImage:[UIImage imageNamed:@"用户空间背景"] forState:UIControlStateNormal];
    [self.contentView addSubview:_backgroundBtn];
    
    _waveView = [[UIImageView alloc] init];
    _waveView.backgroundColor = [UIColor clearColor];
    _waveView.image = [UIImage imageNamed:@"waveView"];
    [self.contentView addSubview:_waveView];
    
    _userHead = [[ZZTUserHeadView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_userHead];
}

-(void)setModel:(UserInfo *)model{
    _model = model;
    
    [self.backgroundBtn sd_setImageWithURL:[NSURL URLWithString:model.cover] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"用户空间背景"]];
    
    self.userHead.userImg = model.headimg;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.userHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.height.width.mas_equalTo(68);
    }];
    
    [self.backgroundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.contentView);
    }];
    
    //波浪
    [self.waveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(36);
    }];
}

@end
