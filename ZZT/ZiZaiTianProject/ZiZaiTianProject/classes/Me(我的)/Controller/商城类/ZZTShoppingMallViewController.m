//
//  ZZTShoppingMallViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/5.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTShoppingMallViewController.h"
#import "ZZTShoppingMallCell.h"
#import "ZZTShoppingBtnModel.h"
#import "ZZTShoppingHeader.h"
#import "ZZTShoppingBtnCell.h"
#import "ZZTMaterialCell.h"
#import "ZZTShoppingHeaderView.h"
#import <SDCycleScrollView.h>
#import "ZXDCartoonFlexoBtn.h"
#import "ZZTMallRecommendView.h"

#import "ZZTBigImageCell.h"
#import "ZZTCartoonCell.h"
#import "ZZTCollectionCycleView.h"
#import "ZZTSectionLabView.h"
#import "ZZTMoreFooterView.h"
#import "ZZTMallListModel.h"
#import "ZZTMallDetailViewController.h"
#import "ZZTDetailModel.h"
#import "ZZTMeWalletViewController.h"
#import "ZZTSearchBtn.h"
#import "ZZTMallFooterModel.h"


@interface ZZTShoppingMallViewController ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property (nonatomic,assign) int i;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIView *btnView;

@property (nonatomic,weak) UICollectionView *collectionView;

@property (nonatomic,strong) NSArray *cartoonArray;

@property (nonatomic,strong) NSArray *materialArray;

@property (nonatomic,strong) NSArray *headerArray;

@property (nonatomic,strong) NSMutableArray *footerArray;
//漫画推荐
@property (nonatomic,assign) NSInteger pageNum;
//素材推荐
@property (nonatomic,assign) NSInteger materialPageNum;
//漫画热门
@property (nonatomic,assign) NSInteger cartHotPageNum;
//素材热门
@property (nonatomic,assign) NSInteger materHotPageNum;

@property (nonatomic,strong) NSArray *bannerModelArray;

@property (nonatomic,weak) ZZTCollectionCycleView *cycleView;

@property (nonatomic,strong) ZZTMoreFooterView *moreVC;

@end

@implementation ZZTShoppingMallViewController

-(ZZTMoreFooterView *)moreVC{
    if(_moreVC == nil){
        _moreVC = [[ZZTMoreFooterView alloc] initWithFrame:CGRectZero];
    }
    return _moreVC;
}

#pragma mark - lazyLoad
-(NSArray *)cartoonArray{
    if(_cartoonArray == nil){
        _cartoonArray = [NSArray array];
    }
    return _cartoonArray;
}

-(NSArray *)materialArray{
    if(_materialArray == nil){
        _materialArray = [NSArray array];
    }
    return _materialArray;
}

-(NSArray *)bannerModelArray{
    if(!_bannerModelArray){
        _bannerModelArray = [NSArray array];
    }
    return _bannerModelArray;
}

-(NSArray *)headerArray{
    if(_headerArray == nil){
        _headerArray = [NSArray array];
    }
    return _headerArray;
}

//-(NSMutableArray *)footerArray{
//    if(_footerArray == nil){
//        _footerArray = [NSMutableArray array];
//    }
//    return _footerArray;
//}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.headerArray = @[@"漫画推荐",@"素材推荐",@"热门推荐",@"热门推荐"];
    
    self.footerArray = [NSMutableArray arrayWithObjects:           [ZZTMallFooterModel initWithPageNum:self.pageNum footerUrl:@"zztMall/getCartoonGoods" footerArray:self.cartoonArray],
        [ZZTMallFooterModel initWithPageNum:self.materialPageNum footerUrl:@"zztMall/getFodderGoods" footerArray:self.materialArray],
        [ZZTMallFooterModel initWithPageNum:self.pageNum footerUrl:@"zztMall/getCartoonGoods" footerArray:self.materialArray],
        [ZZTMallFooterModel initWithPageNum:self.pageNum footerUrl:@"zztMall/getFodderGoods" footerArray:self.materialArray],nil];
    
    //navBar
    [self setupNavBar];
    
    //设置内容页
    [self setupContentView];
    
    [self setupVariable];
    
    //加载数据
    [self loadBookData];
    
    [self loadBannerData];
    
    [self loadMaterialData];
    
    
}

#pragma mark - 设置初始化
-(void)setupVariable{
    
    self.pageNum = 1;
    self.materialPageNum = 1;
    self.cartHotPageNum = 1;
    self.materHotPageNum = 1;
}

#pragma mark - 设置导航栏
-(void)setupNavBar{
    [self setMeNavBarStyle];
    
    //充值
    [self.viewNavBar.rightButton setTitle:@"充值" forState:UIControlStateNormal];
    
    [self.viewNavBar.rightButton setTitleColor:[UIColor colorWithRGB:@"90,71,118"] forState:UIControlStateNormal];
    
    [self.viewNavBar.rightButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
     
    [self.viewNavBar.rightButton addTarget:self action:@selector(gotoTopupView) forControlEvents:UIControlEventTouchUpInside];
    
    self.viewNavBar.backgroundColor = [UIColor colorWithHexString:@"#1B0043"];
   
    //搞一个button
    ZZTSearchBtn *searchBtn = [[ZZTSearchBtn alloc] init];
    [self.viewNavBar addSubview:searchBtn];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openSearch)];
    [searchBtn addGestureRecognizer:tapGesture];
    
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.viewNavBar);
        make.centerY.equalTo(self.viewNavBar.centerButton.mas_centerY);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(240);
    }];
}

-(void)openSearch{
    ZXDSearchViewController *searchVC = [[ZXDSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:NO];
}

#pragma mark - 跳转充值页
-(void)gotoTopupView{
    //钱包
    ZZTMeWalletViewController *walletVC = [[ZZTMeWalletViewController alloc] init];
    walletVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:walletVC animated:YES];
}

#pragma mark - 设置内容页
-(void)setupContentView{
    //设置collectionView
    UICollectionViewFlowLayout *layout = [self setupCollectionViewFlowLayout];
    
    [self setupCollectionView:layout];
}

#pragma mark - 创建流水布局
-(UICollectionViewFlowLayout *)setupCollectionViewFlowLayout{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //修改尺寸(控制)
//    layout.itemSize = CGSizeMake(SCREEN_WIDTH/3 - 10,200);
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //行距
//    layout.minimumLineSpacing = 0;
//    layout.minimumInteritemSpacing = 5;
    
    return layout;
}

#pragma mark - 创建CollectionView
-(void)setupCollectionView:(UICollectionViewFlowLayout *)layout
{
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, navHeight, Screen_Width, SCREEN_HEIGHT - navHeight) collectionViewLayout:layout];
//    [collectionView setContentInset:UIEdgeInsetsMake(-Height_TabbleViewInset, 0, 0, 0)];
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[ZZTCollectionCycleView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionCycleView];
//    [self.collectionView registerClass:[ZZTHomeBtnView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:homeBtnView];
    [self.collectionView registerClass:[ZZTSectionLabView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionLabView];
//    [self.collectionView registerClass:[ZZTAirHeaderFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:airViewId];
    [self.collectionView registerClass:[ZZTMoreFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:moreFooterView];

    [self.collectionView registerClass:[ZZTCartoonCell class] forCellWithReuseIdentifier:cartoonCellId];
    [self.collectionView registerClass:[ZZTBigImageCell class] forCellWithReuseIdentifier:bigImageCell];
}

//节
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 5;
}

//行
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section == 0){
        return 0;
    }
    ZZTMallFooterModel *model = self.footerArray[section - 1];

    if(section == 3){
        return model.footerArray.count - 1;
    }else{
        return model.footerArray.count;
    }
}

//cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //漫画 第一节
    //素材 第二节
    ZZTCarttonDetailModel *model = [[ZZTCarttonDetailModel alloc] init];
    ZZTDetailModel *detailModel = [[ZZTDetailModel alloc] init];
    ZZTMallFooterModel *footerModel = self.footerArray[indexPath.section - 1];

    if(indexPath.section == 2 || indexPath.section == 4){
        detailModel = footerModel.footerArray[indexPath.row];
    }else{
        model = footerModel.footerArray[indexPath.row];
    }
    
    if(indexPath.row == 3 && indexPath.section == 1){
        ZZTBigImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bigImageCell forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }else{
        ZZTCartoonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cartoonCellId forIndexPath:indexPath];
        if(indexPath.section == 2 || indexPath.section == 4){
            cell.materialModel = detailModel;
        }else{
            cell.cartoon = model;
        }
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZZTMallFooterModel *model = self.footerArray[indexPath.section - 1];
    
    if(indexPath.section == 2 || indexPath.section == 4){
        ZZTDetailModel *detailModel = model.footerArray[indexPath.row];
        ZZTMallDetailViewController *vc = [[ZZTMallDetailViewController alloc] init];
        vc.model = detailModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ZZTCarttonDetailModel *md = model.footerArray[indexPath.row];
        ZZTWordDetailViewController *detailVC = [[ZZTWordDetailViewController alloc]init];
        detailVC.isId = YES;
        detailVC.cartoonDetail = md;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

//边距设置:整体边距的优先级，始终高于内部边距的优先级
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
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
    }else{
        return CGSizeMake((SCREEN_WIDTH - 36) / 3 , [Utilities getCarChapterH] + 24);
    }
}

//行距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0f;
}

//头
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    weakself(self);
    UICollectionReusableView *view = [[UICollectionReusableView alloc] init];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        if(indexPath.section == 0){
            //轮播图
            ZZTCollectionCycleView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionCycleView forIndexPath:indexPath];
            _cycleView = view;
            view.imageArray = self.bannerModelArray;
            return view;
        }else{
            //为您推荐
            ZZTSectionLabView *labView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionLabView forIndexPath:indexPath];
            labView.sectionName = _headerArray[indexPath.section - 1];
            return labView;
        }
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
            //跟多 刷一刷
            self.moreVC = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:moreFooterView forIndexPath:indexPath];
            self.moreVC.tag = indexPath.section;
            //更多
            _moreVC.moreBtnClick = ^{
                //跳转更多页面
                ZZTMoreViewController *moreVC = [[ZZTMoreViewController alloc] init];
                if(indexPath.section == 2 || indexPath.section == 4){
                    moreVC.moreTag = 2;
                }else{
                    moreVC.moreTag = 1;
                }
                moreVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:moreVC animated:YES];
            };
            //换一批
            self.moreVC.updateBtnClick = ^{
//                if(indexPath.section == 2){
//                    [self loadMaterialData];
//                }else{
//                    [self loadBookData];
//                }
                ZZTMallFooterModel *model = weakSelf.footerArray[indexPath.section - 1];
                [weakSelf.moreVC loadDataWithPageNum:model.pageNum url:model.footerUrl resultBlock:^(NSArray *array) {
                    model.footerArray = array;
                    model.pageNum++;
                    [weakSelf.collectionView reloadData];
                    //判断是那一组的 将数据赋值
                }];
            };
    

            return _moreVC;
        }
    return view;
}

//执行的 headerView 代理 返回 headerView 的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return CGSizeMake(SCREEN_WIDTH, [Utilities getBannerH]);
    }else{
        return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 0.052);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
   if (section == 1 || section == 4 || section == 2 || section == 3){
        //
        return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 0.074);
    }else{
        return CGSizeZero;
    }
}

#pragma mark - 数据加载
//换一批
-(void)loadBookData{
    ZZTMallFooterModel *model1 = self.footerArray[0];
    [self.moreVC loadDataWithPageNum:model1.pageNum url:model1.footerUrl resultBlock:^(NSArray *array) {
        model1.footerArray = array;
        model1.pageNum++;
        [self.footerArray replaceObjectAtIndex:0 withObject:model1];
        [self.collectionView reloadData];
    }];
    
    ZZTMallFooterModel *model2 = self.footerArray[2];
    [self.moreVC loadDataWithPageNum:model2.pageNum url:model2.footerUrl resultBlock:^(NSArray *array) {
        model2.footerArray = array;
        model2.pageNum++;
        [self.footerArray replaceObjectAtIndex:2 withObject:model2];
        [self.collectionView reloadData];
    }];
    
    ZZTMallFooterModel *model3 = self.footerArray[3];
    [self.moreVC loadDataWithPageNum:model3.pageNum url:model3.footerUrl resultBlock:^(NSArray *array) {
        model3.footerArray = array;
        model3.pageNum++;
        [self.footerArray replaceObjectAtIndex:3 withObject:model3];
        [self.collectionView reloadData];
    }];
    
    ZZTMallFooterModel *model = self.footerArray[1];
    [self.moreVC loadDataWithPageNum:model.pageNum url:model.footerUrl resultBlock:^(NSArray *array) {
        model.footerArray = array;
        model.pageNum++;
        //判断是那一组的 将数据赋值
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

-(void)loadMaterialData{
  
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
//    NSDictionary *dict = @{
//                           @"pageNum":[NSString stringWithFormat:@"%ld",(long)self.materialPageNum],
//                           @"pageSize":@"7",
//                           @"more":@"1"
//                           };
//    [manager POST:[ZZTAPI stringByAppendingString:@"zztMall/getFodderGoods"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
//        NSMutableArray *array = [ZZTDetailModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
//        self.materialArray = array;
//        self.materialPageNum++;
//        [self.collectionView reloadData];
//        [self.collectionView.mj_header endRefreshing];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [self.collectionView.mj_header endRefreshing];
//    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleLightContent;
}
@end
