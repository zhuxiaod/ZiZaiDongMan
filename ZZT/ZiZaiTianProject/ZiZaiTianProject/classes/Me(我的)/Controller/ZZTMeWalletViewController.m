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

@interface ZZTMeWalletViewController ()<UITableViewDelegate,UITableViewDataSource,MLIAPManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *dataArray;

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
    self.navigationItem.title = @"钱包";
    
    //scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [self.view addSubview:scrollView];
    
    //top
    ZZTWalletTopView *topView = [ZZTWalletTopView WalletTopView];
    topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 140);
    [scrollView addSubview:topView];
    
    //midView
    ZZTTopUpView *midView = [ZZTTopUpView TopUpView];
    midView.buttonAction = ^(UIButton *sender) {
        NSString *productId = @"";
        if(sender.tag == 1)productId = @"ZZT600ZB";
        else if(sender.tag == 2)productId = @"ZZT1200ZB";
        else if (sender.tag == 3)productId = @"ZZT1800ZB";
        else if (sender.tag == 4)productId = @"ZZT2500ZB";
        else if (sender.tag == 5)productId = @"ZZT3000ZB";
        else if (sender.tag == 6)productId = @"ZZT5000ZB";
        else if (sender.tag == 7)productId = @"ZZT9800ZB";
        else if (sender.tag == 8)productId = @"ZZT19800ZB";
        else if (sender.tag == 9)productId = @"ZZT38800ZB";
        [[MLIAPManager sharedManager] requestProductWithId:productId];
        
        [self refreshBtnClicked];
        //菊花 开始
        [SVProgressHUD showWithStatus:nil];
    };
    midView.frame = CGRectMake(0, topView.y + topView.height+15, SCREEN_WIDTH, 300);
    [scrollView addSubview:midView];
    
    //bottom
    ZZTVIPBtView *bottomView = [ZZTVIPBtView VIPBtView];
    bottomView.frame = CGRectMake(0, midView.y + midView.height+15, SCREEN_WIDTH, 300);
    bottomView.title = @"Z币用途";
    bottomView.textViewStr = @"1 .购买订阅章节 2 .打赏作者 3 .购买素材 ";
    [scrollView addSubview:bottomView];
    
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, bottomView.y + bottomView.height);
    
    //创建数据源
    [self setupArray];
    
    UIButton *leftbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    
    [leftbutton setImage:[UIImage imageNamed:@"我的-注释"] forState:UIControlStateNormal];
    leftbutton.contentEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    
    self.navigationItem.rightBarButtonItem = rightitem;
    
    [MLIAPManager sharedManager].delegate = self;
}

#pragma mark - 设置数据源
-(void)setupArray{
    self.dataArray = @[[ZZTFreeBiModel initZZTFreeBiWith:@"600自在币" ZZTBSpend:@"1阅读卷" btnType:@"￥6"],[ZZTFreeBiModel initZZTFreeBiWith:@"3000自在币" ZZTBSpend:@"7阅读卷" btnType:@"￥30"],[ZZTFreeBiModel initZZTFreeBiWith:@"5000自在币" ZZTBSpend:@"15阅读卷" btnType:@"￥50"],[ZZTFreeBiModel initZZTFreeBiWith:@"9800自在币" ZZTBSpend:@"38阅读卷" btnType:@"￥98"],[ZZTFreeBiModel initZZTFreeBiWith:@"19800自在币" ZZTBSpend:@"98阅读卷" btnType:@"￥198"],[ZZTFreeBiModel initZZTFreeBiWith:@"38800自在币" ZZTBSpend:@"238阅读卷" btnType:@"￥388"]];
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

- (void)successedWithReceipt:(NSData *)transactionReceipt {
    [SVProgressHUD dismiss];
    NSLog(@"购买成功");
    
    NSString  *transactionReceiptString = [transactionReceipt base64EncodedStringWithOptions:0];
    
    if ([transactionReceiptString length] > 0) {
        // 向自己的服务器验证购买凭证（此处应该考虑将凭证本地保存,对服务器有失败重发机制）
        /**
         服务器要做的事情:
         接收ios端发过来的购买凭证。
         判断凭证是否已经存在或验证过，然后存储该凭证。
         将该凭证发送到苹果的服务器验证，并将验证结果返回给客户端。
         如果需要，修改用户相应的会员权限
         */
        
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
