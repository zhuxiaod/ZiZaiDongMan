//
//  ZZTMallDetailViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/2/21.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import "ZZTMallDetailViewController.h"
#import "ZZTChapterPayViewController.h"
#import "ZZTPayTureView.h"
#import "ZZTDetailModel.h"
#import "ZZTMeWalletViewController.h"

@interface ZZTMallDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,weak)ZZTChapterPayViewController *chapterPayVC;

@property (nonatomic,weak)UIView *payView;

@property (nonatomic,weak)UIView *goodsView;

@property (nonatomic,weak) UICollectionView *collectionView;

@property (nonatomic,strong) NSArray *materialArray;

@property (nonatomic,weak) ZZTPayTureView *payTureView;

@end

@implementation ZZTMallDetailViewController

-(NSArray *)materialArray{
    if(_materialArray == nil){
        _materialArray = [NSArray array];
    }
    return _materialArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //navBar
    [self setupNavBar];
    
    //设置内容布局
    [self setupContentView];
    
    //设置支付页面
    [self setupPayTureView];
    
    //设置素材内容
    [self setupMaterialView];
    
    //加载数据
    [self loadMaterialData];
}

#pragma mark - 设置PayTureView
-(void)setupPayTureView{
    ZZTPayTureView *payTureView = [ZZTPayTureView payTureView];
    payTureView.frame = CGRectMake(0, 0, _payView.width, _payView.height);
    _payTureView = payTureView;
    payTureView.zbNum = [NSString stringWithFormat:@"%ld",[Utilities GetNSUserDefaults].zzbNum];
    [_payView addSubview:payTureView];
    
    //确认支付
    payTureView.payTureBlock = ^(NSString *zbNum) {
        if([Utilities GetNSUserDefaults].zzbNum > [zbNum integerValue]){
            [self sendPayQuestWithZbNum:zbNum];
        }else{
            [MBProgressHUD showSuccess:@"请充值后再购买"];
        }
    };
    
    //进入充值
    payTureView.GotoTopupViewBlock = ^{
        ZZTMeWalletViewController *walletVC = [[ZZTMeWalletViewController alloc] init];
        walletVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:walletVC animated:YES];
    };
}

#pragma mark - 确认支付
-(void)sendPayQuestWithZbNum:(NSString *)zbNum{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dict = @{
                           @"userId":[NSString stringWithFormat:@"%ld",[Utilities GetNSUserDefaults].id],
                           @"fodderId":[NSString stringWithFormat:@"%ld",self.model.id],//素材的id
                           @"zbNum":zbNum//Zb价格
                           };
    [manager POST:[ZZTAPI stringByAppendingString:@"zztMall/userBuyFodder"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD showSuccess:@"购买成功!"];
        UserInfoManager *user = [UserInfoManager share];
        
        [user loadUserInfoDataSuccess:^{
            self.payTureView.zbNum = [NSString stringWithFormat:@"%ld", (long)[Utilities GetNSUserDefaults].zzbNum];
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - navBar
-(void)setupNavBar{
    [self setMeNavBarStyle];
    
    [self.viewNavBar.centerButton setTitle:@"素材名称" forState:UIControlStateNormal];
}

#pragma mark - 设置内容布局
-(void)setupContentView{
    UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height - 300, SCREEN_WIDTH, 300)];
    _payView = payView;
    NSLog(@"payView:%f",payView.height);
    payView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:payView];
    
    UIView *goodsView = [[UIView alloc] initWithFrame:CGRectMake(0, navHeight, SCREEN_WIDTH, Screen_Height - navHeight - 300)];
    _goodsView = goodsView;
    goodsView.backgroundColor = [UIColor redColor];
    [self.view addSubview:goodsView];
}

#pragma mark - 设置内容布局
-(void)setupMaterialView{
    //设置collectionView
    UICollectionViewFlowLayout *layout = [self setupCollectionViewFlowLayout];
    
    [self setupCollectionView:layout];
}

#pragma mark - 加载素材数据
-(void)loadMaterialData{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    NSDictionary *dict = @{
                           @"fodderId":[NSString stringWithFormat:@"%ld",self.model.id]
                           };
    [manager POST:[ZZTAPI stringByAppendingString:@"zztMall/getFodderGoodsSuite"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        NSArray *array = [ZZTDetailModel mj_objectArrayWithKeyValuesArray:dic];
        if(array.count > 0){
            ZZTDetailModel *model = [array objectAtIndex:0];
            self.payTureView.originalPrice = model.money;
        }
        self.materialArray = array;
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
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
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.frame = _goodsView.frame;
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];

    [self.collectionView registerClass:[ZZTCartoonCell class] forCellWithReuseIdentifier:cartoonCellId];
}

//节
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//行
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.materialArray.count;
}

//cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZTDetailModel *model = self.materialArray[indexPath.row];
    
    ZZTCartoonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cartoonCellId forIndexPath:indexPath];
    cell.materialModel = model;
    return cell;
}

//行距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0f;
}

//边距设置:整体边距的优先级，始终高于内部边距的优先级
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 8, 8, 8);//分别为上、左、下、右
}

#pragma mark - 设置model
-(void)setModel:(ZZTDetailModel *)model{
    _model = model;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleLightContent;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleDefault;

}
@end
