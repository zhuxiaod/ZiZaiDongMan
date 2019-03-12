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
#import "ZZTHistoryViewController.h"
#import "ZZTSettingViewController.h"
#import "ZZTMeEditViewController.h"
#import "ZZTMeWalletViewController.h"
#import "ZZTShoppingMallViewController.h"
#import "ZZTCartoonViewController.h"
#import "ZZTMeAttentionViewController.h"
#import "ZZTLoginRegisterViewController.h"
#import "ZZTMyZoneViewController.h"
#import "ZZTUserAgreementViewController.h"
#import "ZZTAboutUsViewController.h"
#import "ZZTFeedBackViewController.h"
#import "ZZTAuthorCertificationViewController.h"
#import "ZZTAuthorBookRoomViewController.h"
#import "ZZTAuthorCreationController.h"
#import "ZZTCartReleaseViewController.h"
#import "ZZTMallDetailViewController.h"
#import "ZZTMeTableModel.h"


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

//节1
@property (nonatomic,strong) NSArray *sectionOne;
//节2
@property (nonatomic,strong) NSArray *sectionTwo;
//节3
@property (nonatomic,strong) NSArray *sectionThree;

@end

@implementation ZZTMeViewController

//cell的标识
NSString *bannerID = @"MeCell";

#pragma mark - 懒加载
- (EncryptionTools *)encryptionManager{
    if(!_encryptionManager){
        _encryptionManager = [EncryptionTools alloc];
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
    
    //请求数据
//    [self getData];
    //设置table
    [self setupTab];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi)name:@"loadMeView" object:nil];
    //创建模型
    //第一节
    ZZTMeTableModel *cell1 = [ZZTMeTableModel initModelWithTitle:@"自在VIP"];
    cell1.block = ^{
        [self gotoVipVC];
    };
    
    ZZTMeTableModel *cell2 = [ZZTMeTableModel initModelWithTitle:@"作者认证"];
    cell2.block = ^{
        [self gotoAuthorCtionVC];
    };
    
    ZZTMeTableModel *cell3 = [ZZTMeTableModel initModelWithTitle:@"自在商城"];
    cell3.block = ^{
        [self gotoShoppingMallVC];
    };
    
    ZZTMeTableModel *cell4 = [ZZTMeTableModel initModelWithTitle:@"我的关注"];
    cell4.block = ^{
        [self gotoMeAttentionVC];
    };
    
    ZZTMeTableModel *cell5 = [ZZTMeTableModel initModelWithTitle:@"我的书柜"];
    cell5.block = ^{
        [self gotoBookVC];
    };
    
    ZZTMeTableModel *cell6 = [ZZTMeTableModel initModelWithTitle:@"浏览历史"];
    cell6.block = ^{
        [self gotoHistoryVC];
    };
    
    //第二节
    ZZTMeTableModel *cell7 = [ZZTMeTableModel initModelWithTitle:@"问题反馈"];
    cell7.block = ^{
        [self gotoFeedBackVC];
    };
    
    ZZTMeTableModel *cell8 = [ZZTMeTableModel initModelWithTitle:@"关于我们"];
    cell8.block = ^{
        [self gotoAboutUsVC];
    };
    
    //第三节
    ZZTMeTableModel *cell9 = [ZZTMeTableModel initModelWithTitle:@"用户协议"];
    cell9.block = ^{
        [self gotoUserAgreementVC];
    };
    
    ZZTMeTableModel *cell10 = [ZZTMeTableModel initModelWithTitle:@"设置"];
    cell10.block = ^{
        [self gotoSettingVC];
    };
    
    _sectionOne = [NSArray arrayWithObjects:cell1,cell2,cell3,cell4,cell5,cell6, nil];
//    _sectionOne = [NSArray arrayWithObjects:@"我的关注", nil];
    _sectionTwo = [NSArray arrayWithObjects:cell7,cell8, nil];
    _sectionThree = [NSArray arrayWithObjects:cell9,cell10, nil];

}

#pragma mark - 设置tableView
-(void)setupTab
{
    CGFloat tabBar = Height_TabBar;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 , self.view.bounds.size.width, self.view.bounds.size.height - tabBar) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.contentInset = UIEdgeInsetsMake(Height_TabbleViewInset, 0, 0, 0);
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
//    [self.tableView       setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
    //隐藏滚动条
    _tableView.showsVerticalScrollIndicator = NO;
    
    //添加头视图
    ZZTMeTopView *top = [[ZZTMeTopView alloc] init];
    top.frame = CGRectMake(0, 0, ScreenW, SCREEN_HEIGHT * 0.36);
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

    if(section == 0){
        return _sectionOne.count;
    }else if(section == 1){
        return _sectionTwo.count;
    }else{
        return _sectionThree.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZTMeCell *cell = [tableView dequeueReusableCellWithIdentifier:bannerID];
   
    ZZTMeTableModel *model = [[ZZTMeTableModel alloc] init];
    if(indexPath.section == 0){
        model = _sectionOne[indexPath.row];
        cell.cellCount = _sectionOne.count;
    }else if(indexPath.section == 1){
        model = _sectionTwo[indexPath.row];
        cell.cellCount = _sectionTwo.count;

    }else{
        model = _sectionThree[indexPath.row];
        cell.cellCount = _sectionThree.count;
    }
    cell.textLabel.text = model.cellTitle;
    if(indexPath.section == 0 && indexPath.row == 1 && [[Utilities GetNSUserDefaults].userType isEqualToString:@"2"]){
        cell.textLabel.text = @"作者书柜";
    }
    cell.cellIndex = indexPath.row;
    return cell;
}

#pragma mark - 请求数据
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    //隐藏Bar
    //加载用户信息
    UserInfo *userInfo = [Utilities GetNSUserDefaults];
    //游客模式
    if(userInfo == nil || [userInfo.userType isEqualToString:@"3"]){
        [[UserInfoManager share] loginVisitorModelSuccess:^{
            
            self.userData = [Utilities GetNSUserDefaults];
            
            //获取游客信息
            [self loadUserData:self.userData.id];
            
            [self setupTopView];
            
            [Utilities GetNSUserDefaults].isLogin = NO;
        }];
        
    }else{
        //userId已经有了
        [self loadUserData:userInfo.id];
        
        [Utilities GetNSUserDefaults].isLogin = YES;

    }
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}



-(void)loadUserData:(NSInteger)Id{
    
    NSString *userId = [NSString stringWithFormat:@"%ld",Id];

    NSDictionary *paramDict = @{
                                @"userId":userId
                                };
    [self.manager POST:[ZZTAPI stringByAppendingString:@"login/usersInfo"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        
        UserInfo *model = [UserInfo mj_objectWithKeyValues:dic];
        self.userData = model;
        [self setupTopView];
        //存一下数据
        [Utilities SetNSUserDefaults:model];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

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
    
    ZZTMeTableModel *model = [[ZZTMeTableModel alloc] init];
    if(indexPath.section == 0){
        model = _sectionOne[indexPath.row];
    }else if (indexPath.section == 1){
        model = _sectionTwo[indexPath.row];
    }else{
        model = _sectionThree[indexPath.row];
    }
    model.block();
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return SCREEN_HEIGHT * 0.078;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor colorWithRGB:@"232,232,232"];
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 4;
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

#pragma mark - Vip
-(void)gotoVipVC{
    ZZTVIPViewController *VIPVC = [[ZZTVIPViewController alloc] init];
    VIPVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VIPVC animated:YES];
}

#pragma mark - 作者认证
-(void)gotoAuthorCtionVC{
    //作者认证
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    if([[Utilities GetNSUserDefaults].userType isEqualToString:@"2"]){
        //作者书库
        ZZTAuthorCreationController *authorCtionVC = [[ZZTAuthorCreationController alloc] init];
        [self.navigationController pushViewController:authorCtionVC animated:YES];
    }else{
        //作者认证
        ZZTAuthorCertificationViewController *authorCerVC = [[ZZTAuthorCertificationViewController alloc] init];
        authorCerVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:authorCerVC animated:YES];
    }
}

#pragma mark - 自在商城
-(void)gotoShoppingMallVC{
    //自在商城
    ZZTShoppingMallViewController *shoppingMallVC = [[ZZTShoppingMallViewController alloc] init];
    shoppingMallVC.hidesBottomBarWhenPushed = YES;
    shoppingMallVC.isShopping = YES;
    shoppingMallVC.viewTitle = @"自在商城";
    [self.navigationController pushViewController:shoppingMallVC animated:YES];
}

#pragma mark - 我的关注
-(void)gotoMeAttentionVC{
    //关注
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    ZZTMeAttentionViewController *meAttentionVC = [[ZZTMeAttentionViewController alloc] init];
    meAttentionVC.hidesBottomBarWhenPushed = YES;
    //            meAttentionVC.user = self.userData;
    [self.navigationController pushViewController:meAttentionVC animated:YES];
}

#pragma mark - 我的书柜
-(void)gotoBookVC{
    //我的书柜
    ZZTCartoonViewController *bookVC = [[ZZTCartoonViewController alloc] init];
    bookVC.hidesBottomBarWhenPushed = YES;
    bookVC.viewTitle = @"书柜";
    bookVC.viewType = @"2";
    [self.navigationController pushViewController:bookVC animated:YES];
}

#pragma mark - 浏览历史
-(void)gotoHistoryVC{
    //浏览历史
    ZZTHistoryViewController *historyVC = [[ZZTHistoryViewController alloc] init];
    historyVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:historyVC animated:YES];
}

#pragma mark - 问题反馈
-(void)gotoFeedBackVC{
    //问题反馈
    ZZTFeedBackViewController *feedBackVC = [[ZZTFeedBackViewController alloc] init];
    feedBackVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:feedBackVC animated:YES];
}

#pragma mark - 关于我们
-(void)gotoAboutUsVC{
    //关于我们
    ZZTAboutUsViewController *aboutUsVC = [[ZZTAboutUsViewController alloc] init];
    aboutUsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aboutUsVC animated:YES];
}

#pragma mark - 用户协议
-(void)gotoUserAgreementVC{
    //用户协议
    ZZTUserAgreementViewController *userAgreementVC = [[ZZTUserAgreementViewController alloc] init];
    userAgreementVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userAgreementVC animated:YES];
}

#pragma mark - 设置
-(void)gotoSettingVC{
    //设置
    ZZTSettingViewController *settingVC = [[ZZTSettingViewController alloc] init];
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}

@end
