//
//  ZZTReadHomeViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/12.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTReadHomeViewController.h"
#import "ZZTCollectionCycleView.h"
#import "ZZTHomeBtnView.h"
#import "ZZTSectionLabView.h"
#import "ZZTAirHeaderFooterView.h"
#import "ZZTCartoonCell.h"

@interface ZZTReadHomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UICollectionViewDelegate >

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSArray *caiNiXiHuan;

@end

static NSString *collectionCycleView = @"collectionCycleView";

static NSString *homeBtnView = @"homeBtnView";

static NSString *sectionLabView = @"sectionLabView";

static NSString *airViewId = @"airViewId";

static NSString *cartoonCellId = @"cartoonCellId";

@implementation ZZTReadHomeViewController

-(NSArray *)caiNiXiHuan{
    if(!_caiNiXiHuan){
        _caiNiXiHuan = [NSArray array];
    }
    return _caiNiXiHuan;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建collectionView
    //创建3节
    //1 0 2 7 3 6

    //设置collectionView
    UICollectionViewFlowLayout *layout = [self setupCollectionViewFlowLayout];

    [self setupCollectionView:layout];

    //loadData
    [self loadBookData];

}

//-(instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if(self){
//        UICollectionViewFlowLayout *layout = [self setupCollectionViewFlowLayout];
//
//        [self setupCollectionView:layout];
//
//        //loadData
//        [self loadBookData];
//    }
//    return self;
//}

-(void)loadBookData{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    NSDictionary *dict = @{
                           @"pageNum":@"0",
                           @"pageSize":@"7"
                           };
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/getRecommendCartoon"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
        NSMutableArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
        self.caiNiXiHuan = array;
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 创建流水布局
-(UICollectionViewFlowLayout *)setupCollectionViewFlowLayout{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //修改尺寸(控制)
    layout.itemSize = CGSizeMake(SCREEN_WIDTH/3 - 10,200);
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //行距
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 5;
    
    return layout;
}

#pragma mark - 创建CollectionView
-(void)setupCollectionView:(UICollectionViewFlowLayout *)layout
{
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, SCREEN_HEIGHT) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[ZZTCollectionCycleView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionCycleView];
    [self.collectionView registerClass:[ZZTHomeBtnView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:homeBtnView];
    [self.collectionView registerClass:[ZZTSectionLabView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionLabView];
    [self.collectionView registerClass:[ZZTAirHeaderFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:airViewId];

//    [self.collectionView registerNib:[UINib nibWithNibName:@"ZZTCartoonCell" bundle:nil] forCellWithReuseIdentifier:cartoonCellId];
    [self.collectionView registerClass:[ZZTCartoonCell class] forCellWithReuseIdentifier:cartoonCellId];
    
}

//节
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

//行
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section == 0){
        return 0;
    }else{
        return self.caiNiXiHuan.count;
    }
//    else{
//        return 6;
//    }
}

//cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZTCartoonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cartoonCellId forIndexPath:indexPath];
    ZZTCarttonDetailModel *car = self.caiNiXiHuan[indexPath.row];
    if(indexPath.row == 3){
        cell.isHaveLab = YES;
    }
    cell.cartoon = car;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"我是%ld",(long)indexPath.row);
}

//头
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        if(indexPath.section == 0){
            //轮播图
            ZZTCollectionCycleView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionCycleView forIndexPath:indexPath];
            return view;
        }else if(indexPath.section == 1){
            //为您推荐
            ZZTSectionLabView *labView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionLabView forIndexPath:indexPath];
            return labView;
        }else{
            return nil;
        }

    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        if(indexPath.section == 0){
            //btnView
            ZZTHomeBtnView *btnView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:homeBtnView forIndexPath:indexPath];
            return btnView;
        }else{
            ZZTAirHeaderFooterView *airView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:airViewId forIndexPath:indexPath];
            return airView;
        }
    }else{
         return nil;
    }
}

//执行的 headerView 代理 返回 headerView 的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 0.36);
    }else if (section == 1){
        return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 0.06);
    }else{
        return CGSizeZero;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 0.144);
}

//边距设置:整体边距的优先级，始终高于内部边距的优先级
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 8, 0, 8);//分别为上、左、下、右
}

//item
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        if(indexPath.row == 3){
            return CGSizeMake(SCREEN_WIDTH - 16, SCREEN_HEIGHT * 0.32);
        }else{
            return CGSizeMake((SCREEN_WIDTH - 36) / 3 , SCREEN_HEIGHT * 0.3);
        }
    }else{
        return CGSizeZero;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0f;
}


@end
