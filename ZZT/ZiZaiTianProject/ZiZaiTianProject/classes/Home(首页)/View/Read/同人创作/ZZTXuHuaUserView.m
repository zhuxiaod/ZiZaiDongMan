//
//  ZZTXuHuaUserView.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/4/11.
//  Copyright © 2019 ZiZaiTian. All rights reserved.
//

#import "ZZTXuHuaUserView.h"
#import "ZZTXuHuaCell.h"

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
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZZTXuHuaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZZTXuHuaUserViewID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark - 创建流水布局
-(UICollectionViewFlowLayout *)setupCollectionViewFlowLayout{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionViewLayout = layout;
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    layout.itemSize = CGSizeMake(64, 90);
    
    return layout;
}
@end
