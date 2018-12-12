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


NSString *XYStoreErrorDomain = @"com.quvideo.store";

NSString *SBCachePreferenceKeyPrefix = @"sb_cache_pre_key_prefix";

NSString *XYStoreiTunesVerifyReceiptURL = @"https://buy.itunes.apple.com/verifyReceipt";

NSString *XYStoreiTunesSandboxVerifyReceiptURL = @"https://sandbox.itunes.apple.com/verifyReceipt";

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

//缓存
@property (nonatomic, strong) NSMutableDictionary *verifiedReceipts;

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
        
        //启动内购回调
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
                    [self buyAppleStoreProductSucceedWithPaymentTransactionp:tran];

//                [self completeTransaction:tran];

                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                [self completeTransaction:tran];
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
    
    [self verifyRequestData:transactionReceiptString url:XYStoreiTunesSandboxVerifyReceiptURL transaction:transactionReceipt success:^{
        NSLog(@"OK~");
        
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
        
    } failure:^(NSError *error) {
        [self completeTransaction:transactionReceipt];
    }];
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

- (void)verifyRequestData:(NSString *)base64Data
                      url:(NSString *)url
              transaction:(SKPaymentTransaction *)transaction
                  success:(void (^)(void))successBlock
                  failure:(void (^)(NSError *error))failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:base64Data forKey:@"receipt-data"];
    [params setValue:@"9a55a967740f41bcbb659a6872ceeb51" forKey:@"password"];
    
    NSError *jsonError;
    NSData *josonData = [NSJSONSerialization dataWithJSONObject:params
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:&jsonError];
    //如果请求失败
    if (jsonError) {
        NSLog(@"验证请求失败: error = %@", jsonError);
    }
    
    //对什么环境测试
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPBody = josonData;
    static NSString *requestMethod = @"POST";
    request.HTTPMethod = requestMethod;
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            //没有返回数据
            if (!data) {
                NSLog(@"出错！！！ 没有数据");
                //返回错误
                //                if (failureBlock != nil) failureBlock(wrapperError);
                return;
            }
            
            NSError *jsonError;
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            NSLog(@"responseJSONresponseJSONresponseJSONresponseJSON:%@",responseJSON);
            
            if (!responseJSON) {
                NSLog(@"苹果没有返回你想要的数据");
                if (failureBlock != nil) failureBlock(jsonError);
            }
            
            static NSString *statusKey = @"status";
            NSInteger statusCode = [responseJSON[statusKey] integerValue];
            
            static NSInteger successCode = 0;
            static NSInteger sandboxCode = 21007;
            if (statusCode == successCode) {
                NSLog(@"验证成功！！！！");
                [weakSelf saveVerifiedReceipts:transaction response:responseJSON];
                if (successBlock != nil) successBlock();
            } else if (statusCode == sandboxCode) {
                //如果是沙盒
                [weakSelf sandboxVerify:base64Data
                            transaction:transaction
                                success:successBlock
                                failure:failureBlock];
            } else {
                //验证失败
                NSLog(@"Verification Failed With Code %ld", (long)statusCode);
                NSError *serverError = [NSError errorWithDomain:XYStoreErrorDomain code:statusCode userInfo:nil];
                if (failureBlock != nil) failureBlock(serverError);
            }
        });
    });
}

// 缓存票据校验结果
- (void)saveVerifiedReceipts:(SKPaymentTransaction *)transaction
                    response:(NSDictionary *)response
{
    if (!transaction) {
        return;
    }
    
    NSString *key = [self verifiedReceiptPrefrenceKey:transaction.payment.productIdentifier
                                  applicationUsername:transaction.payment.applicationUsername];
    NSLog(@"我想看看KEY：%@",key);
    [self.verifiedReceipts setValue:response forKey:key];
    NSLog(@"我想看看response：%@",response);
    [[NSUserDefaults standardUserDefaults] setValue:response forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 存储对应的key
- (NSString *)verifiedReceiptPrefrenceKey:(NSString *)productId
                      applicationUsername:(NSString *)applicationUsername
{
    NSString *userName = applicationUsername;
    if ([applicationUsername isEqual:NULL] || [applicationUsername isKindOfClass:[NSNull class]] || !applicationUsername) {
        userName = @"";
    }
    return [NSString stringWithFormat:@"%@_%@%@", SBCachePreferenceKeyPrefix, userName, productId];
}

- (void)sandboxVerify:(NSString *)base64Data
          transaction:(SKPaymentTransaction *)transaction
              success:(void (^)(void))successBlock
              failure:(void (^)(NSError *error))failureBlock
{
    NSLog(@"Verifying Sandbox Receipt");
    [self verifyRequestData:base64Data
                        url:XYStoreiTunesSandboxVerifyReceiptURL
                transaction:transaction
                    success:successBlock failure:failureBlock];
}

- (NSMutableDictionary *)verifiedReceipts
{
    if (!_verifiedReceipts) {
        _verifiedReceipts = [NSMutableDictionary dictionary];
    }
    
    return _verifiedReceipts;
}


@end
