//
//  ZZTVIPViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/6/27.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTVIPViewController.h"
#import "ZZTVIPTopView.h"
#import "ZZTVIPMidView.h"
#import "ZZTVIPBtView.h"
#import "MLIAPManager.h"
#import <SVProgressHUD.h>
#import <MBProgressHUD.h>
#import "ZZTZBView.h"
#import "ZZTFreeBiModel.h"
#import "ZZTVisitorPurchaseView.h"

static NSString * const XYStoreErrorDomain1 = @"com.quvideo.store";

static NSString * const SBCachePreferenceKeyPrefix1 = @"sb_cache_pre_key_prefix";

static NSString * const XYStoreiTunesVerifyReceiptURL1 = @"https://buy.itunes.apple.com/verifyReceipt";

static NSString * const XYStoreiTunesSandboxVerifyReceiptURL1 = @"https://sandbox.itunes.apple.com/verifyReceipt";

@interface ZZTVIPViewController () <MLIAPManagerDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver,SBIAPManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *VipDate;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet ZZTZBView *oneMonthXu;
@property (weak, nonatomic) IBOutlet ZZTZBView *oneMonth;
@property (weak, nonatomic) IBOutlet ZZTZBView *threeMonth;
@property (weak, nonatomic) IBOutlet ZZTZBView *twelveMonth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerH;
@property (weak, nonatomic) IBOutlet UILabel *VIPDateLab;

@property (strong, nonatomic) ZZTFreeBiModel *buyModel;

@property (assign, nonatomic) BOOL isBuy;

@property (strong, nonatomic) NSArray *dataArray;

@property (weak, nonatomic) IBOutlet UIImageView *userImg;

//缓存
@property (nonatomic, strong) NSMutableDictionary *verifiedReceipts;
//是否登录
@property (nonatomic, assign) BOOL isLogin;

@end

@implementation ZZTVIPViewController

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
    
    [self.viewNavBar.centerButton setTitle:@"VIP" forState:UIControlStateNormal];
    
    [self setMeNavBarStyle];
    
    if([Utilities connectedToNetwork] == YES){
 
        [self setupUserData];
        
        [self setupArray];
        
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

-(void)setupUserData{
    //用户头像
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:[Utilities GetNSUserDefaults].headimg]];
    
    if([Utilities GetNSUserDefaults].vipEndtime == nil){
        
        self.VIPDateLab.text = [NSString stringWithFormat:@"非会员"];
        
    }else{
        
        self.VIPDateLab.text = [NSString stringWithFormat:@"%@ 到期",[NSString timeWithStr:[Utilities GetNSUserDefaults].vipEndtime]];
        
    }
}

#pragma mark - 设置数据源
-(void)setupArray{
    [MBProgressHUD showMessage:@"正在获取商品信息" toView:self.view];
    //获取商品信息
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    NSDictionary *dict = @{
                           @"goodsType":@"2",// 1充值z币；2购买会员
                           };
    [manager POST:[ZZTAPI stringByAppendingString:@"record/getGoodsList"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        
        self.dataArray = [ZZTFreeBiModel mj_objectArrayWithKeyValuesArray:dic];
        
        [self setUpTopUpBtn];

        [MBProgressHUD hideHUDForView:self.view];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
        [MBProgressHUD showSuccess:@"获取商品失败"];
    }];
}

-(void)setUpTopUpBtn{
    
    self.oneMonthXu.VIPModel = self.dataArray[0];
    self.oneMonth.VIPModel = self.dataArray[1];
    self.threeMonth.VIPModel = self.dataArray[2];
    self.twelveMonth.VIPModel = self.dataArray[3];

    self.oneMonthXu.viewBtn.tag = 0;
    self.oneMonth.viewBtn.tag = 1;
    self.threeMonth.viewBtn.tag = 2;
    self.twelveMonth.viewBtn.tag = 3;
   
    [self.oneMonthXu.viewBtn addTarget:self action:@selector(viewBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.oneMonth.viewBtn addTarget:self action:@selector(viewBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.threeMonth.viewBtn addTarget:self action:@selector(viewBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.twelveMonth.viewBtn addTarget:self action:@selector(viewBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewBtn:(ZZTZBView *)btn{
    //VIP
    //如果没有登录
    //弹出View 提示登录  或者继续购买
    if([[UserInfoManager share] hasLogin] == NO){
        //显示游客模式
        ZZTVisitorPurchaseView *visPV = [ZZTVisitorPurchaseView initVisitorPurchaseViewWithLogin:^{
          //选择登录
          [UserInfoManager needLogin];
            
            self.isLogin = YES;

        } visPurchase:^{
            //游客购买
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
    
    [[SBIAPManager manager] requestProductWithId:model.goodsOrder];
    
    [SBIAPManager manager].delegate = self;
}

//成功完成购买
-(void)successDonePurchase{
    
    [[UserInfoManager share] loadUserInfoDataSuccess:^{
        self.VIPDateLab.text = [NSString stringWithFormat:@"%@ 到期",[NSString timeWithStr:[Utilities GetNSUserDefaults].vipEndtime]];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.isLogin == YES && [Utilities GetNSUserDefaults].id != 0){
        [self setupUserData];
    }
}








@end
