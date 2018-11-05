//
//  ZZTCommentViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/5.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTCommentViewController.h"
#import "ZZTNavBarTitleView.h"

#import "ZZTNewestCommentView.h"

@interface ZZTCommentViewController ()

@property (nonatomic,strong) ZXDNavBar *navbar;

@property (nonatomic,weak) UIScrollView *mainView;

@end

@implementation ZZTCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationBar];
    
    //加入中间一个swich
    
    //设置滚动两页
    [self setupMainView];
}

-(void)setupMainView{
    CGFloat mainViewHeight = self.view.height - navHeight;
    
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,navHeight, self.view.width,mainViewHeight)];
    mainView.scrollEnabled = NO;
    mainView.contentSize   = CGSizeMake(mainView.width * 2, 0);
    mainView.pagingEnabled = YES;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    
    [mainView setContentOffset:CGPointMake(0, 0)];
    
    self.mainView = mainView;
    
    //2个子页
    ZZTNewestCommentView *newestVC = [[ZZTNewestCommentView alloc] initWithFrame:CGRectMake(0, 0, mainView.width, mainView.height) style:UITableViewStyleGrouped];
    newestVC.backgroundColor = [UIColor redColor];
    
    ZZTNewestCommentView *hotestVC = [[ZZTNewestCommentView alloc] initWithFrame:CGRectMake(mainView.width, 0, mainView.width, mainView.height)];

    hotestVC.backgroundColor = [UIColor yellowColor];

    [mainView addSubview:newestVC];
    [mainView addSubview:hotestVC];
    [self.view addSubview:mainView];

}

-(void)setupNavigationBar{
    
    ZZTNavBarTitleView *titleView = [[ZZTNavBarTitleView alloc] init];
    
    weakself(self);
    [titleView.leftBtn setTitle:@"最新" forState:UIControlStateNormal];
    [titleView.rightBtn setTitle:@"最热" forState:UIControlStateNormal];
    
    titleView.leftBtnOnClick = ^(UIButton *btn){
        [weakSelf.mainView setContentOffset:CGPointZero animated:YES];
    };
    
    titleView.rightBtnOnClick = ^(UIButton *btn){
        [weakSelf.mainView setContentOffset:CGPointMake(self.mainView.width, 0) animated:YES];
    };
    
    //nav
    ZXDNavBar *navbar = [[ZXDNavBar alloc]init];
    self.navbar = navbar;
    navbar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navbar];
    
    [self.navbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@(navHeight));
    }];
    
    //返回
    [navbar.leftButton setImage:[UIImage imageNamed:@"navigationbar_close"] forState:UIControlStateNormal];
    navbar.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 17);
    [navbar.leftButton addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    
    //中间
    [navbar.mainView addSubview:titleView];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(navbar.mainView);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.4);
        make.height.mas_equalTo(30);
        make.bottom.equalTo(navbar.mainView).offset(-10);
    }];

    navbar.showBottomLabel = NO;
}
-(void)dismissVC{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
