//
//  ZZTProductionShowViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/21.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTProductionShowViewController.h"
#import "ZZTHomeTableViewModel.h"
#import "ZZTCartoonViewController.h"

@interface ZZTProductionShowViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,PYSearchViewControllerDelegate,PYSearchViewControllerDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *cartoons;

@property (nonatomic,weak) PYSearchViewController *searchVC;

@property (nonatomic,strong) NSMutableArray *searchSuggestionArray;

@property (nonatomic,assign) NSInteger pageNumber;
//页码size
@property (nonatomic,assign) NSInteger pageSize;

@end

NSString *SuggestionView1 = @"SuggestionView1";

@implementation ZZTProductionShowViewController

-(NSMutableArray *)cartoons{
    if (!_cartoons) {
        _cartoons = [NSMutableArray array];
    }
    return _cartoons;
}

-(NSMutableArray *)searchSuggestionArray{
    if(!_searchSuggestionArray){
        _searchSuggestionArray = [NSMutableArray array];
    }
    return _searchSuggestionArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageSize = 10;
    
    self.pageNumber = 2;
    //数据源传进来
    UICollectionViewFlowLayout *layout = [self setupCollectionViewFlowLayout];
    
    [self setupCollectionView:layout];
    
    [self.viewNavBar.centerButton setTitle:@"热门" forState:UIControlStateNormal];
    
    [self addBackBtn];
    
    [self setupMJRefresh];
    
    [self.view bringSubviewToFront:self.viewNavBar];
    
    [self loadNewData];

}

-(void)setupMJRefresh{
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
}

-(void)loadMoreData{
    [self changeDict:@"pageNum" addNum:1];
    
    [self loadNewArray:self.model.parameters url:self.model.url finished:^(id  _Nullable responseObject, NSError *error) {
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        
        NSArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
        
        NSInteger total = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"total"]] integerValue];
        
        [self.cartoons addObjectsFromArray:array];
        
        [self.collectionView reloadData];
        
        if(self.cartoons.count >= total){
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.collectionView.mj_footer endRefreshing];
        }
        self.pageSize += 10;
        [self changeDict:@"pageSize" addNum:10];

        [self changeDict:@"pageNum" addNum:1];
    }];
}

-(void)changeDict:(NSString *)key addNum:(NSInteger)addNum{
    NSString *value = [self.model.parameters objectForKey:key];
    NSString *pageSize1 = [NSString stringWithFormat:@"%ld",[value integerValue] + addNum];
    [self.model.parameters setValue:pageSize1 forKey:key];
}

-(void)loadNewData{
    
    [self loadNewArray:self.model.parameters url:self.model.url finished:^(id  _Nullable responseObject, NSError *error) {
        [self handleResponseObject:responseObject];
    }];
   
}

-(void)loadNewArray:(NSDictionary *)dict url:(NSString *)url finished:(void (^)(id  _Nullable responseObject,NSError * error))finished{
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];

    [manager POST:[ZZTAPI stringByAppendingString:url] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finished(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finished(nil,error);
    }];
}

-(void)handleResponseObject:(id)responseObject{
    NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
    
    NSMutableArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
    
    self.cartoons = array;
    
    [self.collectionView reloadData];
    
    [self.collectionView.mj_header endRefreshing];
}

-(void)setArray:(NSArray *)array{
    _array = array;
    [self.collectionView reloadData];
}

-(void)setViewTitle:(NSString *)viewTitle{
    _viewTitle = viewTitle;
}

-(void)setModel:(ZZTHomeTableViewModel *)model{
    _model = model;
    
    [self.viewNavBar.centerButton setTitle:model.title forState:UIControlStateNormal];
    
    //设置一个按钮 设置事件
    [self setupNavRightBtn:@"我参与的" Sel:@selector(gotoParticipation)];
}

-(UIButton *)setupNavRightBtn:(NSString *)title Sel:(SEL)sel{
    [self.viewNavBar.rightButton setTitle:title forState:UIControlStateNormal];
    [self.viewNavBar.rightButton setTitleColor:ZZTSubColor forState:UIControlStateNormal];
    [self.viewNavBar.rightButton sizeToFit];
    
    [self.viewNavBar.rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(50);
    }];
    
    self.viewNavBar.rightButton.hidden = ![_model.title isEqualToString:@"同人创作"];
    
    [self.viewNavBar.rightButton addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return self.viewNavBar.rightButton;
}

#pragma mark - NavRightBtnTarget
-(void)gotoParticipation{
    if([[UserInfoManager share] hasLogin] == NO){
        return;
    }
    //同人创作
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjects:@[@"1",@"10",SBAFHTTPSessionManager.sharedManager.userID] forKeys:@[@"pageNum",@"pageSize",@"userId"]];
    ZZTCartoonViewController *bookVC = [[ZZTCartoonViewController alloc] init];
    bookVC.hidesBottomBarWhenPushed = YES;
    bookVC.model = [ZZTHomeTableViewModel initHotVCModel:@"cartoon/getUserParticipateWriting" title:@"参与的作品" parameters:dict];
    [self.navigationController pushViewController:bookVC animated:YES];
}

#pragma mark - 创建流水布局
-(UICollectionViewFlowLayout *)setupCollectionViewFlowLayout{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //修改尺寸(控制)
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 36) / 3 , [Utilities getCarChapterH] + 24);
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //行距
    layout.minimumLineSpacing = 10;
    
    layout.minimumInteritemSpacing = 5;
    
    return layout;
}

#pragma mark - 创建CollectionView
-(void)setupCollectionView:(UICollectionViewFlowLayout *)layout
{
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, Height_NavBar, Screen_Width, Screen_Height - navHeight) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:self.collectionView];

    [collectionView registerClass:[ZZTCartoonCell class] forCellWithReuseIdentifier:@"cellId"];
}

//边距设置:整体边距的优先级，始终高于内部边距的优先级
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 8, 8, 8);//分别为上、左、下、右
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cartoons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZTCartoonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    ZZTCarttonDetailModel *car = self.cartoons[indexPath.row];
    cell.cartoon = car;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZZTCarttonDetailModel *md = self.cartoons[indexPath.row];
    ZZTWordDetailViewController *detailVC = [[ZZTWordDetailViewController alloc]init];
    detailVC.isId = YES;
    detailVC.cartoonDetail = md;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];

}
@end
