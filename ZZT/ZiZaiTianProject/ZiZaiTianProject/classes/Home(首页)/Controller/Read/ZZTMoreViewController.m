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

static const CGFloat MJDuration = 1.0;

@interface ZZTMoreViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong)NSString *pageNumber;

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
    self.pageNumber = @"0";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"更多推荐";
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    //流水布局
    UICollectionViewFlowLayout *layout = [self setupCollectionViewFlowLayout];
    //创建UICollectionView：黑色
    [self setupCollectionView:layout];
    
    [self loadMoreData];
    
    [self setupMJRefresh];
    
    NSString *pageNumber = [NSString stringWithFormat:@"0"];
    [self.collectionView.mj_header beginRefreshing];

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
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [collectionView registerNib:[UINib nibWithNibName:@"ZZTCartoonCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
}

-(void)setupMJRefresh{
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
       
        [self loadMoreData];
    }];
}
-(void)loadMoreData{
    NSDictionary *dic = @{
                          @"pageNum":self.pageNumber,
                          @"pageSize":@"10"
                          };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/getRecommendCartoon"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
        NSMutableArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic];
        self.dataArray = array;
//        [self.dataArray addObjectsFromArray:array];
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        [self.collectionView reloadData];
        // 结束刷新
        [self.collectionView.mj_footer endRefreshing];

        [self.collectionView.mj_header endRefreshing];

        self.pageNumber = [NSString stringWithFormat:@"%ld",([self.pageNumber integerValue] + 10)];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZTCartoonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    ZZTCarttonDetailModel *car = self.dataArray[indexPath.row];
    cell.cartoon = car;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
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
@end
