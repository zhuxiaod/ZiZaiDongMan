//
//  ZZTCommentImgView.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/1/14.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#define imgHeight  (CGRectGetWidth([UIScreen mainScreen].bounds) - 24 - 24)/3

#import "ZZTCommentImgView.h"
#import "ZZTMaterialCell.h"
#import "HZPhotoBrowser.h"
#import "ZZTMyZoneModel.h"
#import "JYEqualCellSpaceFlowLayout.h"

@interface ZZTCommentImgView ()<UICollectionViewDataSource,UICollectionViewDelegate>
//图片View
@property (strong, nonatomic) UICollectionView *collectionView;

@property (assign, nonatomic) CGFloat oneRowHeight;

@property (assign, nonatomic) CGFloat cellW;

@property (assign, nonatomic) CGFloat cellH;

@property (assign, nonatomic) BOOL isDown;

@property (strong, nonatomic) NSArray *imgArray;


@end

@implementation ZZTCommentImgView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //使用collectionView
//        UICollectionViewFlowLayout *layout = [self setupCollectionViewFlowLayout];

        JYEqualCellSpaceFlowLayout *flowLayout = [[JYEqualCellSpaceFlowLayout alloc]initWithType:AlignWithLeft betweenOfCell:10];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;

        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);

        [self setupCollectionView:flowLayout];
        
        self.oneRowHeight = 0.0f;
        _cellW = 140;
        _cellH = _cellW;
        self.isDown = NO;
        
    }
    return self;
}

-(void)layoutSubviews{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self);
    }];
    
}

//#pragma mark - 创建流水布局
//-(UICollectionViewFlowLayout *)setupCollectionViewFlowLayout{
//
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    //修改尺寸(控制)
////    layout.itemSize = CGSizeMake(imgHeight,imgHeight);
//
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    //行距
////    layout.minimumLineSpacing = 40;
////
////
////    layout.minimumInteritemSpacing = 40;
//
////    layout.estimatedItemSize = CGSizeMake(320, 60);
//
//    return layout;
//}

#pragma mark - 创建CollectionView
-(void)setupCollectionView:(UICollectionViewFlowLayout *)layout
{
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.collectionView];
    collectionView.pagingEnabled = YES;

    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZZTMaterialCell" bundle:nil]  forCellWithReuseIdentifier:@"wordImageCell1"];
}

//节
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//行
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imgArray.count;
}

//cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *imgStr = self.imgArray[indexPath.row];
    ZZTMaterialCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"wordImageCell1" forIndexPath:indexPath];
    cell.arrayCount = self.imgArray.count;
    cell.imageStr = imgStr;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_imgArray.count == 1) {
        if(self.cellW == 0 && self.cellH == 0){
            return CGSizeMake(self.cellW,self.cellH);
        }
        if(self.cellW > self.cellH){
            CGFloat height = 120;
            self.cellW = height * self.cellW / self.cellH;
            self.cellH = height;
        }else{
            CGFloat width = 120;
            self.cellH = width * self.cellH / self.cellW;
            self.cellW = width;
        }
        return CGSizeMake(self.cellW,self.cellH);
        
    }else if (_imgArray.count == 2){
        CGFloat WH = (SCREEN_WIDTH - 24 - 10) / 2;
        return CGSizeMake(WH, WH);
    }else if(_imgArray.count == 4){
        return CGSizeMake(self.collectionView.width / 2 - 5, self.collectionView.width / 2 - 5);
    }else{
        return CGSizeMake(imgHeight,imgHeight);
    }
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
    
    browser.isFullWidthForLandScape = YES;

    browser.isNeedLandscape = YES;

    browser.currentImageIndex = [[NSString stringWithFormat:@"%ld",indexPath.row] intValue];

    browser.imageArray = self.imgArray;
    
    [browser show];
}

-(CGFloat)getIMGHeight:(NSInteger)imgNum{
    CGFloat bgH = 0.0f;
    if(imgNum == 1){
        if(self.cellW > self.cellH){
            bgH = 120;
        }else{
            CGFloat width = 120;
            bgH = width * self.cellH / self.cellW;
        }
        if(isnan(bgH)){
            bgH = 0;
        }
    }else if (imgNum == 2){
        bgH = (SCREEN_WIDTH - 24 - 10) / 2;
    }else if (imgNum == 4){
        bgH = (SCREEN_WIDTH - 12 - 12);
    }else{
        NSInteger row = _imgArray.count / 3;// 多少行图片
        if (imgNum % 3 !=0) {
            ++row;
        }
        bgH = imgNum ? row * imgHeight + (row-1) * 10 :0;
    }
    return bgH;
}

-(void)reloadView{
    
    [self.collectionView reloadData];

}

-(void)setModel:(ZZTMyZoneModel *)model{
    _model = model;
    
    _imgArray = [model.contentImg componentsSeparatedByString:@","];
    
    if(_imgArray.count == 1){
        self.cellH = [model.high floatValue];
        self.cellW = [model.wide floatValue];
    }
    [self.collectionView reloadData];
}

@end
