//
//  ZXDNavBar.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/10/16.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDNavBar.h"
@interface ZXDNavBar ()<UIImagePickerControllerDelegate,TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSMutableArray *selectedPhotos;

@property (nonatomic, strong) NSMutableArray *selectedAssets;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (nonatomic, strong) UILabel *lineLabel;

@property (strong, nonatomic) CLLocation *location;

@property (nullable, nonatomic, readonly) UIViewController *viewController; @end

@implementation ZXDNavBar

-(NSMutableArray *)selectedAssets{
    if(_selectedAssets == nil){
        _selectedAssets = [NSMutableArray array];
    }
    return _selectedAssets;
}

-(NSMutableArray *)selectedPhotos{
    if(_selectedPhotos == nil){
        _selectedPhotos = [NSMutableArray array];
    }
    return _selectedPhotos;
}

- (UIView *)mainView{
    if (!_mainView) {
        _mainView = [UIView new];
        _mainView.backgroundColor = [UIColor clearColor];
        [self addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        //背景图片
        _backgroundImageView = [[UIImageView alloc] init];
        [_mainView addSubview:_backgroundImageView];
        [_mainView sendSubviewToBack:_backgroundImageView];
        [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        [_mainView.superview layoutIfNeeded];
    }
    return _mainView;
}

- (UIButton *)leftButton{
    if (!_leftButton) {
        // 左边按钮
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _leftButton.adjustsImageWhenHighlighted = NO;
        _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.mainView addSubview:_leftButton];
        [_leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(self.mainView.mas_centerY).with.offset((KStatusBarMargin+20)/2);
        }];
    } return _leftButton;
}

- (UIButton *)leftTwoButton{
    if (!_leftTwoButton) {
        // 左边第二个按钮
        _leftTwoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftTwoButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _leftTwoButton.adjustsImageWhenHighlighted = NO;
        _leftTwoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_leftTwoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.mainView addSubview:_leftTwoButton];
        [_leftTwoButton addTarget:self action:@selector(clickLeftTwoButton) forControlEvents:UIControlEventTouchUpInside];
        [_leftTwoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftButton.mas_right).mas_offset(10);
            make.width.mas_equalTo(50); make.height.mas_equalTo(40);
            make.centerY.mas_equalTo(self.mainView.mas_centerY).with.offset((KStatusBarMargin+20)/2);
        }];
    }
    return _leftTwoButton;
}

-(UIButton *)rightButton{
    if (!_rightButton) {
        //右边按钮
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
        rightButton.adjustsImageWhenHighlighted = NO;
        [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.mainView addSubview:rightButton];
        self.rightButton = rightButton;
        [_rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(40);
            make.centerY.mas_equalTo(self.leftButton);
            
        }];
        [self.rightButton.superview layoutIfNeeded];
        
    }
    return _rightButton;
    
}

-(UIButton *)rightTwoButton{
    if (!_rightTwoButton) {
        //右边第二个按钮
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
        rightButton.adjustsImageWhenHighlighted = NO;
        [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.mainView addSubview:rightButton]; self.rightTwoButton = rightButton;
        [_rightTwoButton addTarget:self action:@selector(clickRightTwoButton) forControlEvents:UIControlEventTouchUpInside];
        [self.rightTwoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.rightButton.mas_left).mas_offset(-10);
            make.width.mas_equalTo(50); make.height.mas_equalTo(40);
            make.centerY.mas_equalTo(self.leftButton);
        }];
        [self.rightTwoButton.superview layoutIfNeeded];
    }
    return _rightTwoButton;
}

-(UIButton *)centerButton{
    if (!_centerButton) {
        //中间按钮
        UIButton *centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        centerButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [centerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        centerButton.adjustsImageWhenHighlighted = NO;
        [self.mainView addSubview:centerButton];
        self.centerButton = centerButton;
        [_centerButton addTarget:self action:@selector(clickCenterButton) forControlEvents:UIControlEventTouchUpInside];
        [self.centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(self.leftButton.mas_height);
            make.width.mas_equalTo(Screen_Width - (self.rightButton.width + 38) * 2);
            make.centerY.mas_equalTo(self.leftButton);
        }];
        [self.centerButton.superview layoutIfNeeded];
    }
    return _centerButton;
}

-(UILabel *)lineLabel{
    if (!_lineLabel) {
        //底部分割线
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.backgroundColor = UIColor.lightGrayColor;
        self.lineLabel = lineLabel;
        [self.mainView addSubview:lineLabel];
        [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        [self.mainView bringSubviewToFront:lineLabel];
    }
    return _lineLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        
    } return self;
    
}

/** * UI 界面 */
- (void)setupUI{
    [self lineLabel];
}

- (void)setShowBottomLabel:(BOOL)showBottomLabel{
    self.lineLabel.hidden = !showBottomLabel;
    
}

- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    } return nil;
}

#pragma mark - private
- (void)clickLeftButton{
    // 获取返回视图的视图控制器
    [self.viewController.navigationController popViewControllerAnimated:YES];
    if (self.leftButtonBlock) { self.leftButtonBlock();
    }
}

- (void)clickLeftTwoButton{
    if (self.leftTwoButtonBlock)
    {
        self.leftTwoButtonBlock();
    }
}
- (void)clickCenterButton{
    if (self.cenTerButtonBlock)
    {
        self.cenTerButtonBlock();
    }
}
- (void)clickRightButton{
    if (self.rightButtonBlock) {
        self.rightButtonBlock();
    }
}

- (void)clickRightTwoButton{
    if (self.rightTwoButtonBlock) {
        self.rightTwoButtonBlock();
    }
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
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"进入编辑器" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        ZZTEditorCartoonViewController *ecVC = [[ZZTEditorCartoonViewController alloc] init];
        ecVC.hidesBottomBarWhenPushed = YES;
        
        [[self myViewController].navigationController pushViewController:ecVC animated:YES];
        
    }];
    
    [action3 setValue:ZZTSubColor forKey:@"_titleTextColor"];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    [action4 setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];
    [actionSheet addAction:action4];
    
    [[self myViewController] presentViewController:actionSheet animated:YES completion:nil];
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

//图片选择控制器
#pragma mark - TZImagePickerController
- (void)pushTZImagePickerController {
    //最大选择数   最大显示照片
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
        
        [[self myViewController] presentViewController:uploadVC animated:YES completion:nil];
    }];
    
    [[self myViewController] presentViewController:imagePickerVc animated:YES completion:nil];
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
        
        if (mediaTypes.count) {
            _imagePickerVc.mediaTypes = mediaTypes;
        }
        [[self myViewController] presentViewController:_imagePickerVc animated:YES completion:nil];
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

//创建一个图片选择控制器
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = [self myViewController].navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = [self myViewController].navigationController.navigationBar.tintColor;
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
        
        [[self myViewController] presentViewController:uploadVC animated:YES completion:nil];
    }];
    
}
@end
