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
#import "ZZTCreationTableView.h"
#import "PYSearchSuggestionViewController.h"
#import "ZZTCarttonDetailModel.h"
#import "ZZTUpdateViewController.h"
#import "ZZTCollectView.h"
#import "ZZTReadHomeViewController.h"
#import "ZZTCollectHomeViewController.h"

@interface ZZTHomeViewController ()<UIScrollViewDelegate,PYSearchViewControllerDelegate,PYSearchViewControllerDataSource,UITableViewDataSource,UITabBarControllerDelegate,ListViewDelegate>

@property (nonatomic,weak) UIView *customNavBar;
//@property (nonatomic,weak) ListView *listView;
@property (nonatomic,weak) ZZTReadHomeViewController *ReadView;
@property (nonatomic,weak) ZZTCreationTableView *CreationView;
@property (nonatomic,weak) ZZTCollectHomeViewController *collectView;

@property (nonatomic,weak) ZZTCycleCell *cycleCell;
//@property (nonatomic,weak) UIScrollView *mainView;
@property (nonatomic,strong) NSMutableArray *searchSuggestionArray;
@property (nonatomic,weak) UITableView *suggestionView;
@property (nonatomic,weak) PYSearchViewController *searchVC;
@property (nonatomic,strong) NSString *str;
@property (nonatomic,strong) NSMutableArray *bookShelfArray;
@property (nonatomic,strong) NSMutableArray *cartoonArray;
@property (nonatomic,strong) ZZTRemindView *remindView;
//导航条
@property (nonatomic,strong) ZXDNavBar *navBar;
//titleView
@property (nonatomic,strong) ZZTNavBarTitleView *titleView;

@end
NSString *SuggestionView = @"SuggestionView";

@implementation ZZTHomeViewController

-(NSMutableArray *)bookShelfArray{
    if(!_bookShelfArray){
        _bookShelfArray = [NSMutableArray array];
    }
    return _bookShelfArray;
}

-(NSMutableArray *)cartoonArray{
    if(!_cartoonArray){
        _cartoonArray = [NSMutableArray array];
    }
    return _cartoonArray;
}

-(NSMutableArray *)searchSuggestionArray{
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

#pragma mark - 设置添加滚动子页
-(void)setupChildView{
    //阅读页
    ZZTReadHomeViewController *readVC = [[ZZTReadHomeViewController alloc] init];
//    ZZTReadTableView *readVC = [[ZZTReadTableView alloc] init];
//    readVC.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
//    readVC.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:readVC];
    self.ReadView = readVC;
    [self.mainView addSubview:readVC.view];
    
//    //创作页
//    ZZTCreationTableView *creationVC = [[ZZTCreationTableView alloc] init];
////    ZZTCreationTableView *creationVC = [[ZZTCreationTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    self.CreationView = creationVC;
//    creationVC.backgroundColor = [UIColor whiteColor];
//    [self.mainView addSubview:creationVC];
    
    //书柜
    //直接在该页面创建一个collectionView
////    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    ZZTCollectHomeViewController *collectVC = [[ZZTCollectHomeViewController alloc] init];
//    collectVC.backgroundColor = [UIColor whiteColor];
    self.collectView = collectVC;
    [self addChildViewController:readVC];
    [self.mainView addSubview:collectVC.view];
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    
    //提前加载
//    [_CreationView setFrame:CGRectMake(0, 0, width, height)];
//    [_ReadView setFrame:CGRectMake(width, 0, width, height)];
//    [_collectView setFrame:CGRectMake(width * 2, 0, width, height)];
    
    [_collectView.view setFrame:CGRectMake(width, 0, width, height)];
    [_ReadView.view setFrame:CGRectMake(0, 0, width, height)];

    //添加视图的时候会刷新一次
    if([_str isEqualToString:@"YES"]){
        [self.mainView setContentOffset:CGPointMake(0, 0)];

    }else{
        //确定进去的时候在哪里
//        [self.mainView setContentOffset:CGPointMake(width, 0)];
         [self.mainView setContentOffset:CGPointMake(0, 0)];
    }
}

//Bar隐藏
//计时器开始
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //反正是一个页面一起跑页没什么不好吧
    //cell 还没有创建故不能在这里搞
//    [_ReadView reloadData];
    
//    [self loadBookShelfData];
    
    NSLog(@"width:%f",SCREEN_WIDTH );
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.navigationController.navigationBar.alpha = 0;
    
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}
//计时器结束
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //可以控制定时关闭
    NSNotification *notification = [NSNotification notificationWithName:@"tongzhi" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma mark - 设置导航条
-(void)setupNavBar
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
    
    //跳转不同的页面
//    [self clickMenu:titleView.leftBtn];
    
    ZXDNavBar *navBar = [[ZXDNavBar alloc] init];
    _navBar = navBar;
    navBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:navBar];
    
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@(navHeight));
    }];
    
    //返回
    [navBar.leftButton setImage:[UIImage imageNamed:@"Home_readHistory"] forState:UIControlStateNormal];
    navBar.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 17);
//    [navBar.leftButton addTarget:self action:@selector(addMoment) forControlEvents:UIControlEventTouchUpInside];
    
    [navBar.rightButton setImage:[UIImage imageNamed:@"Home_search"] forState:UIControlStateNormal];
    navBar.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -33);
    [navBar.rightButton addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
    
    //中间
    [navBar.mainView addSubview:titleView];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(navBar.mainView);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.34);
        make.height.mas_equalTo(30);
        make.bottom.equalTo(navBar.mainView).offset(-10);
    }];
    
    navBar.showBottomLabel = NO;
}

-(void)clickMenu:(UIButton *)btn{
    if(btn.tag == 0){
        [self.mainView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        [self.mainView setContentOffset:CGPointMake(ScreenW, 0) animated:YES];
    }
}

//更新
-(void)history{
    ZZTUpdateViewController *updateVC = [[ZZTUpdateViewController alloc] init];
    updateVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:updateVC animated:YES];
}

//滑动展示清空按钮
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(CGPointEqualToPoint(scrollView.contentOffset, CGPointMake(ScreenW, 0))){
        //显示删除
        self.navBar.leftButton.hidden = YES;
        self.navBar.rightButton.imageView.image = [UIImage imageNamed:@"Home_removeBook"];
        [self.navBar.rightButton removeTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
        [self.navBar.rightButton addTarget:self  action:@selector(removeAllBook) forControlEvents:UIControlEventTouchUpInside];
        [scrollView setContentOffset:CGPointMake(ScreenW, 0)];
        [self.titleView selectBtn:self.titleView.rightBtn];
    }else{
        //显示搜索
        self.navBar.leftButton.hidden = NO;
        self.navigationItem.leftBarButtonItem.customView.hidden = NO;
        self.navBar.rightButton.imageView.image = [UIImage imageNamed:@"search"];
        [self.navBar.rightButton removeTarget:self action:@selector(removeAllBook) forControlEvents:UIControlEventTouchUpInside];
        [self.navBar.rightButton addTarget:self  action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
        [self.titleView selectBtn:self.titleView.leftBtn];
    }
}
                                                 
-(void)removeAllBook{
    [self.remindView removeFromSuperview];
    ZZTRemindView *remindView = [[ZZTRemindView alloc] initWithFrame:CGRectMake(ScreenW, 0, ScreenW, ScreenH)];
    self.remindView = remindView;
    remindView.viewTitle = @"是否清空?";
    remindView.btnBlock = ^(UIButton *btn) {
        NSString *string = [self.cartoonArray componentsJoinedByString:@","];
        if(self.cartoonArray.count){
            [self loadRemoveBook:string];
        }
    };
    [self.mainView addSubview:remindView];
}

-(void)loadRemoveBook:(NSString *)string{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];

    UserInfo *user = [Utilities GetNSUserDefaults];
    NSDictionary *dic = @{
                          @"userId":[NSString stringWithFormat:@"%ld",user.id],
                          @"cartoonId":string
                          };
    [manager POST:[ZZTAPI stringByAppendingString:@"great/delCollect"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [self loadBookShelfData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)dealloc{
    NSLog(@"我走了");
}

-(void)search{

    //设置热词
    NSArray *hotSeaches = @[@"妖神记", @"大霹雳", @"镖人", @"偷星九月天"];

    PYSearchViewController *searchVC = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"搜索作品名、作者名、社区内容" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        
    }];
    searchVC.hotSearchTitle = @"热门搜索";
    searchVC.delegate = self;
    searchVC.dataSource = self;

    //set cancelButton
    [searchVC.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [searchVC.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    ZZTNavigationViewController *nav = [[ZZTNavigationViewController alloc] initWithRootViewController:searchVC];
    [self presentViewController:nav animated:YES completion:nil];
    _searchVC = searchVC;
}

//搜索文字已经改变
#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    if (searchText.length) {
        weakself(self);
        NSDictionary *dic = @{
                              @"fuzzy":searchText
                              };
        //添加数据
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];

        [manager POST:[ZZTAPI stringByAppendingString:@"cartoon/queryFuzzy"]  parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [[EncryptionTools sharedEncryptionTools] decry:responseObject[@"result"]];
            NSMutableArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic];
            weakSelf.searchSuggestionArray = array;
            [searchViewController.searchSuggestionView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];

    }
}
-(NSInteger)numberOfSectionsInSearchSuggestionView:(UITableView *)searchSuggestionView{
    return 1;
}

-(NSInteger)searchSuggestionView:(UITableView *)searchSuggestionView numberOfRowsInSection:(NSInteger)section{
    return self.searchSuggestionArray.count;
}

-(UITableViewCell *)searchSuggestionView:(UITableView *)searchSuggestionView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [searchSuggestionView dequeueReusableCellWithIdentifier:SuggestionView];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SuggestionView];
    }
    if(self.searchSuggestionArray.count > 0){
        ZZTCarttonDetailModel *str = self.searchSuggestionArray[indexPath.row];
        cell.textLabel.text = str.bookName;
    }
    return cell;
}

- (CGFloat)searchSuggestionView:(UITableView *)searchSuggestionView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f;
}



////加载数据
//-(void)loadBookShelfData{
//    UserInfo *user = [Utilities GetNSUserDefaults];
//    NSDictionary *dic = @{
//                          @"userId":[NSString stringWithFormat:@"%ld",user.id]
//                          };
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
//    EncryptionTools *tool = [[EncryptionTools alloc]init];
//    [manager POST:[ZZTAPI stringByAppendingString:@"great/userCollect"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dic = [tool decry:responseObject[@"result"]];
//        NSMutableArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic];
//        //        NSMutableArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic];
//        self.bookShelfArray = array;
//        [self addCartoonId:array];
//        self.collectView.dataArray = array;
//        //        [self.collectionView reloadData];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
//}

-(void)addCartoonId:(NSMutableArray *)array{
    NSMutableArray *cartoonArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        ZZTCarttonDetailModel *model = array[i];
        [cartoonArray addObject:model.cartoonId];
    }
    self.cartoonArray = cartoonArray;
}

-(void)receiveNotification:(NSNotification *)infoNotification {
    NSDictionary *dic = [infoNotification userInfo];
    _str = [dic objectForKey:@"info"];
}
@end
