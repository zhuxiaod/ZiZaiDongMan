//
//  ZZTMeAttentionViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/28.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTMeAttentionViewController.h"
#import "ZZTAttentionCell.h"

@interface ZZTMeAttentionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
//cartoons
@property (nonatomic,strong) NSArray *cartoons;

@property (nonatomic,strong) NSArray *books;

@property (nonatomic,strong) UserInfo *user;

@end

@implementation ZZTMeAttentionViewController

-(UserInfo *)user{
    if(!_user){
        _user = [Utilities GetNSUserDefaults];
    }
    return _user;
}

- (NSArray *)cartoons{
    if (!_cartoons) {
        _cartoons = [NSArray array];
    }
    return _cartoons;
}

- (NSArray *)books{
    if (!_books) {
        _books = [NSArray array];
    }
    return _books;
}

static NSString *AttentionCell = @"AttentionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //流水布局
    UICollectionViewFlowLayout *layout = [self setupCollectionViewFlowLayout];
    
    //创建UICollectionView：黑色
    [self setupCollectionView:layout];
    
    //注册cell
    [self registerCell];
    
    self.navigationItem.title = @"关注";
    
//    UIButton *leftbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    
    //[leftbutton setBackgroundColor:[UIColor blackColor]];
    
//    [leftbutton setTitle:@"清空" forState:UIControlStateNormal];
    
//    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    
//    self.navigationItem.rightBarButtonItem = rightitem;
    [self setupMJRefresh];
    
    [self.collectionView.mj_header beginRefreshing];
    
    [self addBackBtn];
    
    [self.viewNavBar.centerButton setTitle:@"关注" forState:UIControlStateNormal];
    
}

-(void)setupMJRefresh{
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
}
#pragma mark 注册Cell(控制)
-(void)registerCell{
    UINib *nib1= [UINib nibWithNibName:@"ZZTAttentionCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib1 forCellWithReuseIdentifier:AttentionCell];
}

-(void)loadData{
    //请求参数
    NSDictionary *paramDict = @{
                                @"userId":[NSString stringWithFormat:@"%ld",self.user.id],
                                };
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"record/selUserAttention"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
        NSArray *array = [UserInfo mj_objectArrayWithKeyValuesArray:dic];
        self.cartoons = array;
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
    }];
}

#pragma mark - 创建流水布局
-(UICollectionViewFlowLayout *)setupCollectionViewFlowLayout{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //修改尺寸(控制)
    layout.itemSize = CGSizeMake(SCREEN_WIDTH,100);
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //行距
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 5;
    
    return layout;
}


#pragma mark - 创建CollectionView
-(void)setupCollectionView:(UICollectionViewFlowLayout *)layout
{
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, navHeight, Screen_Width, Screen_Height) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    [self.view addSubview:self.collectionView];
    collectionView.dataSource = self;
    collectionView.delegate = self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cartoons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZTAttentionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AttentionCell forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    cell.attentionCancelBlock = ^(ZZTAttentionCell *cell) {
        [weakSelf cancelAttention:cell];
    };
    ZZTUserModel *car = self.cartoons[indexPath.row];
    if (car) {
        cell.attemtion = car;
    }
    return cell;
}

-(void)cancelAttention:(ZZTAttentionCell *)cell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    UserInfo *user = self.cartoons[indexPath.row];
    NSDictionary *dic = @{
                          @"userId":[NSString stringWithFormat:@"%ld",self.user.id],
                          @"authorId":[NSString stringWithFormat:@"%ld",(long)user.id]
                          };
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"record/ifUserAtAuthor"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [self loadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//加载数据
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

@end
