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

@interface ZZTMeWalletViewController ()<UITableViewDelegate,UITableViewDataSource,MLIAPManagerDelegate>


@property (nonatomic,strong) NSArray *dataArray;

@property (weak, nonatomic) IBOutlet ZZTZBView *sixBtn;
@property (weak, nonatomic) IBOutlet ZZTZBView *twelveBtn;
@property (weak, nonatomic) IBOutlet ZZTZBView *eighteenBtn;
@property (weak, nonatomic) IBOutlet ZZTZBView *thirtyBtn;
@property (weak, nonatomic) IBOutlet ZZTZBView *fiftyBtn;
@property (weak, nonatomic) IBOutlet ZZTZBView *ninetyEightBtn;
@property (strong, nonatomic) NSString *productId;

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
    
    [self.viewNavBar.centerButton setTitle:@"充值" forState:UIControlStateNormal];
    
    [self addBackBtn];
    
    [self setupArray];
    
    [self setUpTopUpBtn];

}

-(void)setUpTopUpBtn{
    self.sixBtn.walletModel = self.dataArray[0];
    self.twelveBtn.walletModel = self.dataArray[1];
    self.eighteenBtn.walletModel = self.dataArray[2];
    self.thirtyBtn.walletModel = self.dataArray[3];
    self.fiftyBtn.walletModel = self.dataArray[4];
    self.ninetyEightBtn.walletModel = self.dataArray[5];
    
    self.sixBtn.tag = 0;
    self.twelveBtn.tag = 1;
    self.eighteenBtn.tag = 2;
    self.thirtyBtn.tag = 3;
    self.fiftyBtn.tag = 4;
    self.ninetyEightBtn.tag = 5;

    [self.sixBtn.viewBtn addTarget:self action:@selector(viewBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.twelveBtn.viewBtn addTarget:self action:@selector(viewBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.eighteenBtn.viewBtn addTarget:self action:@selector(viewBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.thirtyBtn.viewBtn addTarget:self action:@selector(viewBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.fiftyBtn.viewBtn addTarget:self action:@selector(viewBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.ninetyEightBtn.viewBtn addTarget:self action:@selector(viewBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewBtn:(ZZTZBView *)btn{
    ZZTFreeBiModel *model = self.dataArray[btn.tag];
    [[MLIAPManager sharedManager] requestProductWithId:model.productId];
    
    self.productId = model.productId;
    //内购代理
    [MLIAPManager sharedManager].delegate = self;
    
    [self refreshBtnClicked];

    //菊花 开始
    [SVProgressHUD showWithStatus:nil];
}

#pragma mark - 设置数据源
-(void)setupArray{

    self.dataArray = @[[ZZTFreeBiModel initZZTFreeBiWith:@"600Z币" ZZTBSpend:@"首充+送300Z币" btnType:@"￥6" productId:@"ZZT600ZB"],
                       [ZZTFreeBiModel initZZTFreeBiWith:@"1200Z币" ZZTBSpend:@"首充+送500Z币" btnType:@"￥12" productId:@"ZZT1200ZB"],
                       [ZZTFreeBiModel initZZTFreeBiWith:@"3000Z币" ZZTBSpend:@"首充+送1000Z币" btnType:@"￥30" productId:@"ZZT3000ZB"],
                       [ZZTFreeBiModel initZZTFreeBiWith:@"5000Z币" ZZTBSpend:@"首充+送1500Z币" btnType:@"￥50" productId:@"ZZT5000ZB"],
                       [ZZTFreeBiModel initZZTFreeBiWith:@"9800Z币" ZZTBSpend:@"首充+送2500Z币" btnType:@"￥98" productId:@"ZZT9800ZB"],
                       [ZZTFreeBiModel initZZTFreeBiWith:@"19800Z币" ZZTBSpend:@"首充+送4900Z币" btnType:@"￥198" productId:@"ZZT19800ZB"]];
    
}

#pragma mark - ================ Actions =================

- (void)refreshBtnClicked {
    [[MLIAPManager sharedManager] refreshReceipt];
}


#pragma mark - ================ MLIAPManager Delegate =================

- (void)receiveProduct:(SKProduct *)product {
    
    [SVProgressHUD dismiss];
    
    if (product != nil) {
        //菊花取消
        //购买商品
        if (![[MLIAPManager sharedManager] purchaseProduct:product]) {
            
            //初始化提示框；
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"失败" message:@"您禁止了应用内购买权限,请到设置中开启" preferredStyle: UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
            }]];
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeAnnularDeterminate;
            hud.label.text = @"Loading";
        }
    } else {
        //菊花取消
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"失败" message:@"无法连接App store!" preferredStyle: UIAlertControllerStyleAlert]; [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.label.text = @"Loading";
    }
}

- (void)successedWithReceipt:(NSData *)transactionReceipt transactionId:(NSString *)transactionId{
    [SVProgressHUD dismiss];
    NSLog(@"购买成功");
    
    NSString  *transactionReceiptString = [transactionReceipt base64EncodedStringWithOptions:0];
    NSLog(@"transactionReceiptString:%@",transactionReceiptString);
    if ([transactionReceiptString length] > 0) {
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
    }
}

- (void)failedPurchaseWithError:(NSString *)errorDescripiton {
    [SVProgressHUD dismiss];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"购买失败";
    NSLog(@"购买失败");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"失败" message:errorDescripiton preferredStyle: UIAlertControllerStyleAlert]; [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
@end
