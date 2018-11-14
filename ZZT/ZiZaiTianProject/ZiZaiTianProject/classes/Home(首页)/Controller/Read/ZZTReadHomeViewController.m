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
#import "ZZTMoreFooterView.h"
#import "ZZTProductionShowViewController.h"
#import "ZZTRankViewController.h"
#import "ZZTClassifyViewController.h"
#import "ZZTBigImageCell.h"


@interface ZZTReadHomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UICollectionViewDelegate >

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSArray *caiNiXiHuan;

@property (nonatomic,strong) NSArray *bannerModelArray;

@property (nonatomic,strong)ZZTCollectionCycleView *cycleView;

@property (nonatomic,assign) NSInteger pageNum;

@end

static NSString *collectionCycleView = @"collectionCycleView";

static NSString *homeBtnView = @"homeBtnView";

static NSString *sectionLabView = @"sectionLabView";

static NSString *airViewId = @"airViewId";

static NSString *cartoonCellId = @"cartoonCellId";

static NSString *moreFooterView = @"moreFooterView";

static NSString *bigImageCell = @"bigImageCell";

@implementation ZZTReadHomeViewController

-(NSArray *)caiNiXiHuan{
    if(!_caiNiXiHuan){
        _caiNiXiHuan = [NSArray array];
    }
    return _caiNiXiHuan;
}

-(NSArray *)bannerModelArray{
    if(!_bannerModelArray){
        _bannerModelArray = [NSArray array];
    }
    return _bannerModelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    self.pageNum = 1;
    //创建collectionView
    //创建3节
    //1 0 2 7 3 6

    //设置collectionView
    UICollectionViewFlowLayout *layout = [self setupCollectionViewFlowLayout];

    [self setupCollectionView:layout];

    //loadData
    [self loadBookData];
   
    //轮播图
    [self loadBannerData];
    //设置btn的样式  点击

    //设置头视图
    [self setupMJRefresh];
}

-(void)setupMJRefresh{
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadBookData];
    }];
}

-(void)loadBannerData{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    weakself(self);
    [manager POST:[ZZTAPI stringByAppendingString:@"homepage/banner"] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
        NSArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic];
        weakSelf.bannerModelArray = array;
        self.cycleView.imageArray = array;
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//换一批
-(void)loadBookData{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    NSDictionary *dict = @{
                           @"pageNum":[NSString stringWithFormat:@"%ld",self.pageNum],
                           @"pageSize":@"7",
                           @"more":@"1"
                           };
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/getRecommendCartoon"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
        NSMutableArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
        self.caiNiXiHuan = array;
        self.pageNum++;
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
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
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, SCREEN_HEIGHT - 50) collectionViewLayout:layout];
    [collectionView setContentInset:UIEdgeInsetsMake(-20, 0, 0, 0)];
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[ZZTCollectionCycleView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionCycleView];
    [self.collectionView registerClass:[ZZTHomeBtnView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:homeBtnView];
    [self.collectionView registerClass:[ZZTSectionLabView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionLabView];
    [self.collectionView registerClass:[ZZTAirHeaderFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:airViewId];
    [self.collectionView registerClass:[ZZTMoreFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:moreFooterView];

//    [self.collectionView registerNib:[UINib nibWithNibName:@"ZZTCartoonCell" bundle:nil] forCellWithReuseIdentifier:cartoonCellId];
    [self.collectionView registerClass:[ZZTCartoonCell class] forCellWithReuseIdentifier:cartoonCellId];
    [self.collectionView registerClass:[ZZTBigImageCell class] forCellWithReuseIdentifier:bigImageCell];
}

//节
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

//行
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section == 0){
        return 0;
    }else if(section == 1){
        return self.caiNiXiHuan.count;
    }else if(section == 2){
        return self.caiNiXiHuan.count - 1;
    }else{
        return 0;
    }
}

//cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZTCarttonDetailModel *car = self.caiNiXiHuan[indexPath.row];
    if(indexPath.row == 3 && indexPath.section == 1){
        ZZTBigImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bigImageCell forIndexPath:indexPath];
        cell.model = car;
        return cell;
    }else{
        ZZTCartoonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cartoonCellId forIndexPath:indexPath];
        cell.cartoon = car;
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZZTCarttonDetailModel *model = self.caiNiXiHuan[indexPath.row];
    //独创
    if([model.cartoonType isEqualToString:@"1"]){
        ZZTWordDetailViewController *detailVC = [[ZZTWordDetailViewController alloc]init];
        //yes 就是有Id
        detailVC.isId = YES;
        detailVC.cartoonDetail = model;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        ZZTMulWordDetailViewController *detailVC = [[ZZTMulWordDetailViewController alloc]init];
        detailVC.isId = YES;
        detailVC.cartoonDetail = model;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

//头
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        if(indexPath.section == 0){
            //轮播图
            ZZTCollectionCycleView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionCycleView forIndexPath:indexPath];
            view.imageArray = self.bannerModelArray;
            return view;
        }else if(indexPath.section == 1){
            //为您推荐
            ZZTSectionLabView *labView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionLabView forIndexPath:indexPath];
            labView.sectionName = @"为您推荐";
            return labView;
        }else if(indexPath.section == 2){
            //最热推荐
            ZZTSectionLabView *labView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionLabView forIndexPath:indexPath];
            labView.sectionName = @"最热推荐";
            return labView;
        }else{
            return nil;
        }

    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        if(indexPath.section == 0){
            //btnView
            ZZTHomeBtnView *btnView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:homeBtnView forIndexPath:indexPath];
            btnView.homeBtnClick = ^(UIButton *btn) {
                [self clickHomeBtn:btn];
            };
            return btnView;
        }else if (indexPath.section == 1){
            //跟多 刷一刷
            ZZTMoreFooterView *moreVC = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:moreFooterView forIndexPath:indexPath];;
            moreVC.moreBtnClick = ^{
                //跳转更多页面
                ZZTMoreViewController *moreVC = [[ZZTMoreViewController alloc] init];
                moreVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:moreVC animated:YES];
            };
            moreVC.updateBtnClick = ^{
                //更新数据
                [self loadBookData];
            };
            return moreVC;
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
    }else{
        return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 0.06);
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if(section == 0){
        return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 0.144);
    }else if (section == 1){
        return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 0.084);
    }else{
        return CGSizeZero;
    }
    
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
    }else if(indexPath.section == 2){
        return CGSizeMake((SCREEN_WIDTH - 36) / 3 , SCREEN_HEIGHT * 0.3);
    }else{
        return CGSizeZero;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0f;
}

//点击homeBtn
-(void)clickHomeBtn:(UIButton *)btn{
    if(btn.tag == 1){
        //热门
        ZZTProductionShowViewController *productionVC = [[ZZTProductionShowViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:productionVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        productionVC.viewTitle = @"热门";
        //请求数据
//        [self loadProductionData:@"1" VC:productionVC];
    }else if (btn.tag == 2){
        //排行
        ZZTRankViewController *rankVC = [[ZZTRankViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rankVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else{
        //分类
        ZZTClassifyViewController *classifyVC = [[ZZTClassifyViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:classifyVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

@end
