//
//  ZZTMeHomeViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/21.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTMeHomeViewController.h"
#import "ZZTMeViewController.h"
#import "ZZTMyZoneViewController.h"
#import "ZZTMeWalletViewController.h"
#import "ZZTVIPViewController.h"
#import "ImageClipViewController.h"
#import "ZZTChapterPayViewController.h"
#import "ZZTCreatCartoonViewController.h"

@interface ZZTMeHomeViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) ZZTMyZoneViewController *zoneVC;
@property (nonatomic,strong) ZZTMeViewController *meVC;
@property (nonatomic,strong) UIScrollView *mainView;
@property (nonatomic,strong) ZZTNavBarTitleView *titleView;
@property (nonatomic,strong) UIButton *mommentBtn;

@end

@implementation ZZTMeHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置主视图
    [self setupMainView];
    //设置子页
    [self setupChildView];
    //设置nav
    [self setupNavbar];
}

#pragma mark - 设置主视图
- (void)setupMainView {
    
    UIScrollView *mainView = [[UIScrollView alloc] init];
    //1.是否有弹簧效果
    mainView.bounces = NO;
    //整页平移是否开启
    mainView.pagingEnabled = YES;
    //显示水平滚动条
    mainView.showsHorizontalScrollIndicator = NO;
    //显示垂直滚动条
    mainView.showsVerticalScrollIndicator = NO;
    
    mainView.delegate = self;
    
    [self.view addSubview:mainView];
    
    self.mainView = mainView;
}

#pragma mark - 设置滚动视图
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat height = self.view.height  - navHeight +20;
    CGFloat width  = self.view.width;
    
    //主页的位置
    [self.mainView setFrame:CGRectMake(0,0,width,height)];
    //    self.mainView.contentSize  = CGSizeMake(width * 3, 0);
    //    [self.mainView setFrame:CGRectMake(width,0,width,height)];
    self.mainView.contentSize  = CGSizeMake(width * 2, 0);
    
    [_zoneVC.view setFrame:CGRectMake(width, 0, width, height)];
    [_meVC.view setFrame:CGRectMake(0, 0, width, height)];
    
    [self.mainView setContentOffset:CGPointMake(0, 0)];
}


-(void)setupChildView{
    //添加子页
    ZZTMeViewController *meVC = [[ZZTMeViewController alloc] init];
    [self addChildViewController:meVC];
    _meVC = meVC;
    [self.mainView addSubview:meVC.view];
    //每次进来的时候就要看一下数据 刷新一下
//    ZZTMyZoneViewController *zoneVC = [[ZZTMyZoneViewController alloc] init];
//    zoneVC.userId = [UserInfoManager share].ID;
//    zoneVC.viewNavBarHidden = YES;
////    zoneVC.
//    [self addChildViewController:zoneVC];
    [self.mainView addSubview:self.zoneVC.view];
//    _zoneVC = zoneVC;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(ZZTMyZoneViewController *)zoneVC{
    if(!_zoneVC){
        _zoneVC = [[ZZTMyZoneViewController alloc] init];
        _zoneVC.viewNavBarHidden = YES;
        [self addChildViewController:_zoneVC];
    }
    return _zoneVC;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _zoneVC.userId = [UserInfoManager share].ID;
    //电池白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

-(void)setupNavbar{
    
    ZZTNavBarTitleView *titleView = [[ZZTNavBarTitleView alloc] init];
    titleView.selBtnTextColor = ZZTSubColor;
    titleView.selBtnBackgroundColor = [UIColor whiteColor];
    titleView.btnTextColor = [UIColor whiteColor];
    titleView.btnBackgroundColor = [UIColor clearColor];
    titleView.backgroundColor = [UIColor colorWithHexString:@"#262626" alpha:0.8];
    _titleView = titleView;
    [titleView.leftBtn setTitle:@"账户" forState:UIControlStateNormal];
    [titleView.rightBtn setTitle:@"空间" forState:UIControlStateNormal];
    
    titleView.leftBtn.tag = 0;
    titleView.rightBtn.tag = 1;
    
    [titleView.leftBtn addTarget:self action:@selector(clickMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    [titleView.rightBtn addTarget:self action:@selector(clickMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    [self clickMenu:titleView.leftBtn];
    
    [self.view bringSubviewToFront:self.viewNavBar];
    
    //中间
    [self.viewNavBar.mainView addSubview:titleView];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.viewNavBar.mainView);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.34);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(self.viewNavBar.rightButton.mas_centerY);
    }];
    
    self.viewNavBar.showBottomLabel = NO;
    
    //主页
    //充值(左)
    [self.viewNavBar.leftButton setImage:[UIImage imageNamed:@"me_topUpBtn"] forState:UIControlStateNormal];
    [self.viewNavBar.leftButton addTarget:self action:@selector(gotoTopupView) forControlEvents:UIControlEventTouchUpInside];
    //空间按钮
    //瞬间(左)
    UIButton *mommentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mommentBtn.hidden = YES;
    _mommentBtn = mommentBtn;
    [mommentBtn setImage:[UIImage imageNamed:@"me_momentBtn"] forState:UIControlStateNormal];
    [self.viewNavBar addSubview:mommentBtn];

    [mommentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewNavBar.leftButton.mas_top);
        make.right.equalTo(self.viewNavBar.leftButton.mas_right);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(40);
    }];
    
    self.viewNavBar.backgroundColor = [UIColor clearColor];
    
    //消息(通用 右)
    [self.viewNavBar.rightButton setImage:[UIImage imageNamed:@"me_messageBtn"] forState:UIControlStateNormal];
    [self.viewNavBar.rightButton addTarget:self action:@selector(gotoVipView) forControlEvents:UIControlEventTouchUpInside];

//    self.viewNavBar.rightButton.hidden = YES;
//    self.viewNavBar.leftButton.hidden = YES;

}

-(void)gotoVipView{
    ZZTEditorCartoonViewController *ecVC = [[ZZTEditorCartoonViewController alloc] init];
    ecVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:ecVC animated:YES];
//    ZZTChapterPayViewController *CPVC = [[ZZTChapterPayViewController alloc] init];
//    ZZTNavigationViewController *nav = [[ZZTNavigationViewController alloc] initWithRootViewController:CPVC];
//    nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    [self presentViewController:nav animated:YES completion:nil];
}

-(void)gotoTopupView{
    //钱包
//    ZZTMeWalletViewController *walletVC = [[ZZTMeWalletViewController alloc] init];
//    walletVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:walletVC animated:YES];
    
    ZZTCreatCartoonViewController *walletVC = [[ZZTCreatCartoonViewController alloc] init];
    walletVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:walletVC animated:YES];
}

//滑动展示清空按钮
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(CGPointEqualToPoint(scrollView.contentOffset, CGPointMake(SCREEN_WIDTH, 0))){
        //zone
        [self showZoneView];
    }else{
        //首页
        [self showHomeView];
    }
}

-(void)showHomeView{

    self.viewNavBar.leftButton.hidden = NO;
    self.mommentBtn.hidden = YES;
    [self.titleView selectBtn:self.titleView.leftBtn];
}

-(void)showZoneView{

    self.viewNavBar.leftButton.hidden = YES;
    self.mommentBtn.hidden = YES;
    [self.titleView selectBtn:self.titleView.rightBtn];
}

-(void)clickMenu:(UIButton *)btn{
    // 取出选中的这个控制器
    if(btn.tag == 0){
        [self.mainView setContentOffset:CGPointMake(0, 0) animated:YES];
        [self showHomeView];
        [self.titleView selectBtn:btn];
    }else{
        [self.mainView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
        [self.titleView selectBtn:btn];
        [self showZoneView];
    }
}
@end
