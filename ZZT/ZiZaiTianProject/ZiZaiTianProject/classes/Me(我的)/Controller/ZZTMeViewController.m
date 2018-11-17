//
//  ZZTMeViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/6/26.
//  Copyright © 2018年 zxd. All rights reserved.
//
#import "ZZTSignInView.h"
#import "ZZTMeViewController.h"
#import "ZZTMeTopView.h"
#import "ZZTMeCell.h"
#import "ZZTSettingCell.h"
#import "MJExtension.h"
#import "ZZTCell.h"
#import "ZZTLoginRegisterViewController.h"
#import "ZZTVIPViewController.h"
#import "ZZTBrowViewController.h"
#import "ZZTHistoryViewController.h"
#import "ZZTSettingViewController.h"
#import "ZZTMeEditViewController.h"
#import "ZZTMeWalletViewController.h"
#import "ZZTShoppingMallViewController.h"
#import "ZZTCartoonViewController.h"
#import "ZZTMeAttentionViewController.h"
#import "ZZTLoginRegisterViewController.h"
#import "ZZTMyZoneViewController.h"

@interface ZZTMeViewController ()<UITableViewDataSource,UITableViewDelegate,ZZTSignInViewDelegate>

@property(nonatomic,strong) UITableView *tableView;
//cell数据
@property (nonatomic,strong) NSArray *cellData;

@property (nonatomic,strong) AFHTTPSessionManager *manager;

//获得数据
@property (nonatomic,strong) EncryptionTools *encryptionManager;

@property (nonatomic,strong) UserInfo *userData;

@property (nonatomic,strong) ZZTSignInView *signView;

@property (nonatomic,strong) ZZTMeTopView *topView;

@end

@implementation ZZTMeViewController

//cell的标识
NSString *bannerID = @"MeCell";

#pragma mark - 懒加载
- (EncryptionTools *)encryptionManager{
    if(!_encryptionManager){
        _encryptionManager = [EncryptionTools sharedEncryptionTools];
    }
    return _encryptionManager;
}

-(UserInfo *)userData{
    if (!_userData) {
        _userData = [Utilities GetNSUserDefaults];
    }
    return _userData;
}
- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [[AFHTTPSessionManager alloc] init];
;
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRGB:@"200,206,226"];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsCompact];

//    self.rr_navHidden = YES;
//    UINavigationBar *nab = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[UIView class]]];
//
//    [nab setBackgroundImage:[UIImage createImageWithColor:[UIColor blackColor]] forBarMetrics:UIBarMetricsDefault];
//    self.statusBarStyle = UIStatusBarStyleLightContent;
//    [UINavigationBar appearance].translucent=NO;
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //请求数据
//    [self getData];
    //设置table
    [self setupTab];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi)name:@"loadMeView" object:nil];
}

#pragma mark - 设置tableView
-(void)setupTab
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20 , self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    _tableView.sectionHeaderHeight = 10;
    _tableView.sectionFooterHeight = 0;
    _tableView.dataSource = self;
    _tableView.delegate = self;

    //隐藏滚动条
    _tableView.showsVerticalScrollIndicator = NO;
    
    //添加头视图
    ZZTMeTopView *top = [ZZTMeTopView meTopView];
    top.frame = CGRectMake(0, 0, ScreenW, 120);
    _tableView.tableHeaderView = top;
    _topView = top;
    top.buttonAction = ^(UIButton *sender) {
        if(sender.tag == 0){
            //编辑个人资料
            ZZTMeEditViewController *editVC = [[ZZTMeEditViewController alloc] init];
            editVC.hidesBottomBarWhenPushed = YES;
            editVC.model = self.userData;
            [self.navigationController pushViewController:editVC animated:YES];
        }
    };
    top.loginAction = ^(UIButton *btn) {
        //弹出登录页面
//        ZZTLoginRegisterViewController *loginView = [[ZZTLoginRegisterViewController alloc] init];
        [ZZTLoginRegisterViewController show];
    };
    
    [self.view addSubview:_tableView];
    //注册cell
    [self.tableView registerClass:[ZZTMeCell class] forCellReuseIdentifier:bannerID];
}

-(void)setupTopView{
    self.topView.userModel = self.userData;
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return 5;
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if(section == 0){
//        return 1;
//    }else if (section == 1){
//        return 0;
//    }else if (section == 2){
//        return 0;
//    }else if (section == 3){
////        return 4;
//        return 3;
//    }else{
//        return 1;
//    }
    if(section == 0){
        return 1;
    }else if(section == 1){
        return 3;
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZTMeCell *cell = [tableView dequeueReusableCellWithIdentifier:bannerID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.section == 0){
        cell.textLabel.text = @"我的空间";
        return cell;
    }else if(indexPath.section == 1){
        if (indexPath.row == 0){
            cell.textLabel.text = @"书柜";
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"关注";
        }else if(indexPath.row == 2){
            cell.textLabel.text = @"浏览历史";
        }
        return cell;
    }else{
        cell.textLabel.text = @"设置";
        return cell;
    }
    
//    if (indexPath.section == 0) {
//        cell.textLabel.text = @"我的空间";
//        return cell;
//    }else if(indexPath.section == 1){
//        if (indexPath.row == 0) {
//            cell.textLabel.text = @"VIP";
//        }else if (indexPath.row ==1){
//            cell.textLabel.text = @"钱包";
//        }
//        return cell;
//    }else if(indexPath.section == 2){
//        if (indexPath.row == 0) {
//            cell.textLabel.text = @"自在商城";
//        }else if (indexPath.row ==1){
//            cell.textLabel.text = @"积分兑换";
//        }
//        return cell;
//    }else if(indexPath.section == 3){
////        if (indexPath.row == 0) {
////            cell.textLabel.text = @"参与作品";
////        }else
//        if (indexPath.row == 0){
//            cell.textLabel.text = @"书柜";
//        }else if(indexPath.row == 1){
//            cell.textLabel.text = @"关注";
//        }else if(indexPath.row == 2){
//            cell.textLabel.text = @"浏览历史";
//        }
//        return cell;
//    }else{
//        cell.textLabel.text = @"设置";
//        return cell;
//    }
//    return cell;
}

#pragma mark - 请求数据
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsCompact];
//    [self.navigationController.navigationBar setShadowImage:[UIImage createImageWithColor:[UIColor clearColor]]];
//    [self.navigationController.navigationBar setTranslucent:YES];
    
    //隐藏Bar
    //加载用户信息
    UserInfo *userInfo = [Utilities GetNSUserDefaults];
    //有id
    if(userInfo == nil){
        [self loadUserData:0];
    }else{
        //userId已经有了
        [self loadUserData:userInfo.id];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)loadUserData:(NSInteger)Id{
    NSString *userId = [NSString stringWithFormat:@"%ld",Id];
    if([userId isEqualToString:@"0"]){
        UserInfo *model = [[UserInfo alloc] init];
        model.isLogin = NO;
        self.userData = model;
        [self setupTopView];
    }else{
        NSDictionary *paramDict = @{
                                    @"userId":userId
                                    };
        [self.manager POST:[ZZTAPI stringByAppendingString:@"login/usersInfo"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
            
            NSArray *array = [UserInfo mj_objectArrayWithKeyValuesArray:dic];
            if(array.count != 0){
                UserInfo *model = array[0];
                model.isLogin = YES;
                self.userData = model;
                [self setupTopView];
                //存一下数据
                [Utilities SetNSUserDefaults:model];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}

-(void)tongzhi{
    //取
    UserInfo *userInfo = [Utilities GetNSUserDefaults];
    [self loadUserData:userInfo.id];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if([[UserInfoManager share] hasLogin] == NO){
            [UserInfoManager needLogin];
            return;
        }
        //我的空间
        ZZTMyZoneViewController *myZoneView = [[ZZTMyZoneViewController alloc] init];
        myZoneView.userId = [UserInfoManager share].ID;
        myZoneView.user = self.userData;
        myZoneView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myZoneView animated:YES];
    }else if (indexPath.section == 1){
        if(indexPath.row == 0){
            //书柜
            if([[UserInfoManager share] hasLogin] == NO){
                [UserInfoManager needLogin];
                return;
            }
            ZZTCartoonViewController *bookVC = [[ZZTCartoonViewController alloc] init];
            bookVC.hidesBottomBarWhenPushed = YES;
            bookVC.viewTitle = @"书柜";
            bookVC.viewType = @"2";
            //            bookVC.user = self.userData;
            [self.navigationController pushViewController:bookVC animated:YES];
        }else if(indexPath.row == 1){
            //关注
            if([[UserInfoManager share] hasLogin] == NO){
                [UserInfoManager needLogin];
                return;
            }
            ZZTMeAttentionViewController *meAttentionVC = [[ZZTMeAttentionViewController alloc] init];
            meAttentionVC.hidesBottomBarWhenPushed = YES;
            //            meAttentionVC.user = self.userData;
            [self.navigationController pushViewController:meAttentionVC animated:YES];
        }else if(indexPath.row == 2){
            //浏览历史
            ZZTHistoryViewController *historyVC = [[ZZTHistoryViewController alloc] init];
            historyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:historyVC animated:YES];
        }
    }else{
        //设置
        ZZTSettingViewController *settingVC = [[ZZTSettingViewController alloc] init];
        settingVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:settingVC animated:YES];
    }
    
//    else if (indexPath.section == 1){
//        if(indexPath.row == 0){
//            //VIP
//            ZZTVIPViewController *VIPView = [[ZZTVIPViewController alloc]init];
//            VIPView.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:VIPView animated:YES];
//        }else if(indexPath.row == 1){
//            //钱包
//            ZZTMeWalletViewController *walletVC = [[ZZTMeWalletViewController alloc] init];
//            walletVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:walletVC animated:YES];
//        }
//    }else if(indexPath.section == 2){
//        if(indexPath.row == 0){
//            //自在商城
//            ZZTShoppingMallViewController *shoppingMallVC = [[ZZTShoppingMallViewController alloc] init];
//            shoppingMallVC.hidesBottomBarWhenPushed = YES;
//            shoppingMallVC.isShopping = YES;
//            shoppingMallVC.viewTitle = @"自在商城";
//            [self.navigationController pushViewController:shoppingMallVC animated:YES];
//        }else if(indexPath.row == 1){
//            //积分兑换
//            ZZTShoppingMallViewController *shoppingMallVC = [[ZZTShoppingMallViewController alloc] init];
//            shoppingMallVC.hidesBottomBarWhenPushed = YES;
//            shoppingMallVC.isShopping = YES;
//            shoppingMallVC.viewTitle = @"积分兑换";
//            [self.navigationController pushViewController:shoppingMallVC animated:YES];
//        }
//    }else if (indexPath.section == 3){
////        if(indexPath.row == 0){
////            ZZTCartoonViewController *bookVC = [[ZZTCartoonViewController alloc] init];
////            bookVC.hidesBottomBarWhenPushed = YES;
////            bookVC.viewTitle = @"参与作品";
////            bookVC.viewType = @"1";
//////            bookVC.user = self.userData;
////            [self.navigationController pushViewController:bookVC animated:YES];
////        }else
//        if(indexPath.row == 0){
//            //书柜
//            ZZTCartoonViewController *bookVC = [[ZZTCartoonViewController alloc] init];
//            bookVC.hidesBottomBarWhenPushed = YES;
//            bookVC.viewTitle = @"书柜";
//            bookVC.viewType = @"2";
////            bookVC.user = self.userData;
//            [self.navigationController pushViewController:bookVC animated:YES];
//        }else if(indexPath.row == 1){
//            //关注
//            ZZTMeAttentionViewController *meAttentionVC = [[ZZTMeAttentionViewController alloc] init];
//            meAttentionVC.hidesBottomBarWhenPushed = YES;
////            meAttentionVC.user = self.userData;
//            [self.navigationController pushViewController:meAttentionVC animated:YES];
//        }else if(indexPath.row == 2){
//            //浏览历史
//            ZZTHistoryViewController *historyVC = [[ZZTHistoryViewController alloc] init];
//            historyVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:historyVC animated:YES];
//        }
//    }else if(indexPath.section == 4){
//        //设置
//        ZZTSettingViewController *settingVC = [[ZZTSettingViewController alloc] init];
//        settingVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:settingVC animated:YES];
//    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [self.navigationController.navigationBar setTranslucent:NO];

}
@end
