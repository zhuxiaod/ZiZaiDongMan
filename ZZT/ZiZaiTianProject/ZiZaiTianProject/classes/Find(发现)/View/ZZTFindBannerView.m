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

@property (nonatomic,strong) NSMutableArray *dataArray;


@end

@implementation ZZTFindBannerView

-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

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

-(void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    if(imageArray.count != 0){
        [self.dataArray removeAllObjects];
        for (int i = 0; i < imageArray.count; i++) {
            ZZTCarttonDetailModel *md = [imageArray objectAtIndex:i];
            [self.dataArray addObject:md.cover];
        }
    }
    //数组
    self.cycleScrollView.imageURLStringsGroup = self.dataArray;
    self.cycleScrollView.autoScrollTimeInterval = 5.0f;// 自动滚动时间间隔
   
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    ZZTCarttonDetailModel *md = [self.imageArray objectAtIndex:index];
    ZZTWordDetailViewController *detailVC = [[ZZTWordDetailViewController alloc]init];
    detailVC.isId = YES;
    detailVC.cartoonDetail = md;
    detailVC.hidesBottomBarWhenPushed = YES;
    [[self myViewController].navigationController pushViewController:detailVC animated:YES];

}
@end
