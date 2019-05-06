//
//  ZZTHomeViewController.m
//  ZiZaiTianProject
//
//  Created by zxd on 2018/6/24.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTHomeViewController.h"
//#import "CommonMacro.h"
#import "ListView.h"
#import "ZZTReadTableView.h"
#import "ZZTCycleCell.h"
#import "ZZTEasyBtnModel.h"
#import "PYSearchSuggestionViewController.h"
#import "ZZTCarttonDetailModel.h"
#import "ZZTUpdateViewController.h"
#import "ZZTCollectView.h"
#import "ZZTReadHomeViewController.h"
#import "ZZTCollectHomeViewController.h"
#import "ZZTCartoonHeaderView.h"

//search
#import "ZZTSearchCartoonCell.h"
#import "ZZTSearchZoneCell.h"
#import "ZXDSearchViewController.h"

static NSString *findCommentCell = @"findCommentCell";

@interface ZZTHomeViewController ()<UIScrollViewDelegate,PYSearchViewControllerDelegate,PYSearchViewControllerDataSource,UITableViewDataSource,UITabBarControllerDelegate,ListViewDelegate>

@property (nonatomic,weak) UIView *customNavBar;
//@property (nonatomic,weak) ListView *listView;
@property (nonatomic,weak) ZZTReadHomeViewController *ReadView;
@property (nonatomic,weak) ZZTCollectHomeViewController *collectView;
@property (nonatomic,weak) ZZTCycleCell *cycleCell;
//@property (nonatomic,weak) UIScrollView *mainView;
@property (nonatomic,strong) NSMutableArray *searchSuggestionArray;
@property (nonatomic,weak) UITableView *suggestionView;
@property (nonatomic,weak) PYSearchViewController *searchVC;
@property (nonatomic,strong) NSString *str;
@property (nonatomic,strong) NSMutableArray *bookShelfArray;
@property (nonatomic,strong) NSMutableArray *cartoonArray;
@property (nonatomic,weak) ZZTRemindView *remindView;
//导航条
//@property (nonatomic,weak) ZXDNavBar *navBar;
//titleView
@property (nonatomic,weak) ZZTNavBarTitleView *titleView;

@property (nonatomic,weak) UIButton *deleteBtn;

@end

NSString *SuggestionView = @"SuggestionView";

@implementation ZZTHomeViewController

- (NSMutableArray *)bookShelfArray{
    if(!_bookShelfArray){
        _bookShelfArray = [NSMutableArray array];
    }
    return _bookShelfArray;
}

- (NSMutableArray *)cartoonArray{
    if(!_cartoonArray){
        _cartoonArray = [NSMutableArray array];
    }
    return _cartoonArray;
}

- (NSMutableArray *)searchSuggestionArray{
    if(!_searchSuggestionArray){
        _searchSuggestionArray = [NSMutableArray array];
    }
    return _searchSuggestionArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self loadBookShelfData];
    //设置Bar
    self.fd_prefersNavigationBarHidden = YES;

    //设置主视图
    [self setupMainView];
    
    //自定义listView
//    [self setupListView];
    
    //设置子页
    [self setupChildView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"infoNotification" object:nil];
    
    //设置tabbar点击
    self.tabBarController.delegate = self;
    
    self.navigationController.navigationBar.alpha = 0;

    //设置navBar
    [self setupNavBar];
    
    [self getLoginStatus];

}

#pragma mark - 设置主视图
- (void)setupMainView {
    
    UIScrollView *mainView = [[UIScrollView alloc] init];
    //主页的位置
    [mainView setFrame:CGRectMake(0,0,ScreenW,ScreenH - navHeight + 20)];
    mainView.contentSize  = CGSizeMake(ScreenW * 2, 0);
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

#pragma mark - 设置添加滚动子页
- (void)setupChildView{
    
    CGFloat height = self.view.height  - navHeight + 20;
    CGFloat width  = self.view.width;
    
    //阅读页
    ZZTReadHomeViewController *readVC = [[ZZTReadHomeViewController alloc] init];

    [readVC.view setFrame:CGRectMake(0, 0, width, height)];

    [self addChildViewController:readVC];
    self.ReadView = readVC;
    [self.mainView addSubview:readVC.view];

    ZZTCollectHomeViewController *collectVC = [[ZZTCollectHomeViewController alloc] init];
    self.collectView = collectVC;
    [self addChildViewController:collectVC];
    [self.mainView addSubview:collectVC.view];
    [_collectView.view setFrame:CGRectMake(width, 0, width, height)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

#pragma mark - 设置滚动视图
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    //添加视图的时候会刷新一次
    if([_str isEqualToString:@"YES"]){
        [self.mainView setContentOffset:CGPointMake(0, 0)];

    }else{

         [_mainView setContentOffset:CGPointMake(0, 0)];
    }
}

//Bar隐藏
//计时器开始
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    self.navigationController.navigationBar.alpha = 0;
    
}

//计时器结束
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //可以控制定时关闭
    NSNotification *notification = [NSNotification notificationWithName:@"tongzhi" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma mark - 设置导航条
- (void)setupNavBar
{
    //设置新的导航条
    ZZTNavBarTitleView *titleView = [[ZZTNavBarTitleView alloc] init];
    _titleView = titleView;
    titleView.selBtnTextColor = ZZTSubColor;
    titleView.selBtnBackgroundColor = [UIColor whiteColor];
    titleView.btnTextColor = [UIColor whiteColor];
    titleView.btnBackgroundColor = [UIColor clearColor];
    titleView.backgroundColor = [UIColor colorWithHexString:@"#262626" alpha:0.8];
    
    [titleView.leftBtn setTitle:@"书库" forState:UIControlStateNormal];
    [titleView.rightBtn setTitle:@"书柜" forState:UIControlStateNormal];
    
    titleView.leftBtn.tag = 0;
    titleView.rightBtn.tag = 1;
    
    [titleView.leftBtn addTarget:self action:@selector(clickMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    [titleView.rightBtn addTarget:self action:@selector(clickMenu:) forControlEvents:UIControlEventTouchUpInside];
    
//    ZXDNavBar *navBar = [[ZXDNavBar alloc] init];
//    _navBar = navBar;
    self.viewNavBar.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:navBar];
    
//    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.top.equalTo(self.view);
//        make.height.equalTo(@(navHeight));
//    }];
    
    //返回
    [self.viewNavBar.leftButton setImage:[UIImage imageNamed:@"Home_readHistory"] forState:UIControlStateNormal];
    [self.viewNavBar.leftButton addTarget:self action:@selector(history) forControlEvents:UIControlEventTouchUpInside];
//    navBar.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 17);

    //搜索
    [self.viewNavBar.rightButton setImage:[UIImage imageNamed:@"Home_search"] forState:UIControlStateNormal];
//    navBar.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, -17, 0, 0);
    [self.viewNavBar.rightButton addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
    //删除
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn = deleteBtn;
    deleteBtn.hidden = YES;
    [deleteBtn setImage:[UIImage imageNamed:@"Home_removeBook"] forState:UIControlStateNormal];
//    deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -33);
    [deleteBtn addTarget:self action:@selector(showRemindView) forControlEvents:UIControlEventTouchUpInside];
    [self.viewNavBar addSubview:deleteBtn];
    
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewNavBar.rightButton.mas_top);
        make.right.equalTo(self.viewNavBar.rightButton.mas_right);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(40);
    }];
    
    //中间
    [self.viewNavBar.mainView addSubview:titleView];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.viewNavBar.mainView);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.34);
        make.height.mas_equalTo(30);
//        make.bottom.equalTo(navBar.mainView).offset(-10);
        make.centerY.equalTo(self.viewNavBar.leftButton.mas_centerY);
    }];
    
    self.viewNavBar.showBottomLabel = NO;
}

- (void)showRemindView{
    [self.collectView showRemindView];
}

- (void)clickMenu:(UIButton *)btn{
    if(btn.tag == 0){
        [self.mainView setContentOffset:CGPointMake(0, 0) animated:YES];
        [self showHomeView];
    }else{
        //点击书柜
        [self.mainView setContentOffset:CGPointMake(ScreenW, 0) animated:YES];
        [self showDeletBtn];
    }
}

//更新
- (void)history{
    if([[UserInfoManager share] hasLogin] == YES){
        ZZTUpdateViewController *updateVC = [[ZZTUpdateViewController alloc] init];
        updateVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:updateVC animated:YES];
    }else{
        [UserInfoManager needLogin];
    }
}

//滑动展示清空按钮
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(CGPointEqualToPoint(scrollView.contentOffset, CGPointMake(ScreenW, 0))){
        //书柜
        [self showDeletBtn];
        
    }else{
        //首页
        [self showHomeView];
    }
}

- (void)showHomeView{
    //显示搜索
    self.viewNavBar.leftButton.hidden = NO;
    self.viewNavBar.rightButton.hidden = NO;
    self.deleteBtn.hidden = YES;
    [self.titleView selectBtn:self.titleView.leftBtn];
}

- (void)showDeletBtn{
    //显示删除
    self.viewNavBar.leftButton.hidden = YES;
    self.viewNavBar.rightButton.hidden = YES;
    self.deleteBtn.hidden = NO;
    [self.titleView selectBtn:self.titleView.rightBtn];
    
    [self.collectView loadData];
}


- (void)dealloc{
    NSLog(@"我走了");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)search{
    ZXDSearchViewController *searchVC = [[ZXDSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:NO];
}

- (void)receiveNotification:(NSNotification *)infoNotification {
    NSDictionary *dic = [infoNotification userInfo];
    _str = [dic objectForKey:@"info"];
}

- (void)getLoginStatus{
    UserInfo *user = [Utilities GetNSUserDefaults];
    [[UserInfoManager share] saveUserInfoWithData:user];
//    [UserInfoManager needLogin];
}

@end
