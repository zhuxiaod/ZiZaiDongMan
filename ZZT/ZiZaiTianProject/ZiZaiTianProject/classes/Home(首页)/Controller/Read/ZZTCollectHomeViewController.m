//
//  ZZTCollectHomeViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/13.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTCollectHomeViewController.h"

@interface ZZTCollectHomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,weak) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,weak) ZZTRemindView *remindView;

@property (nonatomic,strong) NSArray *bookIdArray;

@property (nonatomic,weak) UIButton *deleteBtn;

@end

@implementation ZZTCollectHomeViewController

-(NSArray *)bookIdArray{
    if(!_bookIdArray){
        _bookIdArray = [NSMutableArray array];
    }
    return _bookIdArray;
}

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
    
    //读取数据
//    [self loadBookShelfData];
    
    //显示删除
    [self setupDeleteBtn];
    
    [self hiddenViewNavBar];
}

-(void)setupDeleteBtn{
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.hidden = YES;
    _deleteBtn = deleteBtn;
    [deleteBtn setImage:[UIImage imageNamed:@"Home_removeBook"] forState:UIControlStateNormal];
    deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -33);
    [deleteBtn addTarget:self action:@selector(showRemindView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteBtn];
    
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(22);
        make.right.equalTo(self.view.mas_right).offset(-2);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(40);
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
    
     [collectionView registerClass:[ZZTCartoonCell class] forCellWithReuseIdentifier:@"cellId"];
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

//加载数据
-(void)loadBookShelfData{
    UserInfo *user = [Utilities GetNSUserDefaults];
    NSDictionary *dic = @{
                          @"userId":[NSString stringWithFormat:@"%ld",user.id]
                          };
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    EncryptionTools *tool = [[EncryptionTools alloc]init];
    [manager POST:[ZZTAPI stringByAppendingString:@"great/userCollect"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [tool decry:responseObject[@"result"]];
        NSMutableArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic];
        self.dataArray = array;
        [self addCartoonId:array];
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}

//-(void)showDeleteBtn{
//    self.deleteBtn.hidden = NO;
//    [self.deleteBtn addTarget:self action:@selector(showRemindView) forControlEvents:UIControlEventTouchUpInside];
//}
//
//-(void)hiddenDeleteBtn{
//    self.deleteBtn.hidden = YES;
//}

-(void)showRemindView{
    if([[UserInfoManager share] hasLogin] == NO){
        return;
    }
    ZZTRemindView *remindView = [ZZTRemindView sharedInstance];
    self.remindView = remindView;
    remindView.viewTitle = @"是否清空?";
    remindView.tureBlock = ^(UIButton *btn) {
        NSString *string = [self.bookIdArray componentsJoinedByString:@","];
        if(self.bookIdArray.count){
            [self loadRemoveBook:string];
        }
    };
    
    [remindView show];
//    [self.view addSubview:remindView];
}

-(void)addCartoonId:(NSMutableArray *)array{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        NSMutableArray *cartoonArray = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            ZZTCarttonDetailModel *model = array[i];
            [cartoonArray addObject:model.cartoonId];
        }
        self.bookIdArray = cartoonArray;
    });
}

-(void)loadRemoveBook:(NSString *)string{
  
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];

    UserInfo *user = [Utilities GetNSUserDefaults];
    NSDictionary *dic = @{
                          @"userId":[NSString stringWithFormat:@"%ld",user.id],
                          @"cartoonId":string
                          };
    [manager POST:[ZZTAPI stringByAppendingString:@"great/delCollect"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self loadBookShelfData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)loadData{
    if([[UserInfoManager share] hasLogin] == YES){
        [self loadBookShelfData];
    }else{
        [UserInfoManager needLogin];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadBookShelfData];
}

//边距设置:整体边距的优先级，始终高于内部边距的优先级
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 8, 8, 8);//分别为上、左、下、右
}

@end
