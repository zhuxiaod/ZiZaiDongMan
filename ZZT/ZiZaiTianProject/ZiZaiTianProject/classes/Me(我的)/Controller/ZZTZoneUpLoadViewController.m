//
//  ZZTZoneUpLoadViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/10/24.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTZoneUpLoadViewController.h"
#import "LxGridViewFlowLayout.h"
#import "TZTestCell.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "TZAssetModel.h"

@interface ZZTZoneUpLoadViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate,UITextViewDelegate>{
    CGFloat _margin;
    CGFloat _itemWH;
//    NSMutableArray *_selectedPhotos;
//    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
}
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) LxGridViewFlowLayout *layout;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic,strong) ZXDNavBar *navbar;

@property (nonatomic,strong) UITextView *textView;

@property (strong, nonatomic) CLLocation *location;

@property (nonatomic,strong) NSMutableArray *imageUrlArr;

@property (nonatomic,strong) NSMutableArray *selectedPhotos;

@property (nonatomic,strong) NSMutableArray *selectedAssets;

@end

@implementation ZZTZoneUpLoadViewController

-(NSMutableArray *)selectedAssets{
    if(!_selectedAssets){
        _selectedAssets = [NSMutableArray array];
    }
    return _selectedAssets;
}

-(NSMutableArray *)selectedPhotos{
    if(!_selectedPhotos){
        _selectedPhotos = [NSMutableArray array];
    }
    return _selectedPhotos;
}

-(NSMutableArray *)imageUrlArr{
    if(!_imageUrlArr){
        _imageUrlArr = [NSMutableArray array];
    }
    return _imageUrlArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建scrollView
    [self setupScrollView];
    
    //自定义navgationBar
    [self setupNavigationBar];
    
    //设置textView
    [self setupTextView];
    
    //照片View
    [self setupImageView];

}

-(void)setupImageView{
    _layout = [[LxGridViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.scrollView addSubview:_collectionView];
    
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    
    [self.view layoutIfNeeded];
    
    CGFloat collectionViewW = ((self.view.width - 32) - 2 * _margin - 4) / 3 - _margin;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.height.mas_equalTo(collectionViewW * 3);
    }];
}

-(void)setupTextView{
    UITextView *textView = [[UITextView alloc] init];
    textView.layer.cornerRadius = 5;
    textView.text = @"这一刻的想法...";
    textView.textColor = [UIColor grayColor];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.typingAttributes = attributes;
    textView.returnKeyType = UIReturnKeySend;
    textView.delegate = self;
    
    _textView = textView;
    
    [self.scrollView addSubview:textView];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navbar.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.height.mas_equalTo(140);
    }];
}
-(void)setupScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    scrollView.contentSize = CGSizeMake(self.view.width,self.view.height + 40);
    
    scrollView.showsVerticalScrollIndicator = NO;
}

-(void)setupNavigationBar{
    ZXDNavBar *navbar = [[ZXDNavBar alloc]init];
    _navbar = navbar;
    [navbar setBackgroundColor:[UIColor whiteColor]];
    [navbar setShowBottomLabel:NO];
    [self.view addSubview:navbar];
    
    [self.navbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@(navHeight));
    }];
    
    [navbar.leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [navbar.leftButton addTarget:self action:@selector(cancelView) forControlEvents:UIControlEventTouchUpInside];
    
    [navbar.rightButton setTitle:@"发表" forState:UIControlStateNormal];
    [navbar.rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [navbar.rightButton addTarget:self action:@selector(uploadMoment) forControlEvents:UIControlEventTouchUpInside];
}

-(void)cancelView{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//上传七牛云
-(void)uploadMoment{
    [self upLoadQiNiuLoad:_selectedPhotos];
}

//上传后台
-(void)uploadSeverWithImageStr:(NSString *)str{
    UserInfo *user = [Utilities GetNSUserDefaults];
    NSNumber *high = @0;
    NSNumber *wide = @0;
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%ld",user.id] forKey:@"userId"];
    if([self.textView.text isEqualToString:@"这一刻的想法..."]){
        self.textView.text = @"";
    }
    [dict setObject:self.textView.text forKey:@"content"];
    [dict setObject:str forKey: @"contentImg"];
    if(self.selectedPhotos.count == 1){
        UIImage *imge = _selectedPhotos[0];
        high = [NSNumber numberWithFloat:imge.size.height];
        wide = [NSNumber numberWithFloat:imge.size.width];
    }
    [dict setObject:high forKey:@"high"];
    [dict setObject:wide forKey:@"wide"];
    [manager POST:[ZZTAPI stringByAppendingString:@"record/issueFriends"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


-(void)upLoadQiNiuLoad:(NSArray *)array{
    //多图上传
    NSString * imageParms = @"";
    if (array.count > 0) {
        imageParms = [SYQiniuUpload QiniuPutImageArray:array complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            NSLog(@"info == %@ \n resp === %@",info,resp);
        }];
    }

    //上传
    [self uploadSeverWithImageStr:imageParms];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

//已经展示
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSInteger contentSizeH = 14 * 35 + 20;
    //延时
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.scrollView.contentSize = CGSizeMake(0, contentSizeH + 5);
    });
    //间距 4
    _margin = 4;
    //item宽高
    _itemWH = ((self.view.width - 32) - 2 * _margin - 4) / 3 - _margin;
    NSLog(@"111%f",_itemWH);
    //设置宽高
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    //间距
    _layout.minimumInteritemSpacing = _margin;
    //间距
    _layout.minimumLineSpacing = _margin;
    //设置样式
    [self.collectionView setCollectionViewLayout:_layout];
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

#pragma mark UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //如果选择照片的数量 大于  最大数量
    if (_selectedPhotos.count >= 9) {
        return _selectedPhotos.count;
    }
    //有一个加号
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //    cell
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    //视频图片隐藏
    cell.videoImageView.hidden = YES;
    //如果是最后一个
    if (indexPath.item == _selectedPhotos.count) {
        //显示加号
        cell.imageView.image = [UIImage imageNamed:@"zone_add"];
        //隐藏删除lab
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
    } else {
        //如果不是最后一个
        //显示图片
        cell.imageView.image = _selectedPhotos[indexPath.item];
        //资源
        cell.asset = _selectedAssets[indexPath.item];
        cell.deleteBtn.hidden = NO;
    }

    //添加删除事件
    cell.deleteBtn.tag = indexPath.item;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - Click Event
- (void)deleteBtnClik:(UIButton *)sender {
    if ([self collectionView:self.collectionView numberOfItemsInSection:0] <= _selectedPhotos.count) {
        [_selectedPhotos removeObjectAtIndex:sender.tag];
        [_selectedAssets removeObjectAtIndex:sender.tag];
        [self.collectionView reloadData];
        return;
    }
    
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self->_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self->_collectionView reloadData];
    }];
}

//cell点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //如果这是最后一个
    if (indexPath.item == _selectedPhotos.count) {
        //是否出现弹窗
        BOOL showSheet = YES;
        //如果有
        if (showSheet) {
            NSString *takePhotoTitle = @"拍照";

            //展示弹窗
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:takePhotoTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //打开相机
                [self takePhoto];
            }];
            [alertVc addAction:takePhotoAction];
            //去相册里面选择
            UIAlertAction *imagePickerAction = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //push到照片选择页
                [self pushTZImagePickerController];
            }];
            [alertVc addAction:imagePickerAction];
            //取消
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertVc addAction:cancelAction];
            UIPopoverPresentationController *popover = alertVc.popoverPresentationController;
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            
            if (popover) {
                popover.sourceView = cell;
                popover.sourceRect = cell.bounds;
                popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
            }
            [self presentViewController:alertVc animated:YES completion:nil];
        } else {
            [self pushTZImagePickerController];
        }
    } else { // preview photos or video / 预览照片或者视频
        //如果是点击其他item 那么预览
        PHAsset *asset = _selectedAssets[indexPath.item];
        BOOL isVideo = NO;
        isVideo = asset.mediaType == PHAssetMediaTypeVideo;

//       预览照片
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.item];
        imagePickerVc.maxImagesCount = 99;
        imagePickerVc.allowPickingGif = NO;
        imagePickerVc.allowPickingOriginalPhoto = YES;
        imagePickerVc.allowPickingMultipleVideo = YES;
        imagePickerVc.showSelectedIndex = YES;
        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [self->_selectedPhotos addObjectsFromArray:photos];
            [self->_selectedAssets addObjectsFromArray:assets];
            self->_isSelectOriginalPhoto = isSelectOriginalPhoto;
            [self->_collectionView reloadData];
            self->_collectionView.contentSize = CGSizeMake(0, ((self->_selectedPhotos.count + 2) / 3 ) * (self->_margin + self->_itemWH));
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
//        }
    }
}

#pragma mark - UIImagePickerController
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
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
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
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

    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:99 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    //如果大于1
//    if (self.maxCountTF.text.integerValue > 1) {
        // 1.设置目前已经选中的图片数组
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
//    }
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = NO;   // 在内部显示拍视频按
    imagePickerVc.videoMaximumDuration = 10; // 视频最大拍摄时间
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

    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = self.view.width - 2 * left;
    NSInteger top = (self.view.height - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);

    imagePickerVc.statusBarStyle = UIStatusBarStyleDefault;
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = YES;
    
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [self->_selectedPhotos addObjectsFromArray:photos];
        [self->_selectedAssets addObjectsFromArray:assets];

//        self->_selectedPhotos = [NSMutableArray arrayWithArray:photos];
//        self->_selectedAssets = [NSMutableArray arrayWithArray:assets];
        self->_isSelectOriginalPhoto = isSelectOriginalPhoto;
        [self->_collectionView reloadData];
        self->_collectionView.contentSize = CGSizeMake(0, ((self->_selectedPhotos.count + 2) / 3 ) * (self->_margin + self->_itemWH));
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
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
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)refreshCollectionViewWithAddedAsset:(PHAsset *)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    [_collectionView reloadData];
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
}

#pragma mark - LxGridViewDataSource
/// 以下三个方法为长按排序相关代码  移动item
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    //返回能够移动的索引
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    //返回 移动到目的地索引
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [_collectionView reloadData];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    if(textView.text.length < 1){
        textView.text = @"这一刻的想法...";
        textView.textColor = [UIColor grayColor];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if([textView.text isEqualToString:@"这一刻的想法..."]){
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

-(void)setAddAssets:(PHAsset *)addAssets{
    _addAssets = addAssets;
    [self.selectedAssets addObject:addAssets];
}

-(void)setAddPhotos:(UIImage *)addPhotos{
    _addPhotos = addPhotos;
    [self.selectedPhotos addObject:addPhotos];
    [self.collectionView reloadData];
}

-(void)setAddAssetsArray:(NSArray *)addAssetsArray{
    _addAssetsArray = addAssetsArray;
    [self.selectedAssets addObjectsFromArray:addAssetsArray];
}

-(void)setAddPhotosArray:(NSArray *)addPhotosArray{
    _addPhotosArray = addPhotosArray;
    [self.selectedPhotos addObjectsFromArray:addPhotosArray];
    [self.collectionView reloadData];
}
//相机返回代理
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //相机返回照片
    [picker dismissViewControllerAnimated:YES completion:^{
        //类型
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        [tzImagePickerVc showProgressHUD];
        if ([type isEqualToString:@"public.image"]) {
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(PHAsset *asset, NSError *error){
                [tzImagePickerVc hideProgressHUD];
                if (error) {
                    NSLog(@"图片保存失败 %@",error);
                } else {
                    TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];
                    
                    [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                }
            }];
        }
    }];
}



@end
