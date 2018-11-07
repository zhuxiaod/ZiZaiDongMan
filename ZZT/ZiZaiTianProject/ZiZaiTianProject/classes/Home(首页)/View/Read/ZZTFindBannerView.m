//
//  ZZTFindBannerView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/7.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTFindBannerView.h"

@interface ZZTFindBannerView ()<SDCycleScrollViewDelegate>

@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic,strong) UIImageView *waveView;

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
    [self.waveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(36);
    }];
}
#pragma mark lazy load
-(SDCycleScrollView *)cycleScrollView{
    if(!_cycleScrollView){
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage createImageWithColor:[UIColor redColor]]];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentLeft;
        [self.contentView addSubview:_cycleScrollView];
    }
    return _cycleScrollView;
}

-(UIImageView *)waveView{
    if(!_waveView){
        _waveView = [[UIImageView alloc] init];
        _waveView.backgroundColor = [UIColor clearColor];
        _waveView.image = [UIImage imageNamed:@"waveView"];
        [self.contentView addSubview:_waveView];
    }
    return _waveView;
}
-(void)setImageArray:(NSString *)imageArray{
    _imageArray = imageArray;
    self.cycleScrollView.imageURLStringsGroup = [NSArray arrayWithObjects: @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535282045025&di=b648e41d5d5a3535e5518a545459d351&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20161123%2Fbfa082e23cd94089a907a29b021946bf_th.jpeg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535282045025&di=d2ddcf88c11b57887d64db25c870bd4f&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20170919%2F210211af972f4e3c8c5a7fda0fda7493.jpeg", nil];
}
@end
