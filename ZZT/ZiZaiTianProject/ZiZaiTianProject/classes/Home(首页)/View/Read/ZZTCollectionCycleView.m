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

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation ZZTCollectionCycleView

-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        
        [self setupUI];
        
    } return self;
    
}

-(void)setupUI{
    // 网络加载图片的轮播器
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self);
    }];
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

-(SDCycleScrollView *)cycleScrollView{
    if(!_cycleScrollView){
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"bannerPlaceV"]];
        [self addSubview:_cycleScrollView];
    }
    return _cycleScrollView;
}

@end
