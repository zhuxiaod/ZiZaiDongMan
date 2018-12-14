//
//  ZZTAuthorBookRoomViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/14.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTAuthorBookRoomViewController.h"

@interface ZZTAuthorBookRoomViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UIScrollView *mainView;

@property (nonatomic,strong) ZZTNavBarTitleView *titleView;

@property (nonatomic,strong) UIButton *mommentBtn;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *dataArray;

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
    self.view.backgroundColor = [UIColor redColor];
    
    UICollectionViewFlowLayout *layout = [self setupCollectionViewFlowLayout];
    
    //创建UICollectionView：黑色
    [self setupCollectionView:layout];
    
    //读取数据
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
    ZZTCarttonDetailModel *md = self.dataArray[indexPath.row];
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
    return UIEdgeInsetsMake(0, 8, 8, 8);//分别为上、左、下、右
}


@end
