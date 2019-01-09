//
//  ZZTMeWalletViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/5.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTMeWalletViewController.h"
#import "ZZTVIPTopView.h"
#import "ZZTWalletCell.h"
#import "ZZTFreeBiModel.h"
#import "ZZTShoppingButtomCell.h"
#import "ZZTWalletTopView.h"
#import "ZZTTopUpView.h"
#import "ZZTVIPBtView.h"
#import "MLIAPManager.h"
#import <SVProgressHUD.h>
#import "ZZTZBView.h"
#import "ZZTVisitorPurchaseView.h"

#import "MLIAPManager.h"

NSString *XYStoreErrorDomain1 = @"com.quvideo.store";

NSString *SBCachePreferenceKeyPrefix1 = @"sb_cache_pre_key_prefix";

NSString *XYStoreiTunesVerifyReceiptURL1 = @"https://buy.itunes.apple.com/verifyReceipt";

NSString *XYStoreiTunesSandboxVerifyReceiptURL1 = @"https://sandbox.itunes.apple.com/verifyReceipt";

@interface ZZTMeWalletViewController ()<UITableViewDelegate,UITableViewDataSource,MLIAPManagerDelegate,SKPaymentTransactionObserver,SKRequestDelegate,SKProductsRequestDelegate,SBIAPManagerDelegate>


@property (nonatomic,strong) NSArray *dataArray;

@property (weak, nonatomic) IBOutlet ZZTZBView *sixBtn;
@property (weak, nonatomic) IBOutlet ZZTZBView *twelveBtn;
@property (weak, nonatomic) IBOutlet ZZTZBView *eighteenBtn;
@property (weak, nonatomic) IBOutlet ZZTZBView *thirtyBtn;
@property (weak, nonatomic) IBOutlet ZZTZBView *fiftyBtn;
@property (weak, nonatomic) IBOutlet ZZTZBView *ninetyEightBtn;
@property (strong, nonatomic) NSString *productId;
@property (strong, nonatomic) ZZTFreeBiModel *buyModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerH;
@property (weak, nonatomic) IBOutlet UILabel *ZbLab;
//缓存
@property (nonatomic, strong) NSMutableDictionary *verifiedReceipts;

@property (assign, nonatomic) BOOL isBuy;

//是否登录
@property (nonatomic, assign) BOOL isLogin;

@end

@implementation ZZTMeWalletViewController

NSString *zztWalletCell = @"zztWalletCell";

NSString *zzTShoppingButtomCell = @"ZZTShoppingButtomCell";


-(NSArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //登录后开关
    self.isLogin = NO;
    
    NSLog(@"是否有网络：%d",[Utilities connectedToNetwork] );
    //我的模块  navbar 风格设置
    [self.viewNavBar.centerButton setTitle:@"充值" forState:UIControlStateNormal];
    
    [self setMeNavBarStyle];
    //有网操作
    if([Utilities connectedToNetwork] == YES){
      
        [self setupArray];
        
        self.ZbLab.text = [NSString stringWithFormat:@"%ld", (long)[Utilities GetNSUserDefaults].zzbNum];
        
        //启动回调
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

        self.isBuy = NO;
        
        CGFloat bannerH;
        if(SCREEN_WIDTH == 414){
            bannerH = 150;
        }else{
            bannerH = 136;
        }
        
        _bannerH.constant = bannerH;
        
    }else{
        [self.view layoutIfNeeded];
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, Height_NavBar, SCREEN_WIDTH, SCREEN_HEIGHT)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:whiteView];
    }
}

-(void)setUpTopUpBtn{
    self.sixBtn.walletModel = self.dataArray[0];
    self.twelveBtn.walletModel = self.dataArray[1];
    self.eighteenBtn.walletModel = self.dataArray[2];
    self.thirtyBtn.walletModel = self.dataArray[3];
    self.fiftyBtn.walletModel = self.dataArray[4];
    self.ninetyEightBtn.walletModel = self.dataArray[5];
    
    self.sixBtn.viewBtn.tag = 0;
    self.twelveBtn.viewBtn.tag = 1;
    self.eighteenBtn.viewBtn.tag = 2;
    self.thirtyBtn.viewBtn.tag = 3;
    self.fiftyBtn.viewBtn.tag = 4;
    self.ninetyEightBtn.viewBtn.tag = 5;

    [self.sixBtn.viewBtn addTarget:self action:@selector(viewBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.twelveBtn.viewBtn addTarget:self action:@selector(viewBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.eighteenBtn.viewBtn addTarget:self action:@selector(viewBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.thirtyBtn.viewBtn addTarget:self action:@selector(viewBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.fiftyBtn.viewBtn addTarget:self action:@selector(viewBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.ninetyEightBtn.viewBtn addTarget:self action:@selector(viewBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewBtn:(ZZTZBView *)btn{
    
    if([[UserInfoManager share] hasLogin] == NO){
        //显示游客模式
        ZZTVisitorPurchaseView *visPV = [ZZTVisitorPurchaseView initVisitorPurchaseViewWithLogin:^{
            //选择登录
            [UserInfoManager needLogin];
            self.isLogin = YES;
            
        } visPurchase:^{
            //选择直接购买
            [self purchaseTargetWithIndex:btn.tag];
            
        }];
        
        [visPV showVPAlert];

    }else{
        [self purchaseTargetWithIndex:btn.tag];
    }
}

//购买商品
-(void)purchaseTargetWithIndex:(NSInteger)index{
    //获取商品信息
    ZZTFreeBiModel *model = self.dataArray[index];
    _buyModel = model;
    
    SBIAPManager *manager = [SBIAPManager manager];
    [manager requestProductWithId:model.goodsOrder];
    manager.delegate = self;

}

//内购成功返回
-(void)successDonePurchase{
    
    UserInfoManager *user = [UserInfoManager share];
    
    [user loadUserInfoDataSuccess:^{
        self.ZbLab.text = [NSString stringWithFormat:@"%ld", (long)[Utilities GetNSUserDefaults].zzbNum];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.isLogin == YES && [[Utilities GetNSUserDefaults].userType isEqualToString:@"3"]){
    self.ZbLab.text = [NSString stringWithFormat:@"%ld", (long)[Utilities GetNSUserDefaults].zzbNum];
    }
}

- (NSMutableDictionary *)verifiedReceipts
{
    if (!_verifiedReceipts) {
        _verifiedReceipts = [NSMutableDictionary dictionary];
    }
    
    return _verifiedReceipts;
}

#pragma mark - 设置数据源
-(void)setupArray{
    [MBProgressHUD showMessage:@"正在获取商品信息" toView:self.view];
    //获取商品信息
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dict = @{
                           @"goodsType":@"1",// 1充值z币；2购买会员
                           };
    [manager POST:[ZZTAPI stringByAppendingString:@"record/getGoodsList"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        self.dataArray = [ZZTFreeBiModel mj_objectArrayWithKeyValuesArray:dic];
        [self setUpTopUpBtn];
        NSLog(@"dic:%@",dic);
        [MBProgressHUD hideHUDForView:self.view];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

@end
