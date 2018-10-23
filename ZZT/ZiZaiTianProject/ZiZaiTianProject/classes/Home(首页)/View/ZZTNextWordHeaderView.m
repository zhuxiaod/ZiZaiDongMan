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
    //三个View
    //中间的
    _centerBtn = [[ZXDCartoonFlexoBtn alloc] init];
//    _centerBtn.backgroundColor = [UIColor yellowColor];
//    [_centerBtn setImage:[UIImage imageNamed:@"正文-点赞-未点赞(灰色）"] forState:UIControlStateNormal];
    [_centerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_centerBtn setTitle:@"100" forState:UIControlStateNormal];
    [_centerBtn addTarget:self action:@selector(clickLike) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_centerBtn];

    //左
    _liftBtn = [[ImageLeftBtn alloc] init];
//    _liftBtn.backgroundColor = [UIColor redColor];
    [_liftBtn setImage:[UIImage imageNamed:@"后退键"] forState:UIControlStateNormal];
    [_liftBtn setTitle:@"上一页" forState:UIControlStateNormal];
    [_liftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:_liftBtn];
    //右
    _rightBtn = [[TypeButton alloc] init];
//    _rightBtn.backgroundColor = [UIColor blueColor];
    [_rightBtn setImage:[UIImage imageNamed:@"箭头右"] forState:UIControlStateNormal];
    [_rightBtn setTitle:@"下一页" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:_rightBtn];
    
    UIView *buttomView = [[UIView alloc] init];
    [buttomView setBackgroundColor:[UIColor grayColor]];
    [self.contentView addSubview:buttomView];
    _buttomView = buttomView;
}

-(void)clickLike{
    NSInteger praiseNum = [self.centerBtn.titleLabel.text integerValue];
    if([_likeModel.ifpraise isEqualToString:@"0"]){
        //没有人点赞
        _likeModel.ifpraise = @"1";
        praiseNum++;
        [self.centerBtn setImage:[UIImage imageNamed:@"正文-点赞-已点赞"] forState:UIControlStateNormal];
        [self.centerBtn setTitle:[NSString stringWithFormat:@"%ld",praiseNum] forState:UIControlStateNormal];
    }else{
        _likeModel.ifpraise = @"0";
        [self.centerBtn setImage:[UIImage imageNamed:@"正文-点赞-未点赞(灰色）"] forState:UIControlStateNormal];
        praiseNum--;
        [self.centerBtn setTitle:[NSString stringWithFormat:@"%ld",praiseNum] forState:UIControlStateNormal];
    }
    if (self.block)
    {
        self.block();
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.center.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-8);
        make.width.mas_equalTo(30);
    }];
    
    [self.liftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerBtn);
        make.right.equalTo(self.centerBtn.mas_left).offset(-8);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(24);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerBtn);
        make.left.equalTo(self.centerBtn.mas_right).offset(8);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(24);
    }];
    
    [self.buttomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}

-(void)setLikeModel:(ZZTStoryModel *)likeModel{
    _likeModel = likeModel;
    //点赞
    if([likeModel.ifpraise isEqualToString:@"0"]){
        [self.centerBtn setImage:[UIImage imageNamed:@"正文-点赞-未点赞(灰色）"] forState:UIControlStateNormal];
    }else{
        [self.centerBtn setImage:[UIImage imageNamed:@"正文-点赞-已点赞"] forState:UIControlStateNormal];
    }
    [self.centerBtn setTitle:[NSString stringWithFormat:@"%ld",likeModel.praiseNum] forState:UIControlStateNormal];
}

@end
