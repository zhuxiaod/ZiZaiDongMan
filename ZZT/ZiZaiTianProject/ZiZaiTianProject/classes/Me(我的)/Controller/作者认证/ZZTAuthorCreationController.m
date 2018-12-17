//
//  ZZTAuthorCreationController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/14.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTAuthorCreationController.h"
#import "ZZTAuthorBookRoomViewController.h"
#import "ZZTAuthorDraftViewController.h"

@interface ZZTAuthorCreationController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *mainView;

@property (nonatomic,strong) ZZTAuthorBookRoomViewController *authorBookRoomVC;

@property (nonatomic,strong) ZZTAuthorDraftViewController *authorDraftVC;

@property (nonatomic,strong) ZZTNavBarTitleView *titleView;

@end

@implementation ZZTAuthorCreationController

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
    CGFloat height = self.view.height;
    CGFloat width  = self.view.width;
    
    //主页的位置
    [self.mainView setFrame:CGRectMake(0,0,width,height)];
    //    self.mainView.contentSize  = CGSizeMake(width * 3, 0);
    //    [self.mainView setFrame:CGRectMake(width,0,width,height)];
    self.mainView.contentSize  = CGSizeMake(width * 2, 0);
    
    [_authorDraftVC.view setFrame:CGRectMake(width, 0, width, height)];
    [_authorBookRoomVC.view setFrame:CGRectMake(0, 0, width, height)];
    
    [self.mainView setContentOffset:CGPointMake(0, 0)];
}

-(void)setupChildView{
    //添加子页
    ZZTAuthorBookRoomViewController *authorBookRoomVC = [[ZZTAuthorBookRoomViewController alloc] init];
    [self addChildViewController:authorBookRoomVC];
    _authorBookRoomVC = authorBookRoomVC;
    [self.mainView addSubview:authorBookRoomVC.view];
    //每次进来的时候就要看一下数据 刷新一下
    ZZTAuthorDraftViewController *authorDraftVC = [[ZZTAuthorDraftViewController alloc] init];
    [self addChildViewController:authorDraftVC];
    _authorDraftVC = authorDraftVC;
    [self.mainView addSubview:self.authorDraftVC.view];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)setupNavbar{
    
    ZZTNavBarTitleView *titleView = [[ZZTNavBarTitleView alloc] init];
    titleView.selBtnTextColor = ZZTSubColor;
    titleView.selBtnBackgroundColor = [UIColor whiteColor];
    titleView.btnTextColor = [UIColor whiteColor];
    titleView.btnBackgroundColor = [UIColor clearColor];
    titleView.backgroundColor = [UIColor colorWithHexString:@"#262626" alpha:0.8];
    _titleView = titleView;
    [titleView.leftBtn setTitle:@"书库" forState:UIControlStateNormal];
    [titleView.rightBtn setTitle:@"草稿" forState:UIControlStateNormal];
    
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
    
    //返回
    [self.viewNavBar.leftButton setImage:[UIImage imageNamed:@"blackBack"] forState:UIControlStateNormal];
    [self.viewNavBar.leftButton addTarget:self action:@selector(backLastView) forControlEvents:UIControlEventTouchUpInside];
}

-(void)backLastView{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)clickMenu:(UIButton *)btn{
    // 取出选中的这个控制器
    if(btn.tag == 0){
        [self.mainView setContentOffset:CGPointMake(0, 0) animated:YES];
//        [self showHomeView];
        [self.titleView selectBtn:btn];
    }else{
        [self.mainView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
        [self.titleView selectBtn:btn];
//        [self showZoneView];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //电池黑
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    //电池白
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//
//}

//滑动展示清空按钮
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(CGPointEqualToPoint(scrollView.contentOffset, CGPointMake(SCREEN_WIDTH, 0))){
        [self.titleView selectBtn:self.titleView.rightBtn];
    }else{

        [self.titleView selectBtn:self.titleView.leftBtn];
    }
}
@end
