//
//  ZZTCartoonViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/6/29.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTCartoonViewController.h"
#import "ZZTCartoonCell.h"
#import "ZZTAttentionCell.h"
#import "ZZTMyCircleCellCollectionViewCell.h"

//请求192.168.0.165:8888/great/daiti?id=daiti
@interface ZZTCartoonViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) EncryptionTools *encryptionManager;
//获得数据
@property (nonatomic,strong) NSString *getData;
//cartoons
@property (nonatomic,strong) NSArray *cartoons;

@property (nonatomic,strong) NSArray *books;

@property (nonatomic,strong) UserInfo *user;

@property (nonatomic,strong) ZZTRemindView *remindView;

@property (nonatomic,strong) NSMutableArray *cartoonArray;
@end


@implementation ZZTCartoonViewController

#pragma mark - 懒加载

-(NSMutableArray *)cartoonArray{
    if(!_cartoonArray){
        _cartoonArray = [NSMutableArray array];
    }
    return _cartoonArray;
}

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

-(AFHTTPSessionManager *)manager{
    if(!_manager){
//        _manager = [AFHTTPSessionManager manager];
        _manager = [[AFHTTPSessionManager alloc] init];

    }
    return _manager;
}
//cell注册(控制)
static NSString *collectionID = @"collectionID";
static NSString *AttentionCell = @"AttentionCell";
static NSString *circleCell = @"circleCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //流水布局
    UICollectionViewFlowLayout *layout = [self setupCollectionViewFlowLayout];

    //创建UICollectionView：黑色
    [self setupCollectionView:layout];

    //注册cell
    [self registerCell];
    
    self.navigationItem.title = self.viewTitle;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"清空" target:self action:@selector(removeAllBook) titleColor:[UIColor whiteColor]];
    
//    [self addBackBtn];
    
    [self.viewNavBar.centerButton setTitle:@"书柜" forState:UIControlStateNormal];

    [self.viewNavBar.rightButton setTitle:@"清空" forState:UIControlStateNormal];
    [self.viewNavBar.rightButton addTarget:self action:@selector(removeAllBook) forControlEvents:UIControlEventTouchUpInside];
    
    [self setMeNavBarStyle];

}

-(void)removeAllBook{
    ZZTRemindView *remindView = [ZZTRemindView sharedInstance];
    remindView.viewTitle = @"是否清空?";
    self.remindView = remindView;
    remindView.tureBlock = ^(UIButton *btn) {
        NSString *string = [self.cartoonArray componentsJoinedByString:@","];
        if(self.cartoonArray.count){
            [self loadRemoveBook:string];
        }
    };
    [remindView show];
}

//边距设置:整体边距的优先级，始终高于内部边距的优先级
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 8, 8, 8);//分别为上、左、下、右
}

-(void)loadRemoveBook:(NSString *)string{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    UserInfo *user = [Utilities GetNSUserDefaults];
    NSDictionary *dic = @{
                          @"userId":[NSString stringWithFormat:@"%ld",user.id],
                          @"cartoonId":string
                          };
    [manager POST:[ZZTAPI stringByAppendingString:@"great/delCollect"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self loadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark 注册Cell(控制)
-(void)registerCell{
    UINib *nib1= [UINib nibWithNibName:@"ZZTCartoonCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib1 forCellWithReuseIdentifier:collectionID];
}

-(void)loadData{
    if([self.viewType isEqualToString:@"1"]){
        //请求参数
        NSDictionary *paramDict = @{
                                    @"userId":[NSString stringWithFormat:@"%ld",self.user.id],
                                    };
        [self.manager POST:[ZZTAPI stringByAppendingString:@"great/userCollect"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
            NSMutableArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic];
            self.cartoons = array;
            [self addCartoonId:array];
            [self.collectionView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败 -- %@",error);
        }];
    }else{
        //请求参数
        NSDictionary *paramDict = @{
                                    @"userId":[NSString stringWithFormat:@"%ld",self.user.id]
                                    };
        
        [self.manager POST:[ZZTAPI stringByAppendingString:@"great/userCollect"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
            NSMutableArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic];
            self.cartoons = array;
            [self addCartoonId:array];
            [self.collectionView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败 -- %@",error);
        }];
    }
}

-(void)addCartoonId:(NSMutableArray *)array{
    NSMutableArray *cartoonArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        ZZTCarttonDetailModel *model = array[i];
        [cartoonArray addObject:model.cartoonId];
    }
    self.cartoonArray = cartoonArray;
}

#pragma mark - 创建流水布局
-(UICollectionViewFlowLayout *)setupCollectionViewFlowLayout{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //修改尺寸(控制)
    layout.itemSize = CGSizeMake(SCREEN_WIDTH/3 - 10,200);
    
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
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
    ZZTCartoonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionID forIndexPath:indexPath];
    ZZTCarttonDetailModel *car = self.cartoons[indexPath.row];
    if (car) {
        cell.cartoon = car;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZZTCarttonDetailModel *md = self.cartoons[indexPath.row];
    if([md.cartoonType isEqualToString:@"1"]){
        ZZTWordDetailViewController *detailVC = [[ZZTWordDetailViewController alloc]init];
        detailVC.isId = NO;
        detailVC.cartoonDetail = md;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        ZZTMulWordDetailViewController *detailVC = [[ZZTMulWordDetailViewController alloc]init];
        detailVC.isId = NO;
        detailVC.cartoonDetail = md;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

//加载数据
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}
@end
