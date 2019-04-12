//
//  ZZTCycleCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/9.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTCycleCell.h"
#import "DCPicScrollViewConfiguration.h"
#import "DCPicScrollView.h"
#import "ZZTCartoonBtnCell.h"
#import "ZZTWordDetailViewController.h"
#import "ZZTMulWordDetailViewController.h"
#import "SDCycleScrollView.h"
@interface ZZTCycleCell()<DCPicScrollViewDelegate,DCPicScrollViewDataSource,SDCycleScrollViewDelegate>

@property (nonatomic,strong)NSMutableArray *imageArray;

@end

@implementation ZZTCycleCell

-(NSMutableArray *)imageArray{
    if(!_imageArray){
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self setupPicScrollView];
}

#pragma mark 设置无线轮播器
- (void)setupPicScrollView {
    if(self.dataArray.count != 0){
        [self.imageArray removeAllObjects];
        for (int i = 0; i < self.dataArray.count; i++) {
            ZZTCarttonDetailModel *md = [self.dataArray objectAtIndex:i];
            [self.imageArray addObject:md.cover];
        }
    }
    //轮播器模型
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BanerHeight) delegate:self placeholderImage:[UIImage imageNamed:@"peien"]];
        //数组
    cycleScrollView.imageURLStringsGroup = self.imageArray;
    cycleScrollView.autoScrollTimeInterval = 5.0f;// 自动滚动时间间隔
    
    [self addSubview:cycleScrollView];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    ZZTCarttonDetailModel *md = [self.dataArray objectAtIndex:index];
    if([md.cartoonType isEqualToString:@"1"]){
        ZZTWordDetailViewController *detailVC = [[ZZTWordDetailViewController alloc]init];
        detailVC.isId = YES;
        detailVC.cartoonDetail = md;
        detailVC.hidesBottomBarWhenPushed = YES;
        [[self myViewController].navigationController pushViewController:detailVC animated:YES];
    }else{
        ZZTMulWordDetailViewController *detailVC = [[ZZTMulWordDetailViewController alloc]init];
        detailVC.isId = YES;
        detailVC.cartoonDetail = md;
        detailVC.hidesBottomBarWhenPushed = YES;
        [[self myViewController].navigationController pushViewController:detailVC animated:YES];
    }
}

@end
