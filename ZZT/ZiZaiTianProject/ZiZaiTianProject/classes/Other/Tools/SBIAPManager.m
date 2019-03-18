//
//  SBIAPManager.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/21.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "SBIAPManager.h"
#import <SVProgressHUD.h>
#import "SandBoxHelper.h"


static NSString * const XYStoreErrorDomain2 = @"com.quvideo.store";

static NSString * const SBCachePreferenceKeyPrefix2 = @"sb_cache_pre_key_prefix";

static NSString * const XYStoreiTunesVerifyReceiptURL2 = @"https://buy.itunes.apple.com/verifyReceipt";

static NSString * const XYStoreiTunesSandboxVerifyReceiptURL2 = @"https://sandbox.itunes.apple.com/verifyReceipt";



static NSString * const receiptKey = @"receipt_key";


dispatch_queue_t iap_queue() {
    static dispatch_queue_t as_iap_queue;
    static dispatch_once_t onceToken_iap_queue;
    dispatch_once(&onceToken_iap_queue, ^{
        as_iap_queue = dispatch_queue_create("com.iap.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return as_iap_queue;
}

@interface SBIAPManager ()<SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (nonatomic, assign) BOOL goodsRequestFinished; //判断一次请求是否完成

@property (nonatomic, copy) NSString *receipt; //交易成功后拿到的一个64编码字符串

@property (assign, nonatomic) BOOL isBuy;

//缓存
@property (nonatomic, strong) NSMutableDictionary *verifiedReceipts;

@property (nonatomic, strong) NSString *productId;

@end

@implementation SBIAPManager

+ (instancetype)manager
{
    static id instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SBIAPManager alloc] init];
    });
    
    return instance;
}

- (void)startManager { //开启监听
    
    dispatch_async(iap_queue(), ^{
        
        self.goodsRequestFinished = YES;
        
        /***
         内购支付两个阶段：
         1.app直接向苹果服务器请求商品，支付阶段；
         2.苹果服务器返回凭证，app向公司服务器发送验证，公司再向苹果服务器验证阶段；
         */
        
        /**
         阶段一正在进中,app退出。
         在程序启动时，设置监听，监听是否有未完成订单，有的话恢复订单。
         */
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        /**
         阶段二正在进行中,app退出。
         在程序启动时，检测本地是否有receipt文件，有的话，去二次验证。
         */
//        [self checkIAPFiles];
    });
}

- (void)stopManager{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    });
}

//开始
- (instancetype)init {
    self = [super init];
    if ( self ) {
 
    }
    return self;
}

#pragma mark 查询
- (void)requestProductWithId:(NSString *)productId {
    _productId = productId;
    
//    [self removeAllUncompleteTransactionBeforeStartNewTransaction];
    
    if([SKPaymentQueue canMakePayments]){
        
        [self requestProductData:productId];
        //必须是点击后
        self.isBuy = YES;
    }else{
        NSLog(@"不允许程序内付费");
    }
    
    [SVProgressHUD showWithStatus:nil];

}

#pragma mark -- 结束上次未完成的交易 防止串单
-(void)removeAllUncompleteTransactionBeforeStartNewTransaction{
    NSArray *transactions = [SKPaymentQueue defaultQueue].transactions;
    if (transactions.count > 0) {
        //检测是否有未完成的交易
        for (NSInteger i = 0; i < transactions.count; i++) {
            SKPaymentTransaction* transaction = transactions[i];
            if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
                [self buyAppleStoreProductSucceedWithPaymentTransactionp:transaction];
                
                [self completeTransaction:transaction];
                
                break;
            }
        }
    }
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
        
        if([pro.productIdentifier isEqualToString:_productId]){
            p = pro;
        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    
    NSLog(@"发送购买请求");
    
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
//    [SVProgressHUD showWithStatus:nil];

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
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
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
    NSString *transactionReceiptString = [receipt base64EncodedStringWithOptions:0];
    
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    // 发出请求
    UserInfo *user = [Utilities GetNSUserDefaults];
    NSDictionary *dict = @{
                           @"TransactionID":transactionReceipt.transactionIdentifier,//订单号
                           @"Payload":transactionReceiptString,//票据
                           @"userId":[NSString stringWithFormat:@"%ld",user.id]
                           };
    [manager POST:[ZZTAPI stringByAppendingString:@"iosBuy/recharge"]  parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject = %@", responseObject);
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(successDonePurchase)]) {

            [self.delegate successDonePurchase];

        }
        
        [self completeTransaction:transactionReceipt];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易结束");
    self.isBuy = NO;
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
}


















//// 苹果内购支付成功
//- (void)buyAppleStoreProductSucceedWithPaymentTransactionp:(SKPaymentTransaction *)transactionReceipt {
//    //获取凭证
//    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
//    NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
//    NSString *transactionReceiptString = [receipt base64EncodedStringWithOptions:0];
//    
////    XYStoreiTunesVerifyReceiptURL2   XYStoreiTunesSandboxVerifyReceiptURL2
//    //验证凭证
////    [self verifyRequestData:transactionReceiptString url:XYStoreiTunesSandboxVerifyReceiptURL2 transaction:transactionReceipt success:^{
////        NSLog(@"OK~");
//    
//    
//    if([[Utilities GetNSUserDefaults].userType isEqualToString:@"3"]){
//        
//    }
//    
//        AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
//        // 发出请求
//        UserInfo *user = [Utilities GetNSUserDefaults];
//        NSDictionary *dict = @{
//                               @"TransactionID":transactionReceipt.transactionIdentifier,//订单号
//                               @"Payload":transactionReceiptString,//票据
//                               @"userId":[NSString stringWithFormat:@"%ld",user.id]
//                               };
//        [manager POST:[ZZTAPI stringByAppendingString:@"iosBuy/recharge"]  parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//            if (self.delegate && [self.delegate respondsToSelector:@selector(successDonePurchase)]) {
//                
//                [self.delegate successDonePurchase];
//
//            }
//
//            [self completeTransaction:transactionReceipt];
//
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
////            [self completeTransaction:transactionReceipt];
//
//        }];
//        
////    } failure:^(NSError *error) {
//////        [self completeTransaction:transactionReceipt];
////    }];
//    
//}
//
////苹果验证
//- (void)verifyRequestData:(NSString *)base64Data
//                      url:(NSString *)url
//              transaction:(SKPaymentTransaction *)transaction
//                  success:(void (^)(void))successBlock
//                  failure:(void (^)(NSError *error))failureBlock
//{
//    //发送苹果验证
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setValue:base64Data forKey:@"receipt-data"];
//    [params setValue:@"9a55a967740f41bcbb659a6872ceeb51" forKey:@"password"];
//    
//    NSError *jsonError;
//    NSData *josonData = [NSJSONSerialization dataWithJSONObject:params
//                                                        options:NSJSONWritingPrettyPrinted
//                                                          error:&jsonError];
//    //如果请求失败
//    if (jsonError) {
//        NSLog(@"验证请求失败: error = %@", jsonError);
//    }
//    
//    //对什么环境测试
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
//    request.HTTPBody = josonData;
//    static NSString *requestMethod = @"POST";
//    request.HTTPMethod = requestMethod;
//    
//    __weak typeof(self) weakSelf = self;
//    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSError *error;
//        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //没有返回数据
//            if (!data) {
//                NSLog(@"出错！！！ 没有数据");
//                //返回错误
//                //                if (failureBlock != nil) failureBlock(wrapperError);
//                return;
//            }
//            
//            NSError *jsonError;
//            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
//            NSLog(@"responseJSO:%@",responseJSON);
//            
//            if (!responseJSON) {
//                NSLog(@"苹果没有返回你想要的数据");
//                if (failureBlock != nil) failureBlock(jsonError);
//            }
//            
//            static NSString *statusKey = @"status";
//            NSInteger statusCode = [responseJSON[statusKey] integerValue];
//            
//            static NSInteger successCode = 0;
//            static NSInteger sandboxCode = 21007;
//            if (statusCode == successCode) {
//                NSLog(@"验证成功！！！！");
//                // 缓存票据校验结果
//                [weakSelf saveVerifiedReceipts:transaction response:responseJSON];
//                if (successBlock != nil) successBlock();
//            } else if (statusCode == sandboxCode) {
//                //沙盒验证
//                [weakSelf sandboxVerify:base64Data
//                            transaction:transaction
//                                success:successBlock
//                                failure:failureBlock];
//            } else {
//                //验证失败
//                NSLog(@"Verification Failed With Code %ld", (long)statusCode);
//                NSError *serverError = [NSError errorWithDomain:XYStoreErrorDomain2 code:statusCode userInfo:nil];
//                if (failureBlock != nil) failureBlock(serverError);
//            }
//        });
//    });
//}
//
//// 缓存票据校验结果
//- (void)saveVerifiedReceipts:(SKPaymentTransaction *)transaction
//                    response:(NSDictionary *)response
//{
//    if (!transaction) {
//        return;
//    }
//    
//    NSString *key = [self verifiedReceiptPrefrenceKey:transaction.payment.productIdentifier
//                                  applicationUsername:transaction.payment.applicationUsername];
//    NSLog(@"我想看看KEY：%@",key);
//    [self.verifiedReceipts setValue:response forKey:key];
//
//    [[NSUserDefaults standardUserDefaults] setValue:response forKey:key];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
////存储对应的key
//- (NSString *)verifiedReceiptPrefrenceKey:(NSString *)productId
//                      applicationUsername:(NSString *)applicationUsername
//{
//    NSString *userName = applicationUsername;
//    if ([applicationUsername isEqual:NULL] || [applicationUsername isKindOfClass:[NSNull class]] || !applicationUsername) {
//        userName = @"";
//    }
//    return [NSString stringWithFormat:@"%@_%@%@", SBCachePreferenceKeyPrefix2, userName, productId];
//}
//
//- (void)sandboxVerify:(NSString *)base64Data
//          transaction:(SKPaymentTransaction *)transaction
//              success:(void (^)(void))successBlock
//              failure:(void (^)(NSError *error))failureBlock
//{
//    NSLog(@"Verifying Sandbox Receipt");
//    [self verifyRequestData:base64Data
//                        url:XYStoreiTunesSandboxVerifyReceiptURL2
//                transaction:transaction
//                    success:successBlock failure:failureBlock];
//}

- (NSMutableDictionary *)verifiedReceipts
{
    if (!_verifiedReceipts) {
        _verifiedReceipts = [NSMutableDictionary dictionary];
    }
    
    return _verifiedReceipts;
}

////交易结束
//- (void)completeTransaction:(SKPaymentTransaction *)transaction{
//    NSLog(@"交易结束");
//    self.isBuy = NO;
//    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//}

-(void)failedPurchaseReminder{

    [MBProgressHUD showError:@"购买失败"];

    NSLog(@"购买失败");
}
@end
