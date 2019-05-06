//
//  ZZTReadHomeViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/12.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTReadHomeViewController.h"
#import "ZZTCollectionCycleView.h"
#import "ZZTSectionLabView.h"
#import "ZZTAirHeaderFooterView.h"
#import "ZZTCartoonCell.h"
#import "ZZTMoreFooterView.h"
#import "ZZTProductionShowViewController.h"
#import "ZZTRankViewController.h"
#import "ZZTClassifyViewController.h"
#import "ZZTBigImageCell.h"
#import "ZZTHomeTableViewModel.h"
#import "ZZTFirstViewBtn.h"

@interface ZZTReadHomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UICollectionViewDelegate >

@property (nonatomic,weak) UICollectionView *collectionView;

@property (nonatomic,strong) NSArray *caiNiXiHuan;

@property (nonatomic,strong) NSArray *bannerModelArray;

@property (nonatomic,weak) ZZTCollectionCycleView *cycleView;

@property (nonatomic,assign) NSInteger pageNum;
//最新更新
@property (nonatomic,strong) NSArray *updateBooks;
//经典好书
@property (nonatomic,strong) NSArray *classicBooks;

@property (nonatomic,strong) NSArray *headerArray;
//按钮Array
@property (nonatomic,strong) NSArray *btnArray;
@property (nonatomic,strong) NSArray *CollectHeaderFooterItemWH;


@end

static NSString *homeBtnView = @"homeBtnView";

@implementation ZZTReadHomeViewController

-(NSArray *)classicBooks{
    if(!_classicBooks){
        _classicBooks = [NSArray array];
    }
    return _classicBooks;
}

-(NSArray *)updateBooks{
    if(!_updateBooks){
        _updateBooks = [NSArray array];
    }
    return _updateBooks;
}

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

-(NSArray *)headerArray{
    if(!_headerArray){
        _headerArray = [NSArray array];
    }
    return _headerArray;
}

-(NSArray *)btnArray{
    if(!_btnArray){
        _btnArray = [NSArray array];
    }
    return _btnArray;
}


-(NSArray *)CollectHeaderFooterItemWH{
    if(!_CollectHeaderFooterItemWH){
        _CollectHeaderFooterItemWH = [NSArray array];
    }
    return _CollectHeaderFooterItemWH;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITextView appearance] setTintColor:ZZTSubColor];  // Text View
    [[UITextField appearance] setTintColor:ZZTSubColor];  // Text Field
    
    //数据源
    [self loadHeaderArray];
    
    [self btnDataSource];
    
    [self loadCollectHeaderFooterItemWH];
    
    //初始化
    self.pageNum = 1;

    //设置collectionView
    UICollectionViewFlowLayout *layout = [self setupCollectionViewFlowLayout];

    [self setupCollectionView:layout];

    //设置头视图
    [self setupMJRefresh];

    [_collectionView.mj_header beginRefreshing];
    
   
}

-(void)setupMJRefresh{
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadBannerData];
        [self loadVcData];
    }];
}

-(void)loadVcData{

    for (NSInteger i = 0;i < self.headerArray.count;i++) {
        ZZTHomeTableViewModel *model = self.headerArray[i];
        [self loadCellData:model];
    }
}

-(void)loadCellData:(ZZTHomeTableViewModel *)model{
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];

    NSDictionary *dic = @{
                          @"pageNum":@"1",
                          @"pageSize":model.cellNum,
                          @"more":@"1"
                          };
    [manager POST:[ZZTAPI stringByAppendingString:model.url] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        model.cellArray = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
        self.pageNum++;
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
    }];
}

-(void)loadBannerData{
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    weakself(self);
    [manager POST:[ZZTAPI stringByAppendingString:@"homepage/banner"] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        NSArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic];
        weakSelf.bannerModelArray = array;
        self.cycleView.imageArray = array;
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 创建流水布局
-(UICollectionViewFlowLayout *)setupCollectionViewFlowLayout{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    return layout;
}

#pragma mark - 创建CollectionView
-(void)setupCollectionView:(UICollectionViewFlowLayout *)layout
{
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, SCREEN_HEIGHT - 50) collectionViewLayout:layout];
    [collectionView setContentInset:UIEdgeInsetsMake(-Height_TabbleViewInset, 0, Height_TabBar, 0)];
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[ZZTCollectionCycleView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionCycleView];
    [self.collectionView registerClass:[ZZTSectionLabView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionLabView];
    [self.collectionView registerClass:[ZZTAirHeaderFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:airViewId];
    [self.collectionView registerClass:[ZZTMoreFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:moreFooterView];

    //cell
    [self.collectionView registerClass:[ZZTCartoonCell class] forCellWithReuseIdentifier:cartoonCellId];
    [self.collectionView registerClass:[ZZTBigImageCell class] forCellWithReuseIdentifier:bigImageCell];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZZTFirstViewBtn" bundle:nil] forCellWithReuseIdentifier:ZZTFirstViewBtnId];
}

//节
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.headerArray.count + 2;
}

//行
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if(section == 0){
        return self.btnArray.count;
    }else{
        ZZTHomeTableViewModel *tableViewModel = self.headerArray[section - 1];
        return tableViewModel.cellArray.count;
    }
}

//cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //btn
    if(indexPath.section == 0){
        //书图标
        ZZTFirstViewBtn *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZZTFirstViewBtnId forIndexPath:indexPath];
        ZZTHomeTableViewModel *model = self.btnArray[indexPath.row];
        cell.btnModel = model;
        return cell;
    }
    //书模型
    ZZTCarttonDetailModel *model = [[ZZTCarttonDetailModel alloc] init];
    
    //取数据
    ZZTHomeTableViewModel *tableViewModel = self.headerArray[indexPath.section - 1];
    model = tableViewModel.cellArray[indexPath.row];
    
    if(indexPath.row == 3 && indexPath.section == 1){
        ZZTBigImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bigImageCell forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }else{
        ZZTCartoonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cartoonCellId forIndexPath:indexPath];
        cell.cartoon = model;
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        ZZTHomeTableViewModel *model = self.btnArray[indexPath.row];
        model.block();
        return;
    }
    ZZTCarttonDetailModel *model = [[ZZTCarttonDetailModel alloc] init];
    
    ZZTHomeTableViewModel *tableViewModel = self.headerArray[indexPath.section - 1];
    model = tableViewModel.cellArray[indexPath.row];
    
    //独创
    ZZTWordDetailViewController *detailVC = [[ZZTWordDetailViewController alloc]init];
    //yes 就是有Id
    detailVC.isId = YES;
    detailVC.cartoonDetail = model;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

//头
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        if(indexPath.section == 0){
            //轮播图
            ZZTCollectionCycleView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionCycleView forIndexPath:indexPath];
            view.imageArray = self.bannerModelArray;
            return view;
        }else{
            //为您推荐
            ZZTSectionLabView *labView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionLabView forIndexPath:indexPath];
            ZZTHomeTableViewModel *tableViewModel = self.headerArray[indexPath.section - 1];
            labView.sectionName = tableViewModel.headerName;
            return labView;
        }
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
       if (indexPath.section == 1 || indexPath.section == 4 ||indexPath.section == 5){
            //更多 刷一刷
            ZZTMoreFooterView *moreVC = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:moreFooterView forIndexPath:indexPath];;
            moreVC.moreBtnClick = ^{
                NSInteger index = indexPath.section;
                //跳转更多页面
                ZZTMoreViewController *moreVC = [[ZZTMoreViewController alloc] init];
                moreVC.hidesBottomBarWhenPushed = YES;
                moreVC.modelTag = 1;
                moreVC.classTag = index;
                [self.navigationController pushViewController:moreVC animated:YES];
            };
            moreVC.updateBtnClick = ^{
                //更新数据
                ZZTHomeTableViewModel *model = self.headerArray[indexPath.section - 1];
                [self loadCellData:model];
            };
            return moreVC;
        }else{
            ZZTAirHeaderFooterView *airView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:airViewId forIndexPath:indexPath];
            return airView;
        }
    }else{
         return [[UICollectionReusableView alloc] init];
    }
}

//执行的 headerView 代理 返回 headerView 的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    ZZTHomeTableViewModel *sectionModel = self.CollectHeaderFooterItemWH[section];
    return sectionModel.headerWH;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    ZZTHomeTableViewModel *sectionModel = self.CollectHeaderFooterItemWH[section];
    return sectionModel.footerWH;

}

//边距设置:整体边距的优先级，始终高于内部边距的优先级
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if(section == 0){
        return UIEdgeInsetsMake(10, 18, 10, 18);
    }
    return UIEdgeInsetsMake(0, 8, 8, 8);//分别为上、左、下、右
}

//item
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 1){
        if(indexPath.row == 3){
            return CGSizeMake(SCREEN_WIDTH - 16, [Utilities getBigCarChapterH]);
        }else{
            return CGSizeMake((SCREEN_WIDTH - 36) / 3 , [Utilities getCarChapterH] + 24);
        }
    }else {
        ZZTHomeTableViewModel *sectionModel = self.CollectHeaderFooterItemWH[indexPath.section];
        return sectionModel.itemWH;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0f;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma -mark dataSource
-(void)btnDataSource{
    //按钮的数据源
    ZZTHomeTableViewModel *btn1 = [ZZTHomeTableViewModel initBtnModelWithImgUrl:@"hotIcon" title:@"热门"];
    btn1.block = ^{
        //热门
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjects:@[@"1",@"10"] forKeys:@[@"pageNum",@"pageSize"]];
        ZZTProductionShowViewController *productionVC = [[ZZTProductionShowViewController alloc] init];
        productionVC.model = [ZZTHomeTableViewModel initHotVCModel:@"cartoon/getHostCartoon" title:@"热门" parameters:dic];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:productionVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
  
    };
    
    ZZTHomeTableViewModel *btn2 = [ZZTHomeTableViewModel initBtnModelWithImgUrl:@"rankIcon" title:@"排行"];
    btn2.block = ^{
        //排行
        ZZTRankViewController *rankVC = [[ZZTRankViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rankVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    };
    
    ZZTHomeTableViewModel *btn3 = [ZZTHomeTableViewModel initBtnModelWithImgUrl:@"classifyIcon" title:@"分类"];
    btn3.block = ^{
        //分类
        ZZTClassifyViewController *classifyVC = [[ZZTClassifyViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:classifyVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    };
    
    ZZTHomeTableViewModel *btn4 = [ZZTHomeTableViewModel initBtnModelWithImgUrl:@"创作图标-分类入口" title:@"众创"];
    btn4.block = ^{
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjects:@[@"1",@"10",@"2",@"2"] forKeys:@[@"pageNum",@"pageSize",@"cartoonType",@"bookType"]];
        //热门
        ZZTProductionShowViewController *productionVC = [[ZZTProductionShowViewController alloc] init];
        productionVC.model = [ZZTHomeTableViewModel initHotVCModel:@"cartoon/cartoonlist" title:@"同人创作" parameters:dic];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:productionVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
     
    };
    
    self.btnArray = @[btn1,btn2,btn3,btn4];
}

#pragma - mark 尾头数据源
-(void)loadHeaderArray{
     self.headerArray = @[[ZZTHomeTableViewModel initHomeTableViewModelWithName:@"为您推荐" cellArray:nil url:@"cartoon/getRecommendCartoon" cellNum:@"7"],[ZZTHomeTableViewModel initHomeTableViewModelWithName:@"最热推荐" cellArray:nil url:@"cartoon/getHostCartoon" cellNum:@"6"],[ZZTHomeTableViewModel initHomeTableViewModelWithName:@"最近更新" cellArray:nil url:@"cartoon/getNewestCartoon" cellNum:@"6"],[ZZTHomeTableViewModel initHomeTableViewModelWithName:@"经典好书" cellArray:nil url:@"cartoon/getClassicsCartoon" cellNum:@"6"],[ZZTHomeTableViewModel initHomeTableViewModelWithName:@"完本推荐" cellArray:nil url:@"cartoon/getEedCartoon" cellNum:@"6"]];
}

#pragma - mark collectHeaderFooterItemWH
-(void)loadCollectHeaderFooterItemWH{
    ZZTHomeTableViewModel *section0 = [ZZTHomeTableViewModel initHomeCollectionViewWH:CGSizeMake(SCREEN_WIDTH, [Utilities getBannerH])  footerWH:CGSizeMake(SCREEN_WIDTH, 10) itemWH:CGSizeMake((SCREEN_WIDTH - 66) / 4, 80)];
    ZZTHomeTableViewModel *section1 = [ZZTHomeTableViewModel initHomeCollectionViewWH:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 0.052) footerWH:CGSizeMake(SCREEN_WIDTH, 120) itemWH:CGSizeMake((SCREEN_WIDTH - 36) / 3 , [Utilities getCarChapterH] + 24)];
    ZZTHomeTableViewModel *section2 = [ZZTHomeTableViewModel initHomeCollectionViewWH:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 0.052) footerWH:CGSizeMake(SCREEN_WIDTH, 60) itemWH:CGSizeMake((SCREEN_WIDTH - 36) / 3 , [Utilities getCarChapterH] + 24)];
    ZZTHomeTableViewModel *section3 = [ZZTHomeTableViewModel initHomeCollectionViewWH:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 0.052) footerWH:CGSizeMake(SCREEN_WIDTH, 60) itemWH:CGSizeMake((SCREEN_WIDTH - 36) / 3 , [Utilities getCarChapterH] + 24)];
    ZZTHomeTableViewModel *section4 = [ZZTHomeTableViewModel initHomeCollectionViewWH:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 0.052) footerWH:CGSizeMake(SCREEN_WIDTH, 120) itemWH:CGSizeMake((SCREEN_WIDTH - 36) / 3 , [Utilities getCarChapterH] + 24)];
    ZZTHomeTableViewModel *section5 = [ZZTHomeTableViewModel initHomeCollectionViewWH:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 0.052)  footerWH:CGSizeMake(SCREEN_WIDTH, 120) itemWH:CGSizeMake((SCREEN_WIDTH - 36) / 3 , [Utilities getCarChapterH] + 24)];
    
    self.CollectHeaderFooterItemWH = @[section0,section1,section2,section3,section4,section5];
}


@end
