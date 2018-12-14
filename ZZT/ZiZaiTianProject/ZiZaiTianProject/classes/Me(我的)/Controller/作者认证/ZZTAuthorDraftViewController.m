//
//  ZZTAuthorDraftViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/14.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTAuthorDraftViewController.h"
#import "ZZTAuthorDraftCell.h"
#import "ZZTCartReleaseViewController.h"

@interface ZZTAuthorDraftViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UICollectionView *collectionView;


@end

@implementation ZZTAuthorDraftViewController

-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    UICollectionViewFlowLayout *layout = [self setupCollectionViewFlowLayout];
    
    //创建UICollectionView：黑色
    [self setupCollectionView:layout];
    
    [self loadBookShelfData];
}

//加载数据
-(void)loadBookShelfData{
    UserInfo *user = [Utilities GetNSUserDefaults];
    NSDictionary *dic = @{
                          @"userId":[NSString stringWithFormat:@"%ld",user.id]
                          };
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    EncryptionTools *tool = [[EncryptionTools alloc]init];
    [manager POST:[ZZTAPI stringByAppendingString:@"great/userCollect"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [tool decry:responseObject[@"result"]];
        NSMutableArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic];
        self.dataArray = array;
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
#pragma mark - 创建流水布局
-(UICollectionViewFlowLayout *)setupCollectionViewFlowLayout{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //修改尺寸(控制)
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 36) / 3,[Utilities getCarChapterH] + 84);
    
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
    
    
    [collectionView registerClass:[ZZTAuthorDraftCell class] forCellWithReuseIdentifier:@"authorDraftCell"];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZTAuthorDraftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"authorDraftCell" forIndexPath:indexPath];
    ZZTCarttonDetailModel *car = self.dataArray[indexPath.row];
    cell.cartoon = car;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //点击跳转漫画发布页
    ZZTCartReleaseViewController *cartReleaseVC = [[ZZTCartReleaseViewController alloc] init];
    [self.navigationController pushViewController:cartReleaseVC animated:YES];
}

//边距设置:整体边距的优先级，始终高于内部边距的优先级
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 8, 8, 8);//分别为上、左、下、右
}

@end
