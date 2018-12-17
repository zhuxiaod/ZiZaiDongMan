//
//  ZZTCartCoverSetView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/15.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTCartCoverSetView.h"
#import "replyCountView.h"

@interface ZZTCartCoverSetView ()

@property (nonatomic,strong) UIImageView *coverImgView;

@property (nonatomic,strong) UIImageView *bannerImgView;

@property (nonatomic,strong) SBStrokeLabel *coverLab;

@property (nonatomic,strong) SBStrokeLabel *bannerLab;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UILabel *remindLab;
//评论
@property (strong, nonatomic) replyCountView *replyCountView;
//点赞
@property (strong, nonatomic) likeCountView *likeCountView;

@end

@implementation ZZTCartCoverSetView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        //添加UI
        [self addUI];
        
    }
    return self;
}

-(void)addUI{
//    200 - 42
    //540 * 390
    UIImageView *coverImgView = [[UIImageView alloc] init];
    coverImgView.backgroundColor = [UIColor redColor];
    _coverImgView = coverImgView;
    [self addSubview:coverImgView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCoverImgView)];
    [coverImgView addGestureRecognizer:tapGesture];
    coverImgView.userInteractionEnabled = YES;

    
    SBStrokeLabel *coverLab = [[SBStrokeLabel alloc] init];
    coverLab.textColor = [UIColor whiteColor];
    coverLab.text = @"540*390";
    [coverLab labOutline];
    _coverLab = coverLab;
    [self addSubview:coverLab];
    
    //1080 * 650
    UIImageView *bannerImgView = [[UIImageView alloc] init];
    bannerImgView.backgroundColor = [UIColor blueColor];
    _bannerImgView = bannerImgView;
    [self addSubview:bannerImgView];
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBannerImgView)];
    [bannerImgView addGestureRecognizer:tapGesture1];
    bannerImgView.userInteractionEnabled = YES;
    
    SBStrokeLabel *bannerLab = [[SBStrokeLabel alloc] init];
    bannerLab.textColor = [UIColor whiteColor];
    bannerLab.text = @"1080*650";
    [bannerLab labOutline];
    _bannerLab= bannerLab;
    [self addSubview:bannerLab];
    
    //点击图片条
    UILabel *remindLab = [[UILabel alloc] init];
    _remindLab = remindLab;
    remindLab.text = @"点击图片更换封面与轮播图";
    remindLab.textColor = [UIColor lightGrayColor];
    [self addSubview:remindLab];
    
    //底部条
    UIView *bottomView = [[UIView alloc] init];
    _bottomView = bottomView;
    bottomView.backgroundColor = ZZTLineColor;
    [self addSubview:bottomView];
    
    //点击图片btn
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat space = 10.0f;
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.right.left.equalTo(self);
        make.height.mas_equalTo(4);
    }];
    
    [self.remindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_top).offset(-4);
        make.left.equalTo(self).offset(space);
        make.height.mas_equalTo(20);
    }];
    
    [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(space);
        make.top.equalTo(self).offset(space);
        make.bottom.equalTo(self.remindLab.mas_top).offset(-4);
        make.width.mas_equalTo(114);
    }];
    
    [self.coverLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.coverImgView.mas_centerX);
        make.bottom.equalTo(self.coverImgView.mas_bottom).offset(-4);
        make.height.mas_equalTo(20);
    }];
    
    [self.bannerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImgView.mas_right).offset(10);
        make.bottom.equalTo(self.coverImgView.mas_bottom);
        make.top.equalTo(self.coverImgView.mas_top);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    [self.bannerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bannerImgView.mas_centerX);
        make.bottom.equalTo(self.bannerImgView.mas_bottom).offset(-4);
        make.height.mas_equalTo(20);
    }];
    
    [self.replyCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.remindLab);
        make.right.equalTo(self.mas_right).offset(-space);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(60);
    }];
    
    [self.likeCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.replyCountView);
        make.right.equalTo(self.replyCountView.mas_left).offset(-space);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(60);
    }];
}

-(void)clickCoverImgView{
    NSLog(@"clickCoverImgView");
}

-(void)clickBannerImgView{
    NSLog(@"clickBannerImgView");
}














//评论
- (replyCountView *)replyCountView {
    if (!_replyCountView) {
        
        replyCountView *btn = [[replyCountView alloc]init];
        
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        
        [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        
        [self addSubview:btn];
        
        _replyCountView = btn;
    }
    
    return _replyCountView;
}

- (likeCountView *)likeCountView {
    if (!_likeCountView) {
        
        likeCountView *lcv = [[likeCountView alloc] init];
        
        lcv.userInteractionEnabled = NO;
        
        lcv.titleLabel.textColor = ZZTSubColor;
        
        [lcv setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        
        [lcv setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        
        weakself(self);
        //发现点赞
        [lcv setOnClick:^(likeCountView *btn) {
            //用户点赞
//            [self userLikeTarget];
        }];
        
        [self addSubview:lcv];
        
        _likeCountView = lcv;
    }
    return _likeCountView;
}

@end
