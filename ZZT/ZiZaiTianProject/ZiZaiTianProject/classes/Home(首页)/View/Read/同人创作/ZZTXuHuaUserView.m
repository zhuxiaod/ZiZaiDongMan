//
//  ZZTXuHuaUserView.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/4/11.
//  Copyright © 2019 ZiZaiTian. All rights reserved.
//

#import "ZZTXuHuaUserView.h"
#import "ZZTXuHuaCell.h"
#import "ZZTCartoonDetailViewController.h"
#import "ZZTChapterlistModel.h"

@interface ZZTXuHuaUserView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation ZZTXuHuaUserView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self setupCollectionViewFlowLayout];
    
    self.dataSource = self;
    self.delegate = self;

    [self registerNib:[UINib nibWithNibName:@"ZZTXuHuaCell" bundle:nil] forCellWithReuseIdentifier:@"ZZTXuHuaUserViewID"];

    self.showsHorizontalScrollIndicator = NO;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZZTXuHuaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZZTXuHuaUserViewID" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
  
    
    //跳转漫画详情页
    ZZTChapterlistModel *model = self.dataArray[indexPath.row];
    model.cartoonId = self.bookDetail.id;
    
    if(self.didUserItem){
        self.didUserItem(model);
    }
    
//    //跳页
//    ZZTCartoonDetailViewController *cartoonDetailVC = [[ZZTCartoonDetailViewController alloc] init];
//    cartoonDetailVC.chapterData = model;
//    cartoonDetailVC.bookData = self.bookDetail;
//    if(self.lastReadModel != nil){
//        cartoonDetailVC.JXYDModel = self.lastReadModel;
//    }
//    cartoonDetailVC.hidesBottomBarWhenPushed = YES;
//    [[self myViewController].navigationController pushViewController:cartoonDetailVC animated:YES];
}

#pragma mark - 创建流水布局
-(UICollectionViewFlowLayout *)setupCollectionViewFlowLayout{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionViewLayout = layout;
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    layout.itemSize = CGSizeMake(64, 90);
    
    return layout;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self reloadData];
}

- (void)setLastReadModel:(ZZTJiXuYueDuModel *)lastReadModel{
    _lastReadModel = lastReadModel;
}
@end
