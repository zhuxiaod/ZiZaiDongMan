//
//  ZZTChapterPayViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/30.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTChapterPayViewController.h"
#import "ZZTChapterChooseCell.h"
#import "ZZTMeWalletViewController.h"
#import "ZZTChapterlistModel.h"
#import "ZZTChapterVipModel.h"
#import "ZZTChapterVipItemModel.h"
#import "ZZTCartoonDetailViewController.h"

@interface ZZTChapterPayViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *buyOptionView;

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *dataArray;

@property (nonatomic,strong) NSMutableArray *itemStyleArray;

@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (weak, nonatomic) IBOutlet UILabel *ZbLab;

@property (weak, nonatomic) IBOutlet UIView *moneyView;
@property (weak, nonatomic) IBOutlet UILabel *VIPTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (nonatomic,strong) ZZTChapterVipModel *vipModel;//购买话模型

@property (nonatomic,strong) ZZTChapterVipItemModel *nowBuyChapterModel;//当前要购买的章节模型

@end

@implementation ZZTChapterPayViewController
//点击样式
-(NSMutableArray *)itemStyleArray{
    if(!_itemStyleArray){
        if(self.dataArray.count > 0){
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 0; i < self.dataArray.count; i++) {
                NSNumber *isChange = @0;//不改变
                [array addObject:isChange];
            }
            NSNumber *change = @1;//改变
            [array replaceObjectAtIndex:0 withObject:change];
            _itemStyleArray = array;
        }
    }
    return _itemStyleArray;
}

-(NSArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.moneyView.layer.cornerRadius = 2;
    self.moneyView.layer.borderWidth = 1.0f;
    self.moneyView.layer.borderColor = ZZTSubColor.CGColor;
    self.moneyView.layer.masksToBounds = YES;
    
    //赋值ZB
    self.ZbLab.text = [NSString stringWithFormat:@"%ld", (long)[Utilities GetNSUserDefaults].zzbNum];
//    NSLog(@"%@",);
    
    //确认支付Btn
    self.payBtn.layer.cornerRadius = 32;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];
    }];

    
    UICollectionViewFlowLayout *layout = [self setupCollectionViewFlowLayout];
    [self setupCollectionView:layout];
    
//    self.dataArray = [NSArray arrayWithObjects:@"购买话",@"后10话",@"后30话",@"剩余30话", nil];
    
    //章节数据
    [self loadChapterVipData];
}

-(void)loadChapterVipData{
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    NSDictionary *dic = @{
                          @"userId":[NSString stringWithFormat:@"%ld",[Utilities GetNSUserDefaults].id],
                              @"chapterId":self.model.chapterId,//章节ID
                              @"cartoonId":self.model.cartoonId//书ID
                          };
    
    [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/cartoonChapterVip"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        ZZTChapterVipModel *vipModel = [ZZTChapterVipModel mj_objectWithKeyValues:dic];
        self.vipModel = vipModel;
        self.dataArray = [self setupChapterVipData:vipModel];;
        [self.collectionView reloadData];
        NSLog(@"%@",dic);
        self.totalPrice.text = [NSString stringWithFormat:@"应付%ldZ币",self.model.chapterMoney];
        self.VIPTotalPrice.text = [NSString stringWithFormat:@"%ldZ币",(NSInteger)(self.model.chapterMoney * [vipModel.vip floatValue])];

        [self updateBtnState];
        
        ZZTChapterVipItemModel *buyChapterNumModel = self.dataArray[0];
        self.nowBuyChapterModel = buyChapterNumModel;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 设置章节VIP数据
-(NSArray *)setupChapterVipData:(ZZTChapterVipModel *)vipModel{
    NSArray *dataArray = [NSArray array];
    if(vipModel.num <= 10){
        if(vipModel.num == 1){
            dataArray = @[[ZZTChapterVipItemModel initWithItemStr:@"购买话" discount:@"1" buyChapterNum:1]];
        }else{
            dataArray = @[[ZZTChapterVipItemModel initWithItemStr:@"购买话" discount:@"1" buyChapterNum:1],[ZZTChapterVipItemModel initWithItemStr:[NSString stringWithFormat:@"剩余%ld话",vipModel.num] discount:vipModel.discountOne buyChapterNum:vipModel.num]];
        }
    }else if (vipModel.num >10 && vipModel.num <= 30){
        dataArray = @[[ZZTChapterVipItemModel initWithItemStr:@"购买话" discount:@"1" buyChapterNum:1],[ZZTChapterVipItemModel initWithItemStr:@"后10话" discount:vipModel.discountOne buyChapterNum:10],[ZZTChapterVipItemModel initWithItemStr:[NSString stringWithFormat:@"剩余%ld话",vipModel.num] discount:vipModel.discountTwo buyChapterNum:vipModel.num]];
    }else{
        dataArray = @[[ZZTChapterVipItemModel initWithItemStr:@"购买话" discount:@"1" buyChapterNum:1],[ZZTChapterVipItemModel initWithItemStr:@"后10话" discount:vipModel.discountOne buyChapterNum:10],[ZZTChapterVipItemModel initWithItemStr:@"后30话" discount:vipModel.discountTwo buyChapterNum:30],[ZZTChapterVipItemModel initWithItemStr:[NSString stringWithFormat:@"剩余%ld话",vipModel.num] discount:vipModel.discountThree buyChapterNum:vipModel.num]];
    }
    return dataArray;
}

-(void)updateBtnState{
    if([[UserInfoManager share] hasLogin] == YES){
        //1是普通  2是会员
        if([[Utilities GetNSUserDefaults].userType isEqualToString:@"1"]){
            //用普通的价格比较
            if(self.model.chapterMoney > [Utilities GetNSUserDefaults].zzbNum){
                [self.payBtn setTitle:@"余额不足" forState:UIControlStateNormal];
            }
        }else{
            if((NSInteger)(self.model.chapterMoney * [self.vipModel.vip floatValue]) > [Utilities GetNSUserDefaults].zzbNum){
                [self.payBtn setTitle:@"余额不足" forState:UIControlStateNormal];
            }
        }
        
    }
}

#pragma mark - 创建流水布局
-(UICollectionViewFlowLayout *)setupCollectionViewFlowLayout{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    [self.view layoutIfNeeded];
    
    //修改尺寸(控制)
//    layout.itemSize = CGSizeMake(SCREEN_WIDTH/4 - 15,_collectionView.height/2 - 5);
    
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
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [_buyOptionView addSubview:collectionView];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.buyOptionView.mas_right);
        make.left.equalTo(self.buyOptionView.mas_left);

        make.centerY.equalTo(self.buyOptionView.mas_centerY);
        make.height.mas_equalTo(30);
    }];
    
    [collectionView registerClass:[ZZTChapterChooseCell class] forCellWithReuseIdentifier:@"ChapterChooseCell"];
}

//设置分组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
    
}
//设置每个分组个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

//只有新的cell出现的时候才会调用
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZZTChapterChooseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChapterChooseCell" forIndexPath:indexPath];
    ZZTChapterVipItemModel *vipModel = self.dataArray[indexPath.row];
    cell.vipModel = vipModel;
    NSNumber *isChange = self.itemStyleArray[indexPath.row];
    cell.isChangeStyle = isChange;
    return cell;
}

//点击选中
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //设置选中的状态
    for (int i = 0; i < self.itemStyleArray.count; i++) {
        if(i == indexPath.row){
            //代表是我选中的
            [self.itemStyleArray replaceObjectAtIndex:i withObject:@1];
        }else{
            [self.itemStyleArray replaceObjectAtIndex:i withObject:@0];
        }
    }
    [self.collectionView reloadData];
    
    //点击发生什么
    ZZTChapterVipItemModel *vipModel = self.dataArray[indexPath.row];
    self.nowBuyChapterModel = vipModel;
    //数量 * 价格 * 折扣
    
    //VIP价格是原价的0.85
    //数量 * 单价 * 折扣
    CGFloat originalPriceF = vipModel.buyChapterNum * self.model.chapterMoney * [vipModel.discount floatValue];
    self.totalPrice.text = [NSString stringWithFormat:@"应付%ldZ币",(NSInteger)originalPriceF];

    //VIP
    CGFloat vipP = (NSInteger)originalPriceF * [self.vipModel.vip floatValue];
    NSString *totalPricesStr = [NSString stringWithFormat:@"%lf",vipP];
    NSInteger totalPrices = [totalPricesStr integerValue];
    self.VIPTotalPrice.text = [NSString stringWithFormat:@"%ldZ币",totalPrices];

     [self updateBtnState];

}

//cell 大小
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [self layoutIfNeeded];
    return CGSizeMake(SCREEN_WIDTH / 4 - 20 , 30);
}

#pragma mark 定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 8, 0, 8);//（上、左、下、右 ）
}


- (IBAction)back:(UIButton *)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
        if (self.delegate && [self.delegate respondsToSelector:@selector(chapterPayViewDismissLastViewController)])
        {
            // 调用代理方法
            [self.delegate chapterPayViewDismissLastViewController];
        }
    }];

//    self.view.backgroundColor = [UIColor clearColor];
//    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.1];
}

- (IBAction)pushTopUpView:(UIButton *)sender {
    //钱包
    ZZTMeWalletViewController *walletVC = [[ZZTMeWalletViewController alloc] init];
    [self.navigationController pushViewController:walletVC animated:YES];
}

-(void)setModel:(ZZTChapterlistModel *)model{
    _model = model;
   

}
- (IBAction)payBtnTarget:(UIButton *)sender {
    if([sender.titleLabel.text isEqualToString:@"去登录"]){
         //跳登录页
            [UserInfoManager needLogin];
            [self dismissViewControllerAnimated:NO completion:nil];
            return;
    }else if ([sender.titleLabel.text isEqualToString:@"余额不足"]){
        [self pushTopUpView:nil];
    }else{
        //确定购买代码
        AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
        //1.普通 2.VIP
        NSInteger zbNum;
        if([[Utilities GetNSUserDefaults].userType isEqualToString:@"1"]){
            zbNum = self.model.chapterMoney;
        }else{
            zbNum = (NSInteger)(self.model.chapterMoney * [self.vipModel.vip floatValue]);
        }

        NSDictionary *dic = @{
                              @"userId":[NSString stringWithFormat:@"%ld",[Utilities GetNSUserDefaults].id],
                              @"chapterId":self.model.chapterId,//章节ID
                              @"cartoonId":self.model.cartoonId,//书ID
                              @"chapterNum":[NSString stringWithFormat:@"%ld",self.nowBuyChapterModel.buyChapterNum],//购买数量
                              @"zbNum":[NSString stringWithFormat:@"%ld",zbNum]//购买价格
                              };
        [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/userBuyChapter"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD showSuccess:@"购买成功"];
            [[UserInfoManager share] loadUserInfoDataSuccess:nil];
            //更新上一页的数据
            self.model.ifbuy = @"1";
            ZZTCartoonDetailViewController *carDetailVC = [[ZZTCartoonDetailViewController alloc] init];
            carDetailVC.chapterData = self.model;
            //干掉自己这一页
            [self dismissViewControllerAnimated:NO completion:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //如果没有登录显示去登陆
    if([[UserInfoManager share] hasLogin] == NO){
        //显示登录按钮
        [self.payBtn setTitle:@"去登录" forState:UIControlStateNormal];
    }else{
        [self.payBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    }
}
@end
