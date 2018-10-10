//
//  ZZTMyZoneHeaderView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTMyZoneHeaderView.h"

@interface ZZTMyZoneHeaderView ()
@property (nonatomic,strong)UIImageView *bgImgV;
@property (nonatomic,strong)UIImageView *headImgV;
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UIView *headBgView;
@property (nonatomic,strong)UIView *bottomView;
@end

@implementation ZZTMyZoneHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

-(void)setUser:(UserInfo *)user{
    _user = user;
    [_bgImgV sd_setImageWithURL:[NSURL URLWithString:user.cover] placeholderImage:[UIImage createImageWithColor:[UIColor blackColor]]];
    _label.text = user.nickName;
    [_headImgV sd_setImageWithURL:[NSURL URLWithString:user.headimg]];
}

-(void)setup{
    self.backgroundColor = [UIColor whiteColor];
    UIImageView *bgImgV = [UIImageView new];
    _bgImgV = bgImgV;
    bgImgV.contentMode = UIViewContentModeScaleAspectFill;
    bgImgV.clipsToBounds = YES;
//    bgImgV.image = [UIImage imageNamed:@"peien"];
    
    UIView *headBgView = [UIView new];
    headBgView.backgroundColor = [UIColor whiteColor];
    _headBgView = headBgView;
    headBgView.layer.borderWidth = 0.5;
    headBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UIImageView *headImgV = [UIImageView new];
    _headImgV = headImgV;
    headImgV.contentMode = UIViewContentModeScaleAspectFill;
    headImgV.clipsToBounds = YES;
//    headImgV.image = [UIImage imageNamed:@"peien"];
    
    UILabel *label = [UILabel new];
    _label = label;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont systemFontOfSize:19];
//    label.text = @"雏田";
    
    UIView *bottomView = [[UIView alloc] init];
    _bottomView = bottomView;
    [bottomView setBackgroundColor:[UIColor blackColor]];
    [self addSubview:bottomView];
    
    [self addSubview:bgImgV];
    [self addSubview:headBgView];
    [headBgView addSubview:headImgV];
    [self addSubview:label];
    
  
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-40);
        make.top.equalTo(self).offset(-TOPBAR_HEIGHT);
//        make.top.equalTo(self).offset(-64);
        make.height.equalTo(@250);
    }];
    
    [self.headBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-20);
        make.right.equalTo(self).offset(-10);
        make.width.height.equalTo(@75);
    }];
    [self.headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.headBgView).offset(3);
        make.right.bottom.equalTo(self.headBgView).offset(-3);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headBgView.mas_left).offset(-20);
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self.bgImgV).offset(-7);
        make.height.equalTo(@25);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self.bgImgV.mas_bottom).offset(0);
        make.height.equalTo(@1);
    }];
}
@end
