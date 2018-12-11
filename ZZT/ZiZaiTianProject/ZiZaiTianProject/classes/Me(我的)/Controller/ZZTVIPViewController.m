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

@interface ZZTVIPViewController () <MLIAPManagerDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver>
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
    
    [self.viewNavBar.centerButton setTitle:@"VIP" forState:UIControlStateNormal];
    
    [self setMeNavBarStyle];
    
    if([Utilities connectedToNetwork] == YES){
        //用户头像
        [self.userImg sd_setImageWithURL:[NSURL URLWithString:[Utilities GetNSUserDefaults].headimg]];
        NSLog(@"aasasdasda:%@",[Utilities GetNSUserDefaults].headimg);
        //VIP到期时间
        self.VIPDateLab.text = @"2018-12-12 到期";
       
        [self setupArray];
        
//        [self setUpTopUpBtn];
        
        //启动回调
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        self.isBuy = NO;
        
        [MLIAPManager sharedManager].delegate = self;
        
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

#pragma mark - 设置数据源
-(void)setupArray{
    [MBProgressHUD showMessage:@"正在获取商品信息" toView:self.view];
    //获取商品信息
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dict = @{
                           @"goodsType":@"2",// 1充值z币；2购买会员
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
    //获取商品信息
    ZZTFreeBiModel *model = self.dataArray[btn.tag];
    _buyModel = model;
    if([SKPaymentQueue canMakePayments]){
        [self requestProductData:model.goodsOrder];
        //必须是点击后
        self.isBuy = YES;
    }else{
        NSLog(@"不允许程序内付费");
    }
    [SVProgressHUD showWithStatus:nil];
}


//请求商品
- (void)requestProductData:(NSString *)type{
    NSLog(@"-------------请求对应的产品信息----------------");
    NSArray *product = [[NSArray alloc] initWithObjects:type, nil];
    
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
}

//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"--------------收到产品反馈消息---------------------");
    NSArray *product = response.products;
    if([product count] == 0){
        NSLog(@"--------------没有商品------------------");
        return;
    }
    
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%ld",[product count]);
    
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
        
        if([pro.productIdentifier isEqualToString:_buyModel.goodsOrder]){
            p = pro;
        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    
    NSLog(@"发送购买请求");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"------------------错误-----------------:%@", error);
}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"------------反馈信息结束-----------------");
}


//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    [SVProgressHUD dismiss];
    for(SKPaymentTransaction *tran in transaction){
        
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"交易完成");
                NSLog(@"发送后台验证");
                if(self.isBuy == YES){
                    [self buyAppleStoreProductSucceedWithPaymentTransactionp:tran];
                    // 订阅特殊处理
                    if(tran.originalTransaction){
                        // 如果是自动续费的订单originalTransaction会有内容
                    }else{
                        // 普通购买，以及 第一次购买 自动订阅
                    }
                }else{
                    [self completeTransaction:tran];
                }
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"交易失败");
                //失败提示
                [MBProgressHUD showError:@"购买失败"];
                [self completeTransaction:tran];
                break;
            default:
                break;
        }
    }
}

// 苹果内购支付成功
- (void)buyAppleStoreProductSucceedWithPaymentTransactionp:(SKPaymentTransaction *)transactionReceipt {
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
    NSString  *transactionReceiptString = [receipt base64EncodedStringWithOptions:0];
    
    NSLog(@"transactionReceiptString:%@",transactionReceiptString);
    if ([transactionReceiptString length] > 0) {
        
        //         获取网络管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

        // 发出请求
        UserInfo *user = [Utilities GetNSUserDefaults];
        NSDictionary *dict = @{
                               @"TransactionID":transactionReceipt.transactionIdentifier,//订单号
                               @"Payload":transactionReceiptString,//票据
                               @"userId":[NSString stringWithFormat:@"%ld",user.id]
                               };
        [manager POST:[ZZTAPI stringByAppendingString:@"iosBuy/recharge"]  parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"responseObject = %@", responseObject);
            [self completeTransaction:transactionReceipt];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self completeTransaction:transactionReceipt];
        }];
        [self loadUserData];
    }
}

-(void)loadUserData{
    
    NSDictionary *paramDict = @{
                                @"userId":[NSString stringWithFormat:@"%ld",[Utilities GetNSUserDefaults].id]
                                };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[ZZTAPI stringByAppendingString:@"login/usersInfo"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        
        NSArray *array = [UserInfo mj_objectArrayWithKeyValuesArray:dic];
        if(array.count != 0){
            UserInfo *model = array[0];
            //存一下数据
            [Utilities SetNSUserDefaults:model];
            self.VIPDateLab.text = @"2018-12-12 到期";
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易结束");
    self.isBuy = NO;
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}


- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

@end
