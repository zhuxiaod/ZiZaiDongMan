//
//  ZZTLikeCollectShareHeaderView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/1.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTLikeCollectShareHeaderView.h"
#import "ZZTStoryModel.h"

@interface ZZTLikeCollectShareHeaderView ()

@property (nonatomic,strong) UIButton *likeBtn;

@property (nonatomic,strong) UILabel *likeLab;

@property (nonatomic,strong) UILabel *collectLab;

@property (nonatomic,strong) UILabel *shareLab;

@property (nonatomic,strong) UIView *bottomView;

//点赞状态
@property (nonatomic,strong) NSString *isLike;

//点赞数量
@property (nonatomic,assign) NSInteger likeNum;

@end

@implementation ZZTLikeCollectShareHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    self.contentView.backgroundColor = [UIColor whiteColor];
    //点赞
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeBtn = likeBtn;
//    _likeBtn.backgroundColor = [UIColor redColor];
    likeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    likeBtn.enabled = NO;
    [likeBtn addTarget:self action:@selector(likeTarget:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:likeBtn];
    
    //点赞lab
    UILabel *likeLab = [[UILabel alloc] init];
    _likeLab = likeLab;
    likeLab.textAlignment = NSTextAlignmentCenter;
    likeLab.text = @"赞";
//    likeLab.backgroundColor = [UIColor orangeColor];
    likeLab.textColor = [UIColor colorWithRGB:@"127,127,127"];
    [self.contentView addSubview:likeLab];
    
    //关注
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectBtn = collectBtn;
//    collectBtn.backgroundColor = [UIColor redColor];
    collectBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [collectBtn addTarget:self action:@selector(collectTarget:) forControlEvents:UIControlEventTouchUpInside];
    [collectBtn setImage:[UIImage imageNamed:@"作品-作品信息-收藏-未收藏"] forState:UIControlStateNormal];
    [collectBtn setImage:[UIImage imageNamed:@"作品-作品信息-收藏-已收藏"] forState:UIControlStateSelected];
    [self.contentView addSubview:collectBtn];

    //关注lab
    UILabel *collectLab = [[UILabel alloc] init];
    _collectLab = collectLab;
//    collectLab.backgroundColor = [UIColor orangeColor];
    collectLab.text = @"关注收藏";
    collectLab.textAlignment = NSTextAlignmentCenter;
    collectLab.textColor = [UIColor colorWithRGB:@"127,127,127"];
    [self.contentView addSubview:collectLab];

    //分享
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareBtn = shareBtn;
//    _shareBtn.backgroundColor = [UIColor redColor];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:12];

    [self.contentView addSubview:shareBtn];
    
    //分享lab
    UILabel *shareLab = [[UILabel alloc] init];
    _shareLab = shareLab;
//    shareLab.backgroundColor = [UIColor orangeColor];
    shareLab.text = @"分享";
    shareLab.textColor = [UIColor colorWithRGB:@"127,127,127"];
    shareLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:shareLab];
    
    //底线
    UIView *bottomView = [[UIView alloc] init];
    _bottomView = bottomView;
    bottomView.backgroundColor = [UIColor colorWithRGB:@"246,246,251"];
    [self.contentView addSubview:bottomView];
}

-(void)collectTarget:(UIButton *)btn{
    _collectBtn.selected = !_collectBtn.selected;
    if(_collectBtnBlock){
        self.collectBtnBlock();
    }
}

-(void)likeTarget:(UIButton *)btn{
    if([self.isLike isEqualToString:@"0"]){
        //没有点赞
        self.isLike = @"1";
        //++
        self.likeNum++;
    }else{
        self.isLike = @"0";
        self.likeNum--;
    }
    _likeLab.text = [NSString stringWithFormat:@"赞 %ld",self.likeNum];
    if(_likeBtnBlock){
        self.likeBtnBlock();
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat HW = self.contentView.height * 0.48;
    //点赞
    [_likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(-20);
        make.left.equalTo(self.contentView).offset(44);
        make.height.width.mas_equalTo(HW);
    }];
    
    [_likeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.likeBtn.mas_bottom).offset(12);
        make.centerX.equalTo(self.likeBtn);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(70);
    }];
    
    //关注
    [_collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(-20);
        make.centerX.equalTo(self.contentView);
        make.height.width.mas_equalTo(HW);
    }];
    
    [_collectLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectBtn.mas_bottom).offset(12);
        make.centerX.equalTo(self.collectBtn);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(70);
    }];
    
    //分享
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(-20);
        make.right.equalTo(self.contentView).offset(-44);
        make.height.width.mas_equalTo(HW);
    }];
    
    [_shareLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shareBtn.mas_bottom).offset(12);
        make.centerX.equalTo(self.shareBtn);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(70);
    }];
    //底线
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(1);
    }];
}

-(void)setLikeModel:(ZZTStoryModel *)likeModel{
    _likeModel = likeModel;
    self.likeNum = likeModel.praiseNum;
    self.isLike = likeModel.ifpraise;
    _likeBtn.enabled = YES;
    //点赞
    if([likeModel.ifpraise isEqualToString:@"0"]){
        [self.likeBtn setImage:[UIImage imageNamed:@"正文-点赞-未点赞(灰色）"] forState:UIControlStateNormal];
    }else{
        [self.likeBtn setImage:[UIImage imageNamed:@"正文-点赞-已点赞"] forState:UIControlStateNormal];
    }
    _likeLab.text = [NSString stringWithFormat:@"赞 %ld",likeModel.praiseNum];
}

-(void)setIsCollect:(NSString *)isCollect{
    _isCollect = isCollect;
    if ([_isCollect isEqualToString:@"1"]) {
        //点赞了
        _collectBtn.selected = YES;
    }else{
        _collectBtn.selected = NO;
    }
}
@end
