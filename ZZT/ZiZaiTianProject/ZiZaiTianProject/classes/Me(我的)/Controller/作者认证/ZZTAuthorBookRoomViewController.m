//
//  ZZTAuthorBookRoomViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/14.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTAuthorBookRoomViewController.h"
#import "ZZTCartReleaseViewController.h"

@interface ZZTAuthorBookRoomViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UIScrollView *mainView;

@property (nonatomic,strong) ZZTNavBarTitleView *titleView;

@property (nonatomic,strong) UIButton *mommentBtn;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) NSInteger pageNumber;

@property (nonatomic,assign) NSInteger pageSize;

@end

@implementation ZZTAuthorBookRoomViewController

-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

//书库
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNumber = 1;
    
    self.pageSize = 10;
    
    self.view.backgroundColor = [UIColor redColor];
    
    UICollectionViewFlowLayout *layout = [self setupCollectionViewFlowLayout];
    
    //创建UICollectionView：黑色
    [self setupCollectionView:layout];
    
    //读取数据
//    [self loadNewData];
    
    [self setupMJRefresh];
}

-(void)setupMJRefresh{
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadData];
    }];
}

-(void)loadNewData{
    NSDictionary *dict = @{
                           @"userId":[NSString stringWithFormat:@"%ld",[Utilities GetNSUserDefaults].id],
                           @"ifrelease":@"1",
                           @"pageNum":@"1",
                           @"pageSize":[NSString stringWithFormat:@"%ld",self.pageSize]
                           };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/json",@"text/plain",@"text/JavaScript",@"application/json",@"image/jpeg",@"image/png",@"application/octet-stream",nil];
    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置超时时间

//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //更改响应默认的解析方式为字符串解析
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    

    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/getAuthorCartoon"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject1111%@",responseObject);
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        
        NSMutableArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
        
        self.dataArray = array;
        
        [self.collectionView.mj_header endRefreshing];
        
        NSInteger total = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"total"]] integerValue];

        if(self.dataArray.count >= total){
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];

    }];

}

-(void)loadData{
    [self.collectionView.mj_footer resetNoMoreData];

    NSDictionary *dict = @{
                           @"userId":[NSString stringWithFormat:@"%ld",[Utilities GetNSUserDefaults].id],
                           @"ifrelease":@"1",
                           @"pageNum":[NSString stringWithFormat:@"%ld",self.pageNumber],
                           @"pageSize":@"10"
                           };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/getAuthorCartoon"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        
        NSMutableArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
        
        [self.dataArray addObjectsFromArray:array];
        
        NSInteger total = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"total"]] integerValue];
        
        if(self.dataArray.count >= total){
            
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            
        }else{
            
            [self.collectionView.mj_footer endRefreshing];
        }
        
        [self.collectionView reloadData];
        
        self.pageNumber++;
        
        self.pageSize += 10;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.mj_footer endRefreshing];
    }];
}

#pragma mark - 创建流水布局
-(UICollectionViewFlowLayout *)setupCollectionViewFlowLayout{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //修改尺寸(控制)
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 36) / 3,[Utilities getCarChapterH] + 24);
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //行距
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 5;
    
    return layout;
}

#pragma mark - 创建CollectionView
-(void)setupCollectionView:(UICollectionViewFlowLayout *)layout
{
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, Height_NavBar, Screen_Width, Screen_Height) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [collectionView registerNib:[UINib nibWithNibName:@"ZZTCartoonCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZZTCarttonDetailModel *car = self.dataArray[indexPath.row];

    //点击跳转漫画发布页
    ZZTCartReleaseViewController *cartReleaseVC = [[ZZTCartReleaseViewController alloc] init];
    cartReleaseVC.model = car;
    cartReleaseVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cartReleaseVC animated:YES];
}

//边距设置:整体边距的优先级，始终高于内部边距的优先级
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 8, 8, 8);//分别为上、左、下、右
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.collectionView.mj_header beginRefreshing];
}

@end
