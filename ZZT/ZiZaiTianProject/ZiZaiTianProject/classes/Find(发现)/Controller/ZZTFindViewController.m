//
//  ZZTFindViewController.m
//  ZiZaiTianProject
//
//  Created by zxd on 2018/6/24.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTFindViewController.h"
#import "DCPagerController.h"
#import "ZZTFindWorldViewController.h"
#import "ZZTFindAttentionViewController.h"
#import "TZTestCell.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "TZAssetModel.h"
#import "ZZTZoneUpLoadViewController.h"

@interface ZZTFindViewController ()<PYSearchViewControllerDelegate,PYSearchViewControllerDataSource,UINavigationControllerDelegate>

@property (nonatomic, weak) UIViewController *currentVC;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,weak) PYSearchViewController *searchVC;
@property (nonatomic,strong) NSMutableArray *searchSuggestionArray;
@property (nonatomic,strong) ZXDNavBar *navBar;

@property (nonatomic,strong) UIScrollView *mainView;

@property (nonatomic,strong) ZZTFindWorldViewController *findWorldVC;

@property (nonatomic,strong) ZZTFindAttentionViewController *findVC;

@property (nonatomic,strong) ZZTNavBarTitleView *titleView;
//世界和关注的偏移量
@property (nonatomic,assign) CGFloat worldOffset;

@property (nonatomic,assign) CGFloat attentionOffset;
//是否在世界VC
@property (nonatomic,assign) BOOL isWorldVc;
//观察者
@property (nonatomic,weak) id observer;


@end

NSString *SuggestionView3 = @"SuggestionView";

@implementation ZZTFindViewController

-(NSMutableArray *)searchSuggestionArray{
    if(!_searchSuggestionArray){
        _searchSuggestionArray = [NSMutableArray array];
    }
    return _searchSuggestionArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置主视图
    [self setupMainView];
    
    //设置子页
    [self setupChildView];
    
    //设置nav
    [self setupNavbar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"infoNotification" object:nil];
    
    _isWorldVc = YES;
    
    //跳转编辑器通知
    _observer = [[NSNotificationCenter defaultCenter] addObserverForName:@"addMomentTaget" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self addMomentTaget];
    }];
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

-(void)setupChildView{
    //添加子页
    ZZTFindWorldViewController *findWorldVC = [[ZZTFindWorldViewController alloc] init];
    [self addChildViewController:findWorldVC];
    _findWorldVC = findWorldVC;
    [self.mainView addSubview:findWorldVC.view];

    ZZTFindAttentionViewController *findVC = [[ZZTFindAttentionViewController alloc] init];
    [self addChildViewController:findVC];
    [self.mainView addSubview:findVC.view];
    _findVC = findVC;
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
    
    [_findVC.view setFrame:CGRectMake(width, 0, width, height)];
    [_findWorldVC.view setFrame:CGRectMake(0, 0, width, height)];
    
    [self.mainView setContentOffset:CGPointMake(0, 0)];
}

//因为那个方法是在
//渐变导航栏
-(void)receiveNotification:(NSNotification *)infoNotification {
    NSDictionary *dic = [infoNotification userInfo];
    NSString *str = [dic objectForKey:@"navHidden"];
    CGFloat offsetY = [str floatValue];
    
    //offsetY 就是偏移量
    if(_isWorldVc == YES){
        _worldOffset = offsetY;
    }else{
        _attentionOffset = offsetY;
    }
    
    
    [self changeNavBarColorWithOffsetY:offsetY];
    
}

-(void)changeNavBarColorWithOffsetY:(CGFloat)offsetY{
    if (offsetY < 64) {
        offsetY = 64;
    }
    
    CGFloat alpha = offsetY * 1 / 136.0;   // (200 - 64) / 136.0f
    if (alpha >= 1) {
        alpha = 0.99;
    }
    if(offsetY == 64){
        UIColor *color = [UIColor clearColor];
        
        self.navBar.backgroundImageView.image = [UIImage createImageWithColor:color];
        
    }else{
        
        UIColor *color = [UIColor colorWithWhite:1 alpha:alpha];
        
        self.navBar.backgroundImageView.image = [UIImage createImageWithColor:color];
        
    }
}

-(void)setupNavbar{
    
    ZZTNavBarTitleView *titleView = [[ZZTNavBarTitleView alloc] init];
    titleView.selBtnTextColor = ZZTSubColor;
    titleView.selBtnBackgroundColor = [UIColor whiteColor];
    titleView.btnTextColor = [UIColor whiteColor];
    titleView.btnBackgroundColor = [UIColor clearColor];
    titleView.backgroundColor = [UIColor colorWithHexString:@"#262626" alpha:0.8];
    _titleView = titleView;
    [titleView.leftBtn setTitle:@"世界" forState:UIControlStateNormal];
    [titleView.rightBtn setTitle:@"关注" forState:UIControlStateNormal];
    
    titleView.leftBtn.tag = 0;
    titleView.rightBtn.tag = 1;
    
    [titleView.leftBtn addTarget:self action:@selector(clickMenu:) forControlEvents:UIControlEventTouchUpInside];

    [titleView.rightBtn addTarget:self action:@selector(clickMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    [self clickMenu:titleView.leftBtn];

    ZXDNavBar *navBar = [[ZXDNavBar alloc] init];
    _navBar = navBar;
    navBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:navBar];
    
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@(Height_NavBar));
    }];
    
    //返回
//    [navBar.leftButton setImage:[UIImage imageNamed:@"editCellImg"] forState:UIControlStateNormal];
//    navBar.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 17);
//    [navBar.leftButton addTarget:self action:@selector(addMomentTaget) forControlEvents:UIControlEventTouchUpInside];
    
    [navBar.rightButton setImage:[UIImage imageNamed:@"find_home_search"] forState:UIControlStateNormal];
//    navBar.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -33);
    [navBar.rightButton addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];

    
    //中间
    [navBar.mainView addSubview:titleView];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(navBar.mainView);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.34);
        make.height.mas_equalTo(30);
//        make.bottom.equalTo(navBar.mainView).offset(-10);
        make.centerY.equalTo(navBar.rightButton.mas_centerY);
    }];
    
    navBar.showBottomLabel = NO;
}

-(void)addMomentTaget{
    [_navBar addMoment];
}

- (void)search{
    ZXDSearchViewController *searchVC = [[ZXDSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:NO];
}


-(void)clickMenu:(UIButton *)btn{
    // 取出选中的这个控制器
    if(btn.tag == 0){
        [self.mainView setContentOffset:CGPointMake(0, 0) animated:YES];
        [self.titleView selectBtn:btn];
    }else{
        [self.mainView setContentOffset:CGPointMake(ScreenW, 0) animated:YES];
        [self.titleView selectBtn:btn];
    }
}

//滑动展示清空按钮
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(CGPointEqualToPoint(scrollView.contentOffset, CGPointMake(ScreenW, 0))){
        //当滑动到关注的时候
//        记录世界的偏移量
        //当滑动到世界的时候 刷新
        //关注
        [self.titleView selectBtn:self.titleView.rightBtn];
        _isWorldVc = NO;
        [self changeNavBarColorWithOffsetY:_attentionOffset];

    }else{
        //首页
        [self.titleView selectBtn:self.titleView.leftBtn];
        _isWorldVc = YES;
        [self changeNavBarColorWithOffsetY:_worldOffset];

    }
}

//#pragma mark - UIImagePickerController
//- (void)takePhoto {
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
//        // 无相机权限 做一个友好的提示
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
//        [alert show];
//    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
//        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
//        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
//            if (granted) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self takePhoto];
//                });
//            }
//        }];
//        // 拍照之前还需要检查相册权限
//    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
//        [alert show];
//    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
//        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
//            [self takePhoto];
//        }];
//    } else {
//        [self pushImagePickerController];
//    }
//}







-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:_observer];
    
}
@end
