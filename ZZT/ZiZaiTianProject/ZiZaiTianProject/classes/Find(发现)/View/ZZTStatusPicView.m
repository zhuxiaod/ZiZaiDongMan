//
//  ZZTStatusPicView.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/4/22.
//  Copyright © 2019 ZiZaiTian. All rights reserved.
//

#import "ZZTStatusPicView.h"
#import "HZPhotoBrowser.h"


@interface ZZTStatusPicView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation ZZTStatusPicView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{

    self.dataSource = self;
    self.delegate = self;
    
    [self registerNib:[UINib nibWithNibName:@"ZZTStatusPicCell" bundle:nil] forCellWithReuseIdentifier:@"ZZTStatusPicCellId"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imgArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZZTStatusPicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZZTStatusPicCellId" forIndexPath:indexPath];
    NSString *imgStr = self.imgArray[indexPath.row];
    cell.imgUrl = imgStr;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];

    browser.isFullWidthForLandScape = YES;

    browser.isNeedLandscape = YES;

    browser.currentImageIndex = [[NSString stringWithFormat:@"%ld",indexPath.row] intValue];

    browser.imageArray = self.imgArray;

    [browser show];
}

-(void)setImgArray:(NSArray *)imgArray{
    _imgArray = imgArray;
    [self reloadData];
}


@end


@implementation ZZTStatusPicCell

- (void)setImgUrl:(NSString *)imgUrl{
    _imgUrl = imgUrl;
    
    [_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imgUrl]] placeholderImage:[UIImage imageNamed:@"worldPlaceV"] options:0];
}

@end



