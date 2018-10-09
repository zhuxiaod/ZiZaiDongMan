//
//  ZZTHomeViewController.m
//  ZiZaiTianProject
//
//  Created by zxd on 2018/6/24.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTHomeViewController.h"
#import "CommonMacro.h"
#import "ListView.h"
#import "ZZTReadTableView.h"
#import "ZZTCycleCell.h"
#import "ZZTEasyBtnModel.h"
#import "ZZTCreationTableView.h"
#import "PYSearchSuggestionViewController.h"
#import "ZZTCarttonDetailModel.h"
#import "ZZTUpdateViewController.h"
#import "ZZTCollectView.h"
@interface ZZTHomeViewController ()<UIScrollViewDelegate,PYSearchViewControllerDelegate,PYSearchViewControllerDataSource,UITableViewDataSource,UITabBarControllerDelegate>

@property (nonatomic,weak) UIView *customNavBar;
@property (nonatomic,weak) ListView *listView;
@property (nonatomic,weak) ZZTReadTableView *ReadView;
@property (nonatomic,weak) ZZTCreationTableView *CreationView;
@property (nonatomic,weak) ZZTCollectView *collectView;

@property (nonatomic,weak) ZZTCycleCell * cycleCell;
//@property (nonatomic,weak) UIScrollView *mainView;
@property (nonatomic,strong) NSMutableArray *searchSuggestionArray;
@property (nonatomic,weak) UITableView *suggestionView;
@property (nonatomic,weak) PYSearchViewController *searchVC;
@property (nonatomic,strong) NSString *str;
@property (nonatomic,strong) NSMutableArray *bookShelfArray;
@property (nonatomic,strong) NSMutableArray *cartoonArray;
@property (nonatomic,strong) ZZTRemindView *remindView;
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
    [self loadBookShelfData];
    //设置nav样式
    [self setupNavgationStyle:self.navigationController];
    //设置Bar
    [self setupNavBar];
    
    //设置主视图
    [self setupMainView];
    
    //自定义listView
    [self setupListView];
    
    //设置子页
    [self setupChildView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"infoNotification" object:nil];
    
    //设置tabbar点击
    self.tabBarController.delegate = self;
    
    self.navigationController.fd_prefersNavigationBarHidden = YES;

}

-(void)loadBookShelfData{
    UserInfo *user = [Utilities GetNSUserDefaults];
    NSDictionary *dic = @{
                          @"userId":[NSString stringWithFormat:@"%ld",user.id]
                          };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    EncryptionTools *tool = [[EncryptionTools alloc]init];
    [manager POST:[ZZTAPI stringByAppendingString:@"great/userCollect"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [tool decry:responseObject[@"result"]];
        NSMutableArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic];
        //        NSMutableArray *array = [ZZTCarttonDetailModel mj_objectArrayWithKeyValuesArray:dic];
        self.bookShelfArray = array;
        [self addCartoonId:array];
        self.collectView.dataArray = array;
//        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)addCartoonId:(NSMutableArray *)array{
    NSMutableArray *cartoonArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        ZZTCarttonDetailModel *model = array[i];
        [cartoonArray addObject:model.cartoonId];
    }
    self.cartoonArray = cartoonArray;
}

-(void)setupNavgationStyle:(UINavigationController *)nav{
    UIImage *image = [UIImage imageNamed:@"APP架构-作品-顶部渐变条-IOS"];
    // 设置左边端盖宽度
    NSInteger leftCapWidth = image.size.width * 0.5;
    // 设置上边端盖高度
    NSInteger topCapHeight = image.size.height * 0.5;
    UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    [nav.navigationBar setBackgroundImage:newImage forBarMetrics:UIBarMetricsDefault];
}

-(void)receiveNotification:(NSNotification *)infoNotification {
    NSDictionary *dic = [infoNotification userInfo];
    _str = [dic objectForKey:@"info"];
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

#pragma mark - 设置ListView
- (void)setupListView {
    //设置自动调整滚动视图
    [self setAutomaticallyAdjustsScrollViewInsets:NO];

//    NSArray *textArray = @[@"创作",@"阅读",@"书柜"];
    NSArray *textArray = @[@"阅读",@"书柜"];
    
    //0.66 默认
    CGFloat listViewWidth    = self.view.width * 0.5;
    CGFloat listViewItemSize = (listViewWidth - SPACEING * 2)/textArray.count;
    
    ListViewConfiguration *lc = [ListViewConfiguration new];
    //设置动画
    lc.hasSelectAnimate = YES;
    //选择时的颜色
    lc.labelSelectTextColor = [UIColor whiteColor];
    lc.labelTextColor = [UIColor colorWithHexString:@"#0D2882"];
    lc.font       = [UIFont systemFontOfSize:14];
    lc.spaceing   = SPACEING;
    lc.labelWidth = listViewItemSize;
    lc.monitorScrollView = self.mainView;
    
    ListView *listView = [[ListView alloc] initWithFrame:CGRectMake(0,0,listViewWidth,44) TextArray:textArray Configuration:lc];
    //重点！！！
    self.navigationItem.titleView = listView;
    //全局
    self.listView = listView;
}

#pragma mark - 设置添加滚动子页
-(void)setupChildView{
    //阅读页
    ZZTReadTableView *readVC = [[ZZTReadTableView alloc] init];
    readVC.backgroundColor = [UIColor whiteColor];
    self.ReadView = readVC;
    [self.mainView addSubview:readVC];
    
//    //创作页
//    ZZTCreationTableView *creationVC = [[ZZTCreationTableView alloc] init];
////    ZZTCreationTableView *creationVC = [[ZZTCreationTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    self.CreationView = creationVC;
//    creationVC.backgroundColor = [UIColor whiteColor];
//    [self.mainView addSubview:creationVC];
    
    //书柜
    //直接在该页面创建一个collectionView
////    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    ZZTCollectView *collectVC = [[ZZTCollectView alloc] init];
    collectVC.backgroundColor = [UIColor whiteColor];
    self.collectView = collectVC;
    [self.mainView addSubview:collectVC];
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
    
    [_collectView setFrame:CGRectMake(width, 0, width, height)];
    [_ReadView setFrame:CGRectMake(0, 0, width, height)];

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
    [_ReadView reloadData];
    [self loadBookShelfData];

//    [_collectView reloadData];
//    [_CreationView reloadData];
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
    //右边导航条
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"search"] highImage:[UIImage imageNamed:@"search"] target:self action:@selector(search)];
    //左边导航条
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"time"] highImage:[UIImage imageNamed:@"time"] target:self action:@selector(history)];
}
//更新
-(void)history{
    ZZTUpdateViewController *updateVC = [[ZZTUpdateViewController alloc] init];
    updateVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:updateVC animated:YES];
}

//滑动展示清空按钮
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSLog(@"%@:",NSStringFromCGPoint(scrollView.contentOffset));
    if(CGPointEqualToPoint(scrollView.contentOffset, CGPointMake(ScreenW, 0))){
        //书柜
        self.navigationItem.leftBarButtonItem.customView.hidden = YES;
        //左边导航条
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"清空" target:self action:@selector(removeAllBook)];
        
    }else{
        //阅读
        self.navigationItem.leftBarButtonItem.customView.hidden = NO;
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"search"] highImage:[UIImage imageNamed:@"search"] target:self action:@selector(search)];
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
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    UserInfo *user = [Utilities GetNSUserDefaults];
    NSDictionary *dic = @{
                          @"userId":[NSString stringWithFormat:@"%ld",user.id],
                          @"cartoonId":string
                          };
    [manager POST:[ZZTAPI stringByAppendingString:@"great/delCollect"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self loadBookShelfData];
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
    [self setupNavgationStyle:nav];
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
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
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

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if(tabBarController.selectedIndex == 0 ){
//        [self setupNavgationStyle];
    }
}


@end
