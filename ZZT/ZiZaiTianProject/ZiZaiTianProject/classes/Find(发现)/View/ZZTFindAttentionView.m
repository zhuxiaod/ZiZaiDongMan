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
#import "UUWaveView.h"

@interface ZZTFindAttentionView ()

@property (nonatomic,strong) UIButton *backgroundBtn;

@property (nonatomic,strong) UIImageView *waveView;

@property (nonatomic,strong) ZZTUserHeadView *userHead;

@property (nonatomic,strong) SBStrokeLabel *userName;
//头像框
//头像
//用户名
@property (nonatomic, strong) UUWaveView *WaveView;

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
    _backgroundBtn.adjustsImageWhenHighlighted = NO;
    [_backgroundBtn setImage:[UIImage imageNamed:@"Me_homeBackground"] forState:UIControlStateNormal];
    [_backgroundBtn addTarget:self action:@selector(print) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_backgroundBtn];

    UUWave *secondWave1 = [[UUWave alloc] initWithStyle:UUWaveStyleSin
                                              direction:UUWaveDirectionRight
                                              amplitude:14.0f
                                                  width:SCREEN_WIDTH
                                              lineWidth:1.0f
                                                offsetX:0.0f
                                                  stepX:1.2f
                                           layerCreator:^CALayer *(CAShapeLayer *waveLayer) {
                                               waveLayer.backgroundColor = [UIColor clearColor].CGColor;
                                               waveLayer.fillColor = [UIColor whiteColor].CGColor;
                                               waveLayer.strokeColor = [UIColor whiteColor].CGColor;
                                               return waveLayer;
                                           }];

    _WaveView = [[UUWaveView alloc] init];
    [_WaveView addWaves:@[secondWave1]];
    [self.contentView addSubview:_WaveView];


    _userHead = [[ZZTUserHeadView alloc] initWithFrame:CGRectZero];
    [_userHead.viewClick addTarget:self action:@selector(print) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_userHead];
    
    _userName = [[SBStrokeLabel alloc] init];
    [_userName setTextColor:[UIColor whiteColor]];
    _userName.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_userName];
}

-(void)print{
    if(_gotoViewBlock){
        self.gotoViewBlock();
    }
}

-(void)setModel:(UserInfo *)model{
    _model = model;
    
    [self.backgroundBtn sd_setImageWithURL:[NSURL URLWithString:model.cover] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Me_homeBackground"]];
    
    [self.backgroundBtn.imageView  setContentMode:UIViewContentModeScaleAspectFill];
    
    self.backgroundBtn.imageView.clipsToBounds = YES;
    
    self.userHead.userImg = model.headimg;
    
    self.userName.text = model.nickName;
    
    [self.userName labOutline];
    //label宽度
    CGFloat nameWidth = [model.nickName getTextWidthWithFont:self.userName.font] + 30;

    [_userName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(nameWidth);
    }];
    
    [self.backgroundBtn.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.backgroundBtn);
    }];
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
    
    CGFloat waveH = 32;
//    //波浪
    [self.WaveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(waveH);
    }];
    
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.WaveView.mas_top).offset(-4);
        make.right.equalTo(self.userHead.mas_left).offset(-8);
        make.height.mas_equalTo(20);
    }];
}

@end
