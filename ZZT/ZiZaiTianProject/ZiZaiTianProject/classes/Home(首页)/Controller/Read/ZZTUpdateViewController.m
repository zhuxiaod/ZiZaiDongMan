//
//  ZZTUpdateViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/19.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTUpdateViewController.h"
#import "ZZTUpdatePageViewController.h"

@interface ZZTUpdateViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableArray *cartoons;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *idArray;

@end

@implementation ZZTUpdateViewController

-(NSMutableArray *)idArray{
    if(!_idArray){
        _idArray = [NSMutableArray array];
    }
    return _idArray;
}

- (NSArray *)cartoons{
    if (!_cartoons) {
        _cartoons = [NSMutableArray array];
    }
    return _cartoons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTitle];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //流水布局
    UICollectionViewFlowLayout *layout = [self setupCollectionViewFlowLayout];
    
    //创建UICollectionView：黑色
    [self setupCollectionView:layout];
    
   
    
//    [self setBackItemWithImage:@"blackBack" pressImage:nil];

    
    [self.view bringSubviewToFront:self.viewNavBar];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //请求书柜
    [self loadBookShelf];
}

-(void)loadBookShelf{
    
    NSDictionary *dic = @{
                          @"userId":[UserInfoManager share].ID
                          };

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"record/selBrowsehistory"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        NSMutableArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic];
        //        NSMutableArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic];
        self.cartoons = array;
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)removeAllBooks{
    [self.idArray removeAllObjects];
    for (int i = 0; i < self.cartoons.count; i++) {
        ZZTCarttonDetailModel *book = self.cartoons[i];
        //历史id
        [self.idArray addObject:book.id];
    }
    NSString *text = [self.idArray componentsJoinedByString:@","];
    UserInfo *user = [Utilities GetNSUserDefaults];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dic = @{
                          @"userId":[NSString stringWithFormat:@"%ld",user.id],
                          @"id":text
                          };
    [manager POST:[ZZTAPI stringByAppendingString:@"record/delBrowsehistory"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.cartoons removeAllObjects];
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

#pragma mark - 创建流水布局
-(UICollectionViewFlowLayout *)setupCollectionViewFlowLayout{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //修改尺寸(控制)
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 36) / 3 , [Utilities getCarChapterH] + 24);
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //行距
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 5;
    
    return layout;
}

#pragma mark - 创建CollectionView
-(void)setupCollectionView:(UICollectionViewFlowLayout *)layout
{
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, Height_NavBar , Screen_Width, Screen_Height - 88) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [collectionView registerNib:[UINib nibWithNibName:@"ZZTCartoonCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZZTCarttonDetailModel *md = self.cartoons[indexPath.row];//type 2 漫画 剧本
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
//边距设置:整体边距的优先级，始终高于内部边距的优先级
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 8, 0, 8);//分别为上、左、下、右
}

-(void)setupTitle{
    [self.viewNavBar.centerButton setTitle:@"历史" forState:UIControlStateNormal];
    
    [self.viewNavBar.rightButton setTitle:@"清空" forState:UIControlStateNormal];
    
    [self.viewNavBar.rightButton addTarget:self action:@selector(removeAllBooks) forControlEvents:UIControlEventTouchUpInside];
    
    [self addBackBtn];
}


@end
