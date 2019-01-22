//
//  ZZTFindBannerView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/7.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTFindBannerView.h"
#import "UUWaveView.h"

@interface ZZTFindBannerView ()<SDCycleScrollViewDelegate>

@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic,strong) UIImageView *waveView;

@property (nonatomic, strong) UUWaveView *WaveView;

@end

@implementation ZZTFindBannerView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //轮播图
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView).offset(0);
    }];
    
    //波浪
    CGFloat waveH = 32;

    [self.WaveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(waveH);
    }];
}

#pragma mark lazy load
-(SDCycleScrollView *)cycleScrollView{
    if(!_cycleScrollView){
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage createImageWithColor:[UIColor whiteColor]]];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentLeft;
        [self.contentView addSubview:_cycleScrollView];
    }
    return _cycleScrollView;
}

-(UUWaveView *)WaveView{
    if(!_WaveView){
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
    }
    return _WaveView;
}
-(void)setImageArray:(NSString *)imageArray{
    _imageArray = imageArray;
    self.cycleScrollView.imageURLStringsGroup = [NSArray arrayWithObjects: @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535282045025&di=b648e41d5d5a3535e5518a545459d351&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20161123%2Fbfa082e23cd94089a907a29b021946bf_th.jpeg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535282045025&di=d2ddcf88c11b57887d64db25c870bd4f&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20170919%2F210211af972f4e3c8c5a7fda0fda7493.jpeg", nil];
}
@end
