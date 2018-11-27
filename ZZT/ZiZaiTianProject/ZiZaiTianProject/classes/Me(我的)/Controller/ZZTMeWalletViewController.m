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

@interface ZZTMeWalletViewController ()<UITableViewDelegate,UITableViewDataSource,MLIAPManagerDelegate,SKPaymentTransactionObserver,SKRequestDelegate,SKProductsRequestDelegate>


@property (nonatomic,strong) NSArray *dataArray;

@property (weak, nonatomic) IBOutlet ZZTZBView *sixBtn;
@property (weak, nonatomic) IBOutlet ZZTZBView *twelveBtn;
@property (weak, nonatomic) IBOutlet ZZTZBView *eighteenBtn;
@property (weak, nonatomic) IBOutlet ZZTZBView *thirtyBtn;
@property (weak, nonatomic) IBOutlet ZZTZBView *fiftyBtn;
@property (weak, nonatomic) IBOutlet ZZTZBView *ninetyEightBtn;
@property (strong, nonatomic) NSString *productId;
@property (strong, nonatomic) ZZTFreeBiModel *buyModel;

@property (assign, nonatomic) BOOL isBuy;

@end

@implementation ZZTMeWalletViewController


NSString *zztWalletCell = @"zztWalletCell";
NSString *zzTShoppingButtomCell = @"ZZTShoppingButtomCell";

//-(SKProduct *)product{
//    if(!_product){
//        _product = [[SKProduct alloc] init];
//    }
//    return <#expression#>
//}

-(NSArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //我的模块  navbar 风格设置
    [self.viewNavBar.centerButton setTitle:@"充值" forState:UIControlStateNormal];
    
    [self setMeNavBarStyle];
    
    [self setupArray];
    
    [self setUpTopUpBtn];
    
    //启动回调
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    self.isBuy = NO;
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
    ZZTFreeBiModel *model = self.dataArray[btn.tag];
    _buyModel = model;
    if([SKPaymentQueue canMakePayments]){
        [self requestProductData:model.productId];
        //必须是点击后
        self.isBuy = YES;
    }else{
        NSLog(@"不允许程序内付费");
    }
    [SVProgressHUD showWithStatus:nil];

    
    
    
    
//    [[MLIAPManager sharedManager] requestProductWithId:model.productId];
//
//    self.productId = model.productId;
//    //内购代理
//    [MLIAPManager sharedManager].delegate = self;
//
////    [self refreshBtnClicked];
//
//    //菊花 开始
//    [SVProgressHUD showWithStatus:nil];
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
        
        if([pro.productIdentifier isEqualToString:_buyModel.productId]){
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
                [self failedPurchaseReminder];
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
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//        // 发出请求
//        UserInfo *user = [Utilities GetNSUserDefaults];
//        NSDictionary *dict = @{
//                               @"TransactionID":transactionReceipt.transactionIdentifier,//订单号
//                               @"Payload":transactionReceiptString,//票据
//                               @"userId":[NSString stringWithFormat:@"%ld",user.id]
//                               };
//        [manager POST:[ZZTAPI stringByAppendingString:@"iosBuy/recharge"]  parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"responseObject = %@", responseObject);
//            [self completeTransaction:transactionReceipt];
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [self completeTransaction:transactionReceipt];
//        }];
        
    }
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

#pragma mark - 设置数据源
-(void)setupArray{
    self.dataArray = @[
                       [ZZTFreeBiModel initZZTFreeBiWith:@"600Z币" ZZTBSpend:@"首充+送300Z币" btnType:@"￥6" productId:@"ZZT600ZB"],
                       [ZZTFreeBiModel initZZTFreeBiWith:@"1200Z币" ZZTBSpend:@"首充+送500Z币" btnType:@"￥12" productId:@"ZZT1200ZB"],
                       [ZZTFreeBiModel initZZTFreeBiWith:@"3000Z币" ZZTBSpend:@"首充+送1000Z币" btnType:@"￥30" productId:@"ZZT3000ZB"],
                       [ZZTFreeBiModel initZZTFreeBiWith:@"5000Z币" ZZTBSpend:@"首充+送1500Z币" btnType:@"￥50" productId:@"ZZT5000ZB"],
                       [ZZTFreeBiModel initZZTFreeBiWith:@"9800Z币" ZZTBSpend:@"首充+送2500Z币" btnType:@"￥98" productId:@"ZZT9800ZB"],
                       [ZZTFreeBiModel initZZTFreeBiWith:@"19800Z币" ZZTBSpend:@"首充+送4900Z币" btnType:@"￥198" productId:@"ZZT19800ZB"]
                       ];
}

//#pragma mark - ================ Actions =================
//
//- (void)refreshBtnClicked {
//    [[MLIAPManager sharedManager] refreshReceipt];
//}
//
//
//#pragma mark - ================ MLIAPManager Delegate =================
//
//- (void)receiveProduct:(SKProduct *)product {
//
//    [SVProgressHUD dismiss];
//
//    if (product != nil) {
//        //菊花取消
//        //购买商品
//        if (![[MLIAPManager sharedManager] purchaseProduct:product]) {
//
//            //初始化提示框；
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"失败" message:@"您禁止了应用内购买权限,请到设置中开启" preferredStyle: UIAlertControllerStyleAlert];
//            [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                //点击按钮的响应事件；
//            }]];
//            //弹出提示框；
//            [self presentViewController:alert animated:true completion:nil];
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeAnnularDeterminate;
//            hud.label.text = @"Loading";
//        }
//    } else {
//        //菊花取消
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"失败" message:@"无法连接App store!" preferredStyle: UIAlertControllerStyleAlert]; [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            //点击按钮的响应事件；
//        }]];
//        //弹出提示框；
//        [self presentViewController:alert animated:true completion:nil];
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.mode = MBProgressHUDModeAnnularDeterminate;
//        hud.label.text = @"Loading";
//    }
//}
//
- (void)successedWithReceipt:(NSData *)transactionReceipt transactionId:(NSString *)transactionId{
//    [SVProgressHUD dismiss];
//    NSLog(@"购买成功");
//
    NSString  *transactionReceiptString = [transactionReceipt base64EncodedStringWithOptions:0];
//    NSLog(@"transactionReceiptString:%@",transactionReceiptString);
//    if ([transactionReceiptString length] > 0) {
        // 向自己的服务器验证购买凭证（此处应该考虑将凭证本地保存,对服务器有失败重发机制）
        /**
         服务器要做的事情:
         接收ios端发过来的购买凭证。
         判断凭证是否已经存在或验证过，然后存储该凭证。
         将该凭证发送到苹果的服务器验证，并将验证结果返回给客户端。
         如果需要，修改用户相应的会员权限
         */
        
        // 设置请求参数(key是苹果规定的)
        
        // 获取网络管理者
//        // 设置请求参数(key是苹果规定的)
//
//        // 获取网络管理者
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//        // 发出请求
//        UserInfo *user = [Utilities GetNSUserDefaults];
//        NSDictionary *dict = @{
//                               @"TransactionID":transactionId,//订单号
//                               @"Payload":transactionReceiptString,//票据
//                               @"userId":[NSString stringWithFormat:@"%ld",user.id]
//                               };
//        [manager POST:[ZZTAPI stringByAppendingString:@"iosBuy/recharge"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"responseObject:%@",responseObject);
        
//        [manager POST:@"https://sandbox.itunes.apple.com/verifyReceipt" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
//
//            NSLog(@"responseObject = %@", responseObject);
//
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        
        /**
         if (凭证校验成功) {
         [[MLIAPManager sharedManager] finishTransaction];
         }
         */
//    }
//}

//- (void)failedPurchaseWithError:(NSString *)errorDescripiton {
//    [SVProgressHUD dismiss];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeAnnularDeterminate;
//    hud.label.text = @"购买失败";
//    NSLog(@"购买失败");
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"失败" message:errorDescripiton preferredStyle: UIAlertControllerStyleAlert]; [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //点击按钮的响应事件；
//    }]];
//    //弹出提示框；
//    [self presentViewController:alert animated:true completion:nil];
}

-(void)failedPurchaseReminder{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeAnnularDeterminate;
//    hud.label.text = @"购买失败";
    [MBProgressHUD showError:@"购买失败"];
    NSLog(@"购买失败");
}
@end
