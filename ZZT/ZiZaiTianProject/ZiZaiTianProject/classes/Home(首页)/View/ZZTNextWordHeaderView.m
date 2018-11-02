//
//  ZZTNextWordHeaderView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/10/22.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTNextWordHeaderView.h"
#import "ZXDCartoonFlexoBtn.h"
#import "ZZTStoryModel.h"

@interface ZZTNextWordHeaderView ()

@property (nonatomic,strong) UIView *buttomView;

@property (nonatomic,strong) UIView *centerView;

@end

@implementation ZZTNextWordHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    //背景色
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    //左
    _leftBtn = [[UIButton alloc] init];
//    _liftBtn.backgroundColor = [UIColor redColor];
    [_leftBtn setImage:[UIImage imageNamed:@"后退键"] forState:UIControlStateNormal];
    [_leftBtn setTitle:@"上一页" forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor colorWithRGB:@"127,127,127"] forState:UIControlStateNormal];
    [self.contentView addSubview:_leftBtn];
    [_leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    [_leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
    
    //右
    _rightBtn = [[UIButton alloc] init];
//    _rightBtn.backgroundColor = [UIColor blueColor];
    [_rightBtn setImage:[UIImage imageNamed:@"箭头右"] forState:UIControlStateNormal];
    [_rightBtn setTitle:@"下一页" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor colorWithRGB:@"127,127,127"] forState:UIControlStateNormal];
    [self.contentView addSubview:_rightBtn];
    [_rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 60)];
    [_rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 80, 0, 0)];
    
    UIView *buttomView = [[UIView alloc] init];
    buttomView.backgroundColor = [UIColor colorWithRGB:@"246,246,251"];
    [self.contentView addSubview:buttomView];
    _buttomView = buttomView;
    
    //中间View
    UIView *centerView = [[UIView alloc] init];
    [centerView setBackgroundColor:[UIColor colorWithRGB:@"229,229,229"]];
    [self.contentView addSubview:centerView];
    _centerView = centerView;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(0);
        make.left.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView).offset(0);
        make.width.equalTo(self.contentView).multipliedBy(0.5);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView).offset(0);
        make.width.equalTo(self.contentView).multipliedBy(0.5);
    }];
    
    [self.buttomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.contentView);
        make.height.mas_equalTo(4);
    }];
    
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(14);
        make.bottom.equalTo(self.contentView).offset(-14);
        make.width.mas_equalTo(1);
    }];
}



@end
