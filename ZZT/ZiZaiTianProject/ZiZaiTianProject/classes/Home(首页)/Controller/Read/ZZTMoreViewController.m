//
//  ZZTMoreViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/19.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTMoreViewController.h"
#import "ZZTWordCell.h"
#import "ZZTWordDetailViewController.h"
#import "ZZTMulWordDetailViewController.h"
#import "ZZTDetailModel.h"
#import "ZZTMallDetailViewController.h"



static const CGFloat MJDuration = 1.0;

@interface ZZTMoreViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,assign) NSInteger pageNumber;

@property (nonatomic,assign) NSInteger pageSize;

@end

NSString *WordCell = @"WordCell";

@implementation ZZTMoreViewController

-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNumber = 2;
    
    self.pageSize = 10;
    
    [self addBackBtn];
    
    [self.viewNavBar.centerButton setTitle:@"更多推荐" forState:UIControlStateNormal];

    //流水布局
    UICollectionViewFlowLayout *layout = [self setupCollectionViewFlowLayout];
    //创建UICollectionView：黑色
    [self setupCollectionView:layout];

//    [self loadMoreData];
    
    [self.view bringSubviewToFront:self.viewNavBar];

    [self setupMJRefresh];

    [self.collectionView.mj_header beginRefreshing];

//    [self setBackItemWithImage:@"blackBack" pressImage:nil];
}

#pragma mark - 创建流水布局
-(UICollectionViewFlowLayout *)setupCollectionViewFlowLayout{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //修改尺寸(控制)
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 36) / 3 , SCREEN_HEIGHT * 0.24 + 24);
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //行距
    layout.minimumLineSpacing = 0;
    
    layout.minimumInteritemSpacing = 5;
    
    return layout;
}

#pragma mark - 创建CollectionView
-(void)setupCollectionView:(UICollectionViewFlowLayout *)layout
{
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [collectionView registerNib:[UINib nibWithNibName:@"ZZTCartoonCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
}

-(void)setupMJRefresh{
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if(self.moreTag == 2){
            //素材
            [self loadMaterialData];
        }else{
            //默认是首页的更多
            [self loadNewData];
        }
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if(self.moreTag == 2){
            //素材
            [self loadMoreMaterialData];
        }else{
            [self loadMoreData];
        }
    }];
}

#pragma mark - 加载素材数据
-(void)loadMaterialData{
    NSDictionary *dic = @{
                          @"pageNum":@"1",
                          @"pageSize":[NSString stringWithFormat:@"%ld",self.pageSize],
                          @"more":@"2"
                          };
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    [manager POST:[ZZTAPI stringByAppendingString:@"zztMall/getFodderGoods"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        NSMutableArray *array = [ZZTDetailModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
        NSInteger total = [[dic objectForKey:@"total"] integerValue];

        self.dataArray = array;
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        [self.collectionView reloadData];
        
        if(self.dataArray.count >= total){
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.collectionView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.collectionView.mj_header endRefreshing];
        
    }];
}

-(void)loadMoreMaterialData{
    NSDictionary *dic = @{
                          @"pageNum":[NSString stringWithFormat:@"%ld",self.pageNumber],
                          @"pageSize":@"10",
                          @"more":@"2"
                          };
    
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    [manager POST:[ZZTAPI stringByAppendingString:@"zztMall/getFodderGoods"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        NSMutableArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
        NSInteger total = [[dic objectForKey:@"total"] integerValue];
        //        self.dataArray = array;
        [self.dataArray addObjectsFromArray:array];
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        [self.collectionView reloadData];
        
        if(self.dataArray.count >= total){
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.collectionView.mj_footer endRefreshing];
        }
        
        self.pageNumber++;
        
        self.pageSize += 10;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.mj_footer endRefreshing];
        
    }];
}

-(void)loadNewData{
    NSString *url = [self getCartoonUrl];
    NSDictionary *dic = @{
                          @"pageNum":@"1",
                          @"pageSize":[NSString stringWithFormat:@"%ld",self.pageSize],
                          @"more":@"2"
                          };
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    [manager POST:[ZZTAPI stringByAppendingString:url] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        NSMutableArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
        NSInteger total = [[dic objectForKey:@"total"] integerValue];

        self.dataArray = array;
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        [self.collectionView reloadData];
        
        if(self.dataArray.count >= total){
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.collectionView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.collectionView.mj_header endRefreshing];
        
    }];
}
#pragma mark - 获取首页卡通 和 商城卡通
-(NSString *)getCartoonUrl{
    NSString *url;
    if(self.moreTag == 1){
//        商城
        url = @"zztMall/getCartoonGoods";
    }else{
//        首页
        url = @"cartoon/getRecommendCartoon";
    }
    return url;
}

-(void)loadMoreData{
    NSString *url = [self getCartoonUrl];
    NSDictionary *dic = @{
                          @"pageNum":[NSString stringWithFormat:@"%ld",self.pageNumber],
                          @"pageSize":@"10",
                          @"more":@"2"
                          };
    
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    [manager POST:[ZZTAPI stringByAppendingString:url] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        NSMutableArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
        NSInteger total = [[dic objectForKey:@"total"] integerValue];
//        self.dataArray = array;
        [self.dataArray addObjectsFromArray:array];
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        [self.collectionView reloadData];
        
        if(self.dataArray.count >= total){
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.collectionView.mj_footer endRefreshing];
        }

        self.pageNumber++;
        
        self.pageSize += 10;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.mj_footer endRefreshing];
        
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.collectionView.mj_footer.hidden = (self.dataArray.count == 0);
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZTCartoonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    if(_moreTag == 2){
        ZZTDetailModel *car = self.dataArray[indexPath.row];
        cell.materialModel = car;
    }else{
        ZZTCarttonDetailModel *car = self.dataArray[indexPath.row];
        cell.cartoon = car;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_moreTag == 2){
        ZZTDetailModel *detailModel = self.dataArray[indexPath.row];
        ZZTMallDetailViewController *vc = [[ZZTMallDetailViewController alloc] init];
        vc.model = detailModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ZZTCarttonDetailModel *md = self.dataArray[indexPath.row];
        if([md.cartoonType isEqualToString:@"1"]){
            ZZTWordDetailViewController *detailVC = [[ZZTWordDetailViewController alloc]init];
            detailVC.isId = YES;
            detailVC.cartoonDetail = md;
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        }else{
            ZZTMulWordDetailViewController *detailVC = [[ZZTMulWordDetailViewController alloc]init];
            detailVC.isId = YES;
            detailVC.cartoonDetail = md;
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 8, 0, 8);//分别为上、左、下、右
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.collectionView.mj_header beginRefreshing];
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleDefault;

}

-(void)setMoreTag:(NSInteger)moreTag{
    _moreTag = moreTag;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleLightContent;
    
}
@end
