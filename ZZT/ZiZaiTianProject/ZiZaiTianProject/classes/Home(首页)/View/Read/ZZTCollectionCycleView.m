//
//  ZZTCollectionCycleView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/12.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTCollectionCycleView.h"

@interface ZZTCollectionCycleView ()<SDCycleScrollViewDelegate>

@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;

@end

@implementation ZZTCollectionCycleView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        
        [self setupUI];
        
    } return self;
    
}

-(void)setupUI{
    // 网络加载图片的轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage createImageWithColor:[UIColor whiteColor]]];
    _cycleScrollView = cycleScrollView;
    [self addSubview:cycleScrollView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self);
    }];
}

-(void)setImageArray:(NSString *)imageArray{
    _imageArray = imageArray;
}

@end
