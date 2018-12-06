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
#import "LxGridViewFlowLayout.h"
#import "TZTestCell.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "TZAssetModel.h"
#import "ZZTZoneUpLoadViewController.h"

@interface ZZTFindViewController ()<PYSearchViewControllerDelegate,PYSearchViewControllerDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
}

@property (nonatomic, weak) UIViewController *currentVC;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,weak) PYSearchViewController *searchVC;
@property (nonatomic,strong) NSMutableArray *searchSuggestionArray;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic,strong) ZXDNavBar *navBar;

@property (nonatomic,strong) UIScrollView *mainView;

@property (nonatomic,strong) ZZTFindWorldViewController *findWorldVC;

@property (nonatomic,strong) ZZTFindAttentionViewController *findVC;

@property (nonatomic,strong) ZZTNavBarTitleView *titleView;

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
    
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    
    //设置nav
    [self setupNavbar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"infoNotification" object:nil];
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
    [navBar.leftButton setImage:[UIImage imageNamed:@"find_home_addMoment"] forState:UIControlStateNormal];
//    navBar.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 17);
    [navBar.leftButton addTarget:self action:@selector(addMoment) forControlEvents:UIControlEventTouchUpInside];
    
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

-(void)addMoment{
    
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"手机拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相机
        [self takePhoto];
    }];
    
    [action1 setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
   
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pushTZImagePickerController];
    }];
    [action2 setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    
//    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"进入编辑器" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    [action3 setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    [action4 setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
//    [actionSheet addAction:action3];
    [actionSheet addAction:action4];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
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
        //书柜
        [self.titleView selectBtn:self.titleView.rightBtn];

    }else{
        //首页
        [self.titleView selectBtn:self.titleView.leftBtn];
    }
}

#pragma mark - UIImagePickerController
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = [locations firstObject];
    } failureBlock:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        NSMutableArray *mediaTypes = [NSMutableArray array];
        //        if (NO) {
        //            [mediaTypes addObject:(NSString *)kUTTypeMovie];
        //        }
        //        if (NO) {
        //            [mediaTypes addObject:(NSString *)kUTTypeImage];
        //        }
        if (mediaTypes.count) {
            _imagePickerVc.mediaTypes = mediaTypes;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)refreshCollectionViewWithAddedAsset:(PHAsset *)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
}

//图片选择控制器
#pragma mark - TZImagePickerController
- (void)pushTZImagePickerController {

    //有的话  就生成选择页面
    //最大选择数     最大显示照片
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    // imagePickerVc.navigationBar.translucent = NO;
    
    imagePickerVc.naviBgColor = [UIColor grayColor];
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = YES;

    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组

    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮

    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    
    //主题颜色
    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    //显示照片不能选择图层
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    //    无法选择图层颜色
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    
    imagePickerVc.naviBgColor = [UIColor blackColor];
    imagePickerVc.naviTitleColor = [UIColor blackColor];
    imagePickerVc.barItemTextColor = [UIColor blackColor];
    
    //设置照片选择器页面UI配置块
    [imagePickerVc setPhotoPickerPageUIConfigBlock:^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
        [doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }];
    
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;

    imagePickerVc.statusBarStyle = UIStatusBarStyleDefault;
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = YES;
    
#pragma mark - 到这里为止

    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        ZZTZoneUpLoadViewController *uploadVC = [[ZZTZoneUpLoadViewController alloc] init];
        
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        
        [tzImagePickerVc showProgressHUD];
        
        [tzImagePickerVc hideProgressHUD];
        
        uploadVC.addAssetsArray = assets;
        
        uploadVC.addPhotosArray = photos;
        
        [self presentViewController:uploadVC animated:YES completion:nil];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self setupNavigationBarHidden:NO];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//创建一个图片选择控制器
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (@available(iOS 9, *)) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

//相机返回代理
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        ZZTZoneUpLoadViewController *uploadVC = [[ZZTZoneUpLoadViewController alloc] init];
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        [tzImagePickerVc showProgressHUD];
        if ([type isEqualToString:@"public.image"]) {
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            // save photo and get asset / 保存图片，获取到asset
            [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(PHAsset *asset, NSError *error){
                [tzImagePickerVc hideProgressHUD];
                if (error) {
                    NSLog(@"图片保存失败 %@",error);
                } else {
                    TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];
                    
                    //                    [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                    uploadVC.addAssets = assetModel.asset;
                    uploadVC.addPhotos = image;
                }
            }];
        }
        
        [self presentViewController:uploadVC animated:YES completion:nil];
    }];
//    [picker dismissViewControllerAnimated:YES completion:^{
    
//    }];
}
@end
