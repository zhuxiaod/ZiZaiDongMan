//
//  ZZTAlbumAlertControllerView.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/1/7.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import "ZZTAlbumAlertControllerView.h"

@interface ZZTAlbumAlertControllerView ()<TZImagePickerControllerDelegate>

@property (nonatomic,strong) UIImagePickerController *picker;

@end

@implementation ZZTAlbumAlertControllerView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化图像选择控制器
    _picker = [[UIImagePickerController alloc]init];
    _picker.allowsEditing = YES;  //重点是这两句
    
    //遵守代理
    _picker.delegate = self;
    
    _isImageClip = NO;
}

+ (instancetype)initAlbumAlertControllerViewWithAlertAction:(void (^)(NSInteger index))alertAction;
{
    ZZTAlbumAlertControllerView *actionSheet = [ZZTAlbumAlertControllerView alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"手机拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相机
        if (alertAction) {
            alertAction(1);
        }
    }];
    
    [action1 setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (alertAction) {
            alertAction(2);
        }
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
    return actionSheet;
}

- (void)showZCAlert
{
    [[self getCurrentVC] presentViewController:self animated:YES completion:nil];
}

//获取当前的VC
-(UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tempWindow in windows)
        {
            if (tempWindow.windowLevel == UIWindowLevelNormal)
            {
                window = tempWindow;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
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
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        // 将sourceType设为UIImagePickerControllerSourceTypeCamera代表拍照或拍视频
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 设置拍摄照片
        _picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        // 设置使用手机的后置摄像头（默认使用后置摄像头）
        _picker.cameraDevice =UIImagePickerControllerCameraDeviceRear;
        // 设置使用手机的前置摄像头。
        //picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        // 设置拍摄的照片允许编辑
        _picker.allowsEditing =YES;
    }else{
        NSLog(@"模拟器无法打开摄像头");
    }
    // 显示picker视图控制器
    [[self getCurrentVC] presentViewController:_picker animated:YES completion:^{
        
    }];
}



#pragma mark - 相册回调
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    [[self getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
//
    if (self.delegate && [self.delegate respondsToSelector:@selector(albumAlertControllerViewWithImg:)])
    {
        // 调用代理方法
        [self.delegate albumAlertControllerViewWithImg:image];
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
        
        if(self.isImageClip == YES){
            //剪裁视图
            ImageClipViewController *imageClip = [[ImageClipViewController alloc] init];
            [imageClip setClipResult:^(BOOL isCancel, UIImage *image) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(albumAlertControllerViewWithImg:)] && isCancel == 0)
                {
                    // 调用代理方法
                    [self.delegate albumAlertControllerViewWithImg:image];
                }
            }];
            imageClip.clipImage = photos[0];
            imageClip.targetSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH);
            
            [[self getCurrentVC] presentViewController:imageClip animated:YES completion:nil];
        }else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(albumAlertControllerViewWithImg:)])
            {
                // 调用代理方法
                [self.delegate albumAlertControllerViewWithImg:photos[0]];
            }
        }
        
    }];
    
    [[self getCurrentVC] presentViewController:imagePickerVc animated:YES completion:nil];
}

/**
 *  @brief 弹出裁剪视图
 */
- (void)jumpToClipController:(UIImage *)image completion:(void (^ __nullable)(void))completion{
    //剪裁视图
    ImageClipViewController *imageClip = [[ImageClipViewController alloc] init];
    [imageClip setClipResult:^(BOOL isCancel, UIImage *image) {
        
    }];
    imageClip.clipImage = image;
    
    [[self getCurrentVC] presentViewController:imageClip animated:YES completion:^{
        if (completion) {
            completion();
        }
    }];
}

-(void)setIsImageClip:(BOOL)isImageClip{
    _isImageClip = isImageClip;
}
@end
