//
//  ZZTEditorCartoonViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/24.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTEditorCartoonViewController.h"
#import "ZZTEditorBottomView.h"
#import "ZZTEditorTopView.h"
#import "ZZTMaterialWindowView.h"
#import "ZZTEditorDeskView.h"
#import "ZZTEditorBasisView.h"
#import "ZZTEditorImageView.h"
#import "ZZTInputView.h"
#import "ZZTSquareRoundView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZZTDetailModel.h"
#import "ZZTColorPickerView.h"
#import "ZZTEditorBrightnessView.h"
#import "ZZTAlbumAlertControllerView.h"
#import "ZZTEditorTextView.h"
#import "ZZTEditorFontView.h"
#import "ZZTEditorCurrentStateView.h"

@interface ZZTEditorCartoonViewController ()<ZZTMaterialWindowViewDelegate,ZZTEditorImageViewDelegate,ZZTSquareRoundViewDelegate,ZZTEditorDeskViewdelegate,ZZTEditorBasisViewDelegate,ZZTColorPickerViewDelegate,ZZTEditorBrightnessView,ZZTAlbumAlertControllerViewDelegate,ZZTEditorTextViewDelegate,ZZTEditorFontViewDelegate>{
    
    CIFilter *_colorControlsFilter;//色彩滤镜

    CIContext *_context;//Core Image上下文

    CIImage *_image;//我们要编辑的图像
    
    NSInteger testI;

}

@property (nonatomic,strong) ZZTEditorDeskView *editorDeskView;//桌面
@property (nonatomic,strong) ZZTInputView *inputView;//输入框

@property (nonatomic,strong) ZZTEditorImageView *ImageView1;
//顶部关闭按钮
@property (nonatomic,strong) UIButton *closeBtn;

@property (nonatomic,strong) ZZTSquareRoundView *editor_squareRoundView;//方圆框

@property (nonatomic,assign) NSInteger squareRoundIndex;//方框所在层级

@property (nonatomic,strong) UIImageView *preViewImgView;

//桌面数组
@property (nonatomic,strong) NSMutableArray *deskArray;

//当前桌面的ID
@property (nonatomic,assign) NSInteger deskIndex;

@property (nonatomic,strong) ZZTEditorTopView *topView;

@property (nonatomic,strong) ZZTMaterialWindowView *materialWindow;//素材库

@property (nonatomic,strong) ZZTColorPickerView *colorPickerView;//调色view

@property (nonatomic,strong) ZZTEditorFontView *fontView;

@property (nonatomic,strong) NSMutableArray *releseImgArray;

@property (nonatomic,strong) ZZTEditorCurrentStateView *stateView;

@property (nonatomic,assign) CGAffineTransform closeViewTransform;

@end

@implementation ZZTEditorCartoonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _deskArray = [NSMutableArray array];
    
    //设置顶部UI
    [self setupUI];
    
    //请求布局
    [self loadData];
}

-(void)getDeskArrayObjectIndex:(ZZTEditorDeskView *)editorDeskView{
    _deskIndex = [_deskArray indexOfObject:editorDeskView];
    NSLog(@"_deskIndex:%ld",_deskIndex);
}

-(void)setupUI{
    ZZTEditorDeskView *editorDeskView = [[ZZTEditorDeskView alloc] init];
    editorDeskView.delegate = self;
    _editorDeskView = editorDeskView;
    [self.view addSubview:editorDeskView];
    
    [editorDeskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self.view);
    }];
    
    [_deskArray addObject:editorDeskView];
    
    [self getDeskArrayObjectIndex:editorDeskView];

    ZZTEditorTopView *topView = [[ZZTEditorTopView alloc] init];
    _topView = topView;
    [topView.backBtn addTarget:self action:@selector(backLastVC) forControlEvents:UIControlEventTouchUpInside];
    [topView.deletBtn addTarget:self action:@selector(cleanAllView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topView];
    [topView.saveBtn addTarget:self action:@selector(saveCurrentView) forControlEvents:UIControlEventTouchUpInside];
    [topView.previewBtn addTarget:self action:@selector(previewCurrentView) forControlEvents:UIControlEventTouchUpInside];
    [topView.releaseBtn addTarget:self action:@selector(releaseCartoon) forControlEvents:UIControlEventTouchUpInside];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(ZZTLayoutDistance(100));
    }];
    
    ZZTEditorBottomView *bottomView = [[ZZTEditorBottomView alloc] init];
    [bottomView.materialBtn addTarget:self action:@selector(openTheMaterialLibrary) forControlEvents:UIControlEventTouchUpInside];
    [bottomView.lastBtn addTarget:self action:@selector(moveUpOneLevel) forControlEvents:UIControlEventTouchUpInside];
    [bottomView.nextBtn addTarget:self action:@selector(moveDownOneLevel) forControlEvents:UIControlEventTouchUpInside];
    [bottomView.colorBtn addTarget:self action:@selector(colorTheView) forControlEvents:UIControlEventTouchUpInside];
    [bottomView.paletteBtn addTarget:self action:@selector(paletteTheView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.view);
        make.height.mas_equalTo(ZZTLayoutDistance(130));
    }];
    
    //上一页
    UIButton *lastPageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lastPageBtn setImage:[UIImage imageNamed:@"上一页"] forState:UIControlStateNormal];
    [self.view addSubview:lastPageBtn];
    [lastPageBtn addTarget:self action:@selector(clickOnThePreviousPage) forControlEvents:UIControlEventTouchUpInside];
    
    [lastPageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomView.mas_top).offset(ZZTLayoutDistance(-100));
        make.left.equalTo(self.view).offset(10);
        make.width.height.mas_equalTo(ZZTLayoutDistance(70));
    }];
    
    //下一页
    UIButton *nextPageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextPageBtn setImage:[UIImage imageNamed:@"下一页"] forState:UIControlStateNormal];
    [self.view addSubview:nextPageBtn];
    
    [nextPageBtn addTarget:self action:@selector(clickOnTheNextPage) forControlEvents:UIControlEventTouchUpInside];

    
    [nextPageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomView.mas_top).offset(ZZTLayoutDistance(-100));
        make.right.equalTo(self.view).offset(-10);
        make.width.height.mas_equalTo(ZZTLayoutDistance(70));
    }];
    
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotify:) name:UIKeyboardWillChangeFrameNotification object:nil];

}

//隐藏当前View按钮
-(void)hiddenCurrentImgViewCloseBtn{
    //如果当前View是桌面上的
    if(self.editorDeskView.currentView){
        //如果是图
        if([self.editorDeskView.currentView isKindOfClass:[ZZTEditorImageView class]]){
            ZZTEditorImageView *currentView = (ZZTEditorImageView *)self.editorDeskView.currentView;
            currentView.closeImageView.hidden = YES;
        }else if([self.editorDeskView.currentView isKindOfClass:[ZZTEditorTextView class]]){
            ZZTEditorTextView *currentView = (ZZTEditorTextView *)self.editorDeskView.currentView;
            currentView.closeImageView.hidden = YES;
        }
    }else{
        if([self.editor_squareRoundView.currentView isKindOfClass:[ZZTEditorImageView class]]){
            ZZTEditorImageView *currentView = (ZZTEditorImageView *)self.editor_squareRoundView.currentView;
            currentView.closeImageView.hidden = YES;
        }else if([self.editor_squareRoundView.currentView isKindOfClass:[ZZTEditorTextView class]]){
            ZZTEditorTextView *currentView = (ZZTEditorTextView *)self.editorDeskView.currentView;
            currentView.closeImageView.hidden = YES;
        }
    }
}

-(void)showCurrentImgViewCloseBtn{
    
    if(self.editorDeskView.currentView){
        if([self.editorDeskView.currentView isKindOfClass:[ZZTEditorImageView class]]){
            ZZTEditorImageView *currentView = (ZZTEditorImageView *)self.editorDeskView.currentView;
            currentView.closeImageView.hidden = NO;
        }else if([self.editorDeskView.currentView isKindOfClass:[ZZTEditorTextView class]]){
            ZZTEditorTextView *currentView = (ZZTEditorTextView *)self.editorDeskView.currentView;
            currentView.closeImageView.hidden = NO;
        }
    }else{
        if([self.editor_squareRoundView.currentView isKindOfClass:[ZZTEditorImageView class]]){
            ZZTEditorImageView *currentView = (ZZTEditorImageView *)self.editor_squareRoundView.currentView;
            currentView.closeImageView.hidden = NO;
        }else if([self.editor_squareRoundView.currentView isKindOfClass:[ZZTEditorTextView class]]){
            ZZTEditorTextView *currentView = (ZZTEditorTextView *)self.editor_squareRoundView.currentView;
            currentView.closeImageView.hidden = NO;
        }
    }
}
#pragma mark - 显示当前编辑View的菜单栏
-(void)showCurrentStateViewWithView:(ZZTEditorBasisView *)view index:(NSInteger)index{
//    NSLog(@"viewBounds:%@",NSStringFromCGRect(view.bounds));
//    [_stateView removeFromSuperview];
//    ZZTEditorImageView *currentView = (ZZTEditorImageView *)view;
//
////    ZZTEditorCurrentStateView *stateView = [[ZZTEditorCurrentStateView alloc] initWithFrame:view.frame];
//    ZZTEditorCurrentStateView *stateView = [[ZZTEditorCurrentStateView alloc] init];
//    [self.view insertSubview:stateView atIndex:index];
//    //中心点一样
//    //bounds一样
//    //旋转的角度
//    //放大的倍数
//    [stateView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.left.bottom.equalTo(currentView);
//    }];
////    stateView.transform = view.transform;
////    stateView.x = view.x;
////    stateView.y = view.y;
////    _stateView.frame = ;
//    _stateView = stateView;
//    _closeViewTransform = _stateView.deletBtn.transform;
    //获取当前View所在的层数
}

//-(void)editorBasisViewWithRotateGesture:(UIRotationGestureRecognizer *)gesture{
//    _stateView.transform = CGAffineTransformRotate(_stateView.transform, gesture.rotation);
//}
//
//- (void)editorBasisViewWithCenter:(ZZTEditorBasisView *)view{
//
//    _stateView.center = view.center;
//}
//
//- (void)editorBasisViewWithPich:(UIPinchGestureRecognizer *)recognizer{
//    _stateView.bounds = CGRectMake(_stateView.bounds.origin.x, _stateView.bounds.origin.y, _stateView.bounds.size.width * recognizer.scale, _stateView.bounds.size.height * recognizer.scale);
////    _stateView.deletBtn.frame = CGRectMake(_stateView.width - 30, 0, 30, 30);
////    CGAffineTransform deltransform = _stateView.deletBtn.transform;
////    _stateView.transform = CGAffineTransformScale(_stateView.transform, recognizer.scale, recognizer.scale);
////    CGFloat p = 0.0;
////    if(recognizer.scale > 1){
////        p = recognizer.scale - 1;
////    }else{
////        p = 1 - recognizer.scale + 1;
////    }
////    _stateView.deletBtn.frame = cgr;
////    _stateView.frame = recognizer.frame;
////    _stateView.frame =
//////    _stateView.deletBtn.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
////    _stateView.deletBtn.transform = CGAffineTransformScale(_closeViewTransform, 0, 0);
////    CGFloat W = _stateView.width * recognizer.scale;
////    CGFloat H = _stateView.height * recognizer.scale;
////    _stateView.bounds = CGRectMake(0, 0, W, H);
//
//}

//隐藏方框按钮
-(void)hiddenCurrentSRViewEditorBtn{
    if(_editor_squareRoundView){
        [_editor_squareRoundView editorBtnHidden:YES];
    }
}

-(void)keyboardWillChangeFrameNotify:(NSNotification*)notify {
    NSLog(@"键盘键盘");
    // 0.取出键盘动画的时间
    CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
   // 2.计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height + 100;
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.inputView.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
}

//返回上一页面
-(void)backLastVC{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadData{
    
    //请求布局信息
}
//切换上下页的时候 看父类是什么  如果是桌面 那么  就移动桌面上的
//如果是 方框里面的  执行方框里的上下页方法
//上一层
-(void)moveUpOneLevel{
    if(self.editorDeskView.currentView){
        [self.editorDeskView Editor_moveCurrentImageViewToLastLayer];
    }else{
        [self.editor_squareRoundView SquareRound_moveCurrentImageViewToLastLayer];
    }
}

//下一层
-(void)moveDownOneLevel{
    if(self.editorDeskView.currentView){
        [self.editorDeskView Editor_moveCurrentImageViewToNextLayer];
    }else{
        [self.editor_squareRoundView SquareRound_moveCurrentImageViewToNextLayer];
    }
}

//填色
-(void)colorTheView{
    CGFloat viewHeight = 250;
    CGFloat y = SCREEN_HEIGHT - viewHeight;
    ZZTColorPickerView *colorPickerView = [[ZZTColorPickerView alloc] initWithFrame:CGRectMake(0, y , SCREEN_WIDTH, viewHeight)];
    colorPickerView.delegate = self;
    _colorPickerView = colorPickerView;
    [self.view addSubview:colorPickerView];
}


-(void)colorPickerViewWithColor:(ZZTColorPickerView *)view color:(UIColor *)color{
    //方框 背景
    if(_editor_squareRoundView && _editor_squareRoundView.isBig == YES){
        //方框 编辑状态
        _editor_squareRoundView.mainView.backgroundColor = color;
    }else{
        self.editorDeskView.backgroundColor = color;
    }
}

//调色
-(void)paletteTheView{
    _context = [CIContext contextWithOptions:nil];//使用GPU渲染，推荐,但注意GPU的CIContext无法跨应用访问，例如直接在UIImagePickerController的完成方法中调用上下文处理就会自动降级为CPU渲染，所以推荐现在完成方法中保存图像，然后在主程序中调用
    
    //取得滤镜
    _colorControlsFilter = [CIFilter filterWithName:@"CIColorControls"];
    
    //拿到当前view的照片 判断
    ZZTEditorImageView *imageView = [self getCurrentViewImg];
    
    //初始化CIImage源图像
    _image = [CIImage imageWithCGImage:imageView.imageView.image.CGImage];
    
    [_colorControlsFilter setValue:_image forKey:@"inputImage"];//设置滤镜的输入图片
    
    //显示UI
    ZZTEditorBrightnessView *BrightnessView = [[ZZTEditorBrightnessView alloc] initWithFrame:CGRectMake(0, self.view.height - BrightnessToolBarHeight, self.view.width, BrightnessToolBarHeight)];
    BrightnessView.delegate = self;
    [self.view addSubview:BrightnessView];
}

#pragma mark - 获得CurrentView的image
-(ZZTEditorImageView *)getCurrentViewImg{
    ZZTEditorImageView *currentView = [[ZZTEditorImageView alloc] init];
    if(_editor_squareRoundView && _editor_squareRoundView.isBig == YES){
        if([self.editor_squareRoundView.currentView isKindOfClass:[ZZTEditorImageView class]]){
            //选中方框中的当前图
            currentView = (ZZTEditorImageView *)self.editor_squareRoundView.currentView;
        }
    }else{
        if([self.editorDeskView.currentView isKindOfClass:[ZZTEditorImageView class]]){
            currentView = (ZZTEditorImageView *)self.editorDeskView.currentView;
        }else{
            return nil;
        }
    }
    return currentView;
}

#pragma mark - ZZTEditorBrightnessViewDelegate
-(void)brightnessChangeWithTag:(NSInteger)tag Value:(CGFloat)value
{
    switch (tag) {
        case 105:
            [_colorControlsFilter setValue:[NSNumber numberWithFloat:value] forKey:@"inputBrightness"];
            
            break;
        case 106:
            [_colorControlsFilter setValue:[NSNumber numberWithFloat:value] forKey:@"inputSaturation"];//设置滤镜参数
            break;
        case 107:
            [_colorControlsFilter setValue:[NSNumber numberWithFloat:value] forKey:@"inputContrast"];
            break;
            
        default:
            break;
    }
    
    [self setImage];
    
}

-(void)setImage{
    
    CIImage *outputImage = [_colorControlsFilter outputImage];//取得输出图像
    
    CGImageRef temp = [_context createCGImage:outputImage fromRect:[outputImage extent]];
    
    ZZTEditorImageView *currentView = [[ZZTEditorImageView alloc] init];
    
    if(_editor_squareRoundView && _editor_squareRoundView.isBig == YES && ![self.editor_squareRoundView.currentView isKindOfClass:[ZZTEditorTextView class]]){
        
        //选中方框中的当前图
        currentView = (ZZTEditorImageView *)self.editor_squareRoundView.currentView;
        
    }else{
        if(![self.editorDeskView.currentView isKindOfClass:[ZZTEditorTextView class]] && ![self.editorDeskView.currentView isKindOfClass:[ZZTSquareRoundView class]]){
            currentView = (ZZTEditorImageView *)self.editorDeskView.currentView;
        }
    }
    
    currentView.imageView.image = [UIImage imageWithCGImage:temp];//转化为CGImage显示在界面中
    
    CGImageRelease(temp);//释放CGImage对象
}

//素材库
-(void)openTheMaterialLibrary{
    ZZTMaterialWindowView *materialWindow = [[ZZTMaterialWindowView alloc] init];
    _materialWindow = materialWindow;
    materialWindow.delegate = self;
    [self.view addSubview:materialWindow];
    
    [materialWindow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.height.mas_equalTo(ZZTLayoutDistance(800));
    }];
    
    [self materialTypeView:nil index:0];

    //收藏图素
    [_materialWindow.collectViewBtn addTarget:self action:@selector(collectMaterial) forControlEvents:UIControlEventTouchUpInside];
    //获取收藏数据
    weakself(self);
    _materialWindow.favoritesBlock = ^{
        [weakSelf loadCollectionMaterialData];
    };
    [_materialWindow.cameraBtn addTarget:self action:@selector(openAlbum) forControlEvents:UIControlEventTouchUpInside];
}

//打开本地相册
-(void)openAlbum{
    __block ZZTAlbumAlertControllerView *view = [ZZTAlbumAlertControllerView initAlbumAlertControllerViewWithAlertAction:^(NSInteger index) {
        if (index == 1) {
            [view takePhoto];
        }else{
            [view pushTZImagePickerController];
        }
    }];
    
    view.delegate = self;
    
    [view showZCAlert];
}

//本地素材
-(void)albumAlertControllerViewWithImg:(UIImage *)image{
    
    [self creatEditorImageViewWithImageUrl:nil img:image viewFrame:CGRectMake(SCREEN_WIDTH/2 - 75, 100, 200, 200)];

}

//收藏图素
-(void)collectMaterial{
    
    ZZTEditorImageView *imageView = [self getCurrentViewImg];
    
    if(imageView.imageUrl){
        //加载的
        [self uploadCollectIMGWithFodderImg:imageView.imageUrl fodderType:@"1"];
    }else{
        //本地的
        //上传到七牛云得到名字 然后再发给后台
        NSString *coverImgPath = [Utilities getCacheImagePath];
        
        [UIImagePNGRepresentation(imageView.imageView.image) writeToFile:coverImgPath atomically:YES];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 处理耗时操作的代码块...
            NSString *coverImg = [SYQiniuUpload QiniuPutSingleImage:coverImgPath complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                
            }];
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                [self uploadCollectIMGWithFodderImg:coverImg fodderType:@"2"];
            });
        });
    }
    
 
}

-(void)uploadCollectIMGWithFodderImg:(NSString *)coverImg fodderType:(NSString *)fodderType{
    NSDictionary *dic = @{
                          @"userId":[NSString stringWithFormat:@"%ld",[Utilities GetNSUserDefaults].id],
                          @"fodderImg":coverImg,
                          @"fodderType":fodderType
                          };
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"fodder/insertUserFodderCollect"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
    
-(void)materialTypeView:(UICollectionView *)materialTypeView index:(NSInteger)index{
    //点击其他type  请求新的数据
    NSDictionary *dict = @{
                           @"fodderType":[NSString stringWithFormat:@"%ld",index + 1]
                           };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:[ZZTAPI stringByAppendingString:@"fodder/fodderList"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        NSArray *array = [ZZTDetailModel mj_objectArrayWithKeyValuesArray:dic];
        self.materialWindow.materialArray = array;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//获取收藏数据
-(void)loadCollectionMaterialData{
    //点击其他type  请求新的数据
    NSDictionary *parameter = @{
                                @"userId":[NSString stringWithFormat:@"%ld",[Utilities GetNSUserDefaults].id],
                                };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:[ZZTAPI stringByAppendingString:@"fodder/getFodderCollectInfo"] parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        NSArray *array = [ZZTDetailModel mj_objectArrayWithKeyValuesArray:dic];
        self.materialWindow.materialArray = array;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
#pragma mark - 创建素材
- (void)materialContentView:(UICollectionView *)materialContentView materialModel:(ZZTDetailModel *)model kindIndex:(NSInteger)index materialIndex:(NSInteger)materialIndex materialImage:(UIImage *)materialImage{
    CGRect viewFrame = [self getMaterialFrameWithImage:materialImage];

    //index 1.布局 2.场景 3.角色 4.表情 5.效果 6.对话
    //框类
    if(index == 1){
        //框类型
        ZZTSquareRoundView *squareRoundView = [[ZZTSquareRoundView alloc] init];
        squareRoundView.squareRounddelegate = self;
        squareRoundView.delegate = self;
        
        //确定生成什么形状
        //方型 1
        if(model.modelType == 3){
            squareRoundView.frame = CGRectMake(50, 50, 140, 200);

        }else if (model.modelType == 4){
            squareRoundView.frame = CGRectMake(50, 50, 200, 140);

        }else{
            squareRoundView.frame = CGRectMake(50, 50, 200, 200);
        }
        
        squareRoundView.type = model.modelType;
        
        //判断  如果框类型是正在编辑状态的话
        if(_editor_squareRoundView && _editor_squareRoundView.isBig == YES){
           
        }else{
            //隐藏关闭按钮
            [self hiddenCurrentSRViewEditorBtn];
            [self hiddenCurrentImgViewCloseBtn];
            
            [self.editorDeskView Editor_addSubView:squareRoundView];
            //只要新创建一个方框 设置为当前方框
            _editor_squareRoundView = squareRoundView;
        }
    }else if(index == 6){
        CGFloat viewW = 0;
        CGFloat viewH = 0;
        if(materialImage){
            if(materialImage.size.width > materialImage.size.height){
                viewW = 200;
                viewH = 200 * materialImage.size.height / materialImage.size.width;
            }else{
                viewH = 200;
                viewW = 200 * materialImage.size.width / materialImage.size.height;
            }
        }
       //创建文字视图
        ZZTEditorImageView *textView = [self creatEditorImageViewWithImageUrl:model.img img:nil viewFrame:viewFrame];
        textView.type = model.modelType;
        
        //旁白
//        ZZTEditorTextView *textView = [[ZZTEditorTextView alloc] initWithFrame:CGRectMake(50, 50, 100, 30)];
//        //不同的对话框
//        textView.imageUrl = model.img;
//        textView.type = materialIndex;
//        textView.textViewDelegate = self;
//        [self addViewToDeskOrSRView:textView];

    }else{
        
        [self creatEditorImageViewWithImageUrl:model.img img:nil viewFrame:viewFrame];
        
    }
}

-(CGRect)getMaterialFrameWithImage:(UIImage *)image{
    CGFloat viewW = 0;
    CGFloat viewH = 0;
    CGRect imageFrame;
    if(image){
        if(image.size.width > image.size.height){
            viewW = 200;
            viewH = 200 * image.size.height / image.size.width;
        }else{
            viewH = 200;
            viewW = 200 * image.size.width / image.size.height;
        }
        imageFrame = CGRectMake(20, 30, viewW, viewH);
    }else{
        imageFrame = CGRectMake(20, 30, 200, 200);
    }
    return imageFrame;
}
#pragma mark - 旁白代理
-(void)textViewForCurrentView:(ZZTEditorBasisView *)textView{
    
    [self sendCurrentViewToDeskView:textView];
    
}

-(void)textViewShowInputView:(ZZTEditorTextView *)textView{
    
    ZZTInputView *inputView = [self showInputView];
    
    inputView.textView.text = textView.inputText;
}

-(ZZTEditorImageView *)creatEditorImageViewWithImageUrl:(NSString *)url img:(UIImage *)img viewFrame:(CGRect)viewFrame{
    //添加素材到界面中去
    //创建素材
    ZZTEditorImageView *newImageView = [[ZZTEditorImageView alloc] init];
    newImageView.frame = viewFrame;
    newImageView.imageViewDelegate = self;
    if(img == nil){
        newImageView.imageUrl = url;
    }else{
        [newImageView.imageView setImage:img];
    }
    [self addViewToDeskOrSRView:newImageView];
    return newImageView;
}

-(void)addViewToDeskOrSRView:(ZZTEditorBasisView *)basisView{
    //判断  如果框类型是正在编辑状态的话
    if(_editor_squareRoundView && _editor_squareRoundView.isBig == YES){
        [self.editor_squareRoundView Editor_addSubView:basisView];
    }else{
        [self.editorDeskView Editor_addSubView:basisView];
    }
//    //隐藏关闭按钮
    [self hiddenCurrentSRViewEditorBtn];
    [self hiddenCurrentImgViewCloseBtn];
    //设置为当前View
    [self sendCurrentViewToDeskView:basisView];
    
}
#pragma mark -ZZTEditorImageViewDelegate
//当前View
-(void)sendCurrentViewToDeskView:(ZZTEditorBasisView *)imageView{
    
    //切换上下页的时候 看父类是什么  如果是桌面 那么  就移动桌面上的
    //如果是 方框里面的  执行方框里的上下页方法
    if([imageView.superview isKindOfClass:[ZZTEditorDeskView class]]){
        NSLog(@"在桌面上");
        
        [self hiddenCurrentImgViewCloseBtn];
        
        self.editor_squareRoundView.currentView = nil;

        self.editorDeskView.currentView = imageView;
        
        [self showCurrentImgViewCloseBtn];
        
    }else{
        
        NSLog(@"在方框内");
        [self hiddenCurrentImgViewCloseBtn];
        
        self.editorDeskView.currentView = nil;

        self.editor_squareRoundView.currentView = imageView;
        
        [self showCurrentImgViewCloseBtn];
    }
}



#pragma mark - 显示输入框
-(void)showInputViewWithEditorImageView:(ZZTEditorImageView *)imageView hiddenState:(BOOL)state{
  
    if(state == NO){
        ZZTInputView *inputView = [self showInputView];
        
        inputView.curImageView = imageView;
        
        inputView.textView.text = imageView.inputText;
    }else{
        [_fontView removeFromSuperview];
        [self.inputView removeFromSuperview];
    }
 
}

-(ZZTInputView *)showInputView{
    [self.inputView removeFromSuperview];
    [self.fontView removeFromSuperview];
    
    ZZTEditorFontView *fontView = [[ZZTEditorFontView alloc] init];
    fontView.delegate = self;
    _fontView = fontView;
    [self.view addSubview:fontView];
    
    [fontView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.view);
        make.height.mas_equalTo(100);
    }];
    
    ZZTInputView *inputView = [[ZZTInputView alloc] init];
    self.inputView = inputView;
    [inputView.publishBtn setTitle:@"确定" forState:UIControlStateNormal];
    [inputView.publishBtn addTarget:self action:@selector(addTextToMessageView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inputView];
    
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view);
        make.bottom.equalTo(fontView.mas_top);
        make.height.mas_equalTo(50);
    }];
    
    if([[self getCurrentImageView] isKindOfClass:[ZZTEditorTextView class]]){
        ZZTEditorTextView *textView = (ZZTEditorTextView *)[self getCurrentImageView];
        fontView.fontValue = textView.fontSize;
    }else{
        fontView.currentView = @"ZZTEditorImageView";
    }
    
    return inputView;
}

#pragma mark - ZZTEditorFontViewDelegate
-(void)editorFontViewColorTarget:(NSString *)colorStr{
    //当前的textViewLab颜色改变
    ZZTEditorTextView *textView = (ZZTEditorTextView *)[self getCurrentImageView];
    textView.fontColor = colorStr;
}

-(void)editorFontViewSliderTarget:(UISlider *)slider{
    ZZTEditorTextView *textView = (ZZTEditorTextView *)[self getCurrentImageView];
    textView.fontSize = slider.value;
}

//得到当前textView
-(ZZTEditorBasisView *)getCurrentImageView{
    //当前View 在哪里的当前View 并且属性要对 才给他加
    ZZTEditorBasisView *currentView = [[ZZTEditorBasisView alloc] init];
    
    if(_editor_squareRoundView && _editor_squareRoundView.isBig == YES){
        //选中方框中的当前图
            currentView = self.editor_squareRoundView.currentView;
    }else{
            currentView = self.editorDeskView.currentView;
    }
    return currentView;
}

//得到当前imageView
-(ZZTEditorBasisView *)getCurrentTextView{
    //当前View 在哪里的当前View 并且属性要对 才给他加
    ZZTEditorBasisView *currentView = [[ZZTEditorBasisView alloc] init];
    
    if(_editor_squareRoundView && _editor_squareRoundView.isBig == YES){
        //选中方框中的当前图
        if([self.editor_squareRoundView.currentView isKindOfClass:[ZZTEditorImageView class]]){
            currentView = self.editor_squareRoundView.currentView;
        }
    }else{
        if([self.editor_squareRoundView.currentView isKindOfClass:[ZZTEditorImageView class]]){
            currentView = self.editorDeskView.currentView;
        }
    }
    return currentView;
}

//添加文字到视图上
-(void)addTextToMessageView{
    
    ZZTEditorBasisView *currentView = [self getCurrentImageView];
    
    if([currentView isKindOfClass:[ZZTEditorImageView class]]){
        ZZTEditorImageView *view = (ZZTEditorImageView *)currentView;
        if(view.type != editorImageViewTypeChat || view.type != editorImageViewTypeNormal){
      
            view.inputText = self.inputView.textView.text;
        }
    }else{
        ZZTEditorTextView *view = (ZZTEditorTextView *)currentView;
        view.inputText = self.inputView.textView.text;
    }
    
    [self.inputView removeFromSuperview];
    [self.fontView removeFromSuperview];
}

//清空
-(void)cleanAllView{
    ZZTRemindView *remindView = [ZZTRemindView sharedInstance];
    remindView.viewTitle = @"是否清空";
    remindView.tureBlock = ^(UIButton *btn) {
        [self.editorDeskView Editor_removeAllView];
    };
    [remindView show];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [UIApplication sharedApplication].statusBarHidden = YES;
    
    self.fd_interactivePopDisabled = YES;
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [IQKeyboardManager sharedManager].enable = NO;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
}

#pragma mark - 桌面代理
-(void)tapEditorDeskView{
    
    //方框隐藏编辑按钮
    [_editor_squareRoundView editorBtnHidden:YES];

    //是选中状态 那么就显示编辑
    
    //解除方框第一响应
    if(_editor_squareRoundView.isBig == NO){
        _editor_squareRoundView = nil;
    }

    //隐藏当前View的关闭按钮
    [self hiddenCurrentImgViewCloseBtn];
 
    [self.inputView removeFromSuperview];
    
    [self.fontView removeFromSuperview];
}

#pragma mark - 方框代理
-(void)setupViewForCurrentView:(ZZTEditorBasisView *)view{
    //如果点击的是方框
    if([view isKindOfClass:[ZZTSquareRoundView class]]){
        [_editor_squareRoundView editorBtnHidden:YES];
        //此方框为第一响应
        _editor_squareRoundView = (ZZTSquareRoundView *)view;
        if(_editor_squareRoundView.isBig == NO){
            //显示方框的编辑按钮
            [_editor_squareRoundView editorBtnHidden:NO];
        }else{
            //隐藏当前View的closeBtn
            [self hiddenCurrentImgViewCloseBtn];
        }
        self.editorDeskView.currentView = view;
    }
}

#pragma mark - 方框放大变小操作
//放大
-(void)squareRoundViewWillEditorWithView:(ZZTSquareRoundView *)squareRoundView{
    //获取View 在第几层
    for (NSInteger i = 0; i < self.editorDeskView.subviews.count; i++) {
        UIView *view = self.editorDeskView.subviews[i];
        if(squareRoundView == view){
            
            self.squareRoundIndex = i;
            
        }
    }
    
    //关闭按钮
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ZZTLayoutDistance(100))];
    [closeBtn setTitle:@"确定" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setBackgroundColor:[UIColor blackColor]];
    [closeBtn setTitleColor:ZZTSubColor forState:UIControlStateNormal];
    _closeBtn = closeBtn;
    [self.view addSubview:closeBtn];
    
    //在桌面找到这一视图
    _editor_squareRoundView = squareRoundView;
    
    //置于最后一层
    [self.editorDeskView bringSubviewToFront:_editor_squareRoundView];

    //知道方框当前处于什么层
    NSLog(@"subviews:%@",self.editorDeskView.subviews);
}

//变小
-(void)squareRoundViewDidEditorWithView:(ZZTSquareRoundView *)squareRoundView{
    [self.editorDeskView insertSubview:_editor_squareRoundView atIndex:self.squareRoundIndex];
    
    [squareRoundView editorBtnHidden:YES];
    [self hiddenCurrentImgViewCloseBtn];
}

//移除确定按钮
-(void)close:(ZZTSquareRoundView *)view{
    [self.closeBtn removeFromSuperview];
    //有问题 为nil 导致不能缩小
    [_editor_squareRoundView tapGestureTarget];
    if(_editor_squareRoundView == nil){
        NSLog(@"不可思议又为nil了");
    }
}


#pragma mark - 发布
-(void)releaseCartoon{
    
    if([[Utilities GetNSUserDefaults].userType isEqualToString:@"3"]){
        [MBProgressHUD showSuccess:@"您的身份是游客,请登录再发布"];
        [UserInfoManager needLogin];
        return;
    }
    
    ZZTRemindView *remindView = [ZZTRemindView sharedInstance];
    remindView.viewTitle = @"确认发布";
    remindView.tureBlock = ^(UIButton *btn) {
        [self releaseTarget];
    };
    [remindView show];
}

-(void)releaseTarget{
    
    [MBProgressHUD showMessage:@"正在发布..." toView:self.view];
    
    _releseImgArray = [NSMutableArray array];
    
    //遍历每一层 变成照片
    for (NSInteger i = 0; i < self.deskArray.count; i++) {
        [self changeThePageWith:i];
        
        [self hiddenCurrentImgViewCloseBtn];
        
        UIImage *screenShotImg = [self screenShotWithFrame:self.editorDeskView.frame];
        
        [self.releseImgArray addObject:screenShotImg];
    }
    //回调或者说是通知主线程刷新，
    //多图上传
    NSString * imageParms = @"";
    if (self.releseImgArray.count > 0) {
        imageParms = [SYQiniuUpload QiniuPutImageArray:self.releseImgArray complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            NSLog(@"info == %@ \n resp === %@",info,resp);
        }];
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
        NSDictionary *dict = @{
                               @"userId":[NSString stringWithFormat:@"%ld",[Utilities GetNSUserDefaults].id],
                               @"content":@"",
                               @"contentImg":imageParms,
                               @"boardId":@"0"
                               };
        [manager POST:[ZZTAPI stringByAppendingString:@"record/issueFriends"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:@"发送成功"];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:@"发送失败"];
        }];
    }
}

#pragma mark - 预览
-(void)previewCurrentView{
    //隐藏关闭按钮
    [self hiddenCurrentSRViewEditorBtn];
    [self hiddenCurrentImgViewCloseBtn];
    [_editor_squareRoundView editorBtnHidden:YES];

    UIImage *screenShotImg = [self screenShotWithFrame:self.editorDeskView.frame];
    
    //生成一imageView
    UIImageView *preViewImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _preViewImgView = preViewImgView;
    preViewImgView.image = screenShotImg;
    preViewImgView.userInteractionEnabled = YES;
    [self.view addSubview:preViewImgView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePreView)];
    [preViewImgView addGestureRecognizer:tapGesture];
}

//移除预览
-(void)removePreView{
    
    [_preViewImgView removeFromSuperview];
    
}

#pragma mark - 保存
-(void)saveCurrentView{
    
    ZZTRemindView *remindView = [ZZTRemindView sharedInstance];
    remindView.viewTitle = @"是否保存?";
    remindView.tureBlock = ^(UIButton *btn) {
        //隐藏关闭按钮
        [self hiddenCurrentSRViewEditorBtn];
        [self hiddenCurrentImgViewCloseBtn];
        [self.editor_squareRoundView editorBtnHidden:YES];
        
        //生成一张图片 保存到本地
        UIImage *screenShotImg = [self screenShotWithFrame:self.editorDeskView.frame];
        
        [self loadImageFinished:screenShotImg];
    };
    
    [remindView show];
  
}

- (void)loadImageFinished:(UIImage *)image
{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
       // /写入图片到相册
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        NSLog(@"success = %d, error = %@", success, error);
        
    }];
}


- (UIImage *)screenShotWithFrame:(CGRect )imageRect {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT), NO, 0.0);
    
    [self.editorDeskView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *screenShotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return screenShotImage;
}


#pragma mark - 上下一页
//上一页
-(void)clickOnThePreviousPage{
    NSLog(@"self.deskIndex:%ld count:%ld",self.deskIndex,self.deskArray.count);
    //安全操作
    if(self.deskIndex == 0){

        NSLog(@"已经是第一页");
        
        [self changeThePageWith:_deskIndex];
        
    }else{
        
        [self changeThePageWith:_deskIndex - 1];

        _deskIndex--;
        
    }
}

//下一页
-(void)clickOnTheNextPage{
    
    NSInteger nextIndex = self.deskIndex + 1;

    if(nextIndex == self.deskArray.count){
        _editorDeskView.hidden = YES;
        ZZTEditorDeskView *editorDeskView = [[ZZTEditorDeskView alloc] init];
        editorDeskView.delegate = self;
        _editorDeskView = editorDeskView;
        NSInteger index = [self.view.subviews indexOfObject:_topView];
        [self.view insertSubview:editorDeskView atIndex:index];
        
        [editorDeskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.bottom.equalTo(self.view);
        }];
        
        [_deskArray addObject:editorDeskView];
        
        _deskIndex++;

    }else if(nextIndex < self.deskArray.count){
        
        [self changeThePageWith:_deskIndex + 1];

        _deskIndex++;
    }
}

//切换上下页
-(void)changeThePageWith:(NSInteger)index{
    
    //切换上下页的时候 看父类是什么  如果是桌面 那么  就移动桌面上的
    //如果是 方框里面的  执行方框里的上下页方法
    ZZTEditorDeskView *editorDeskView = [_deskArray objectAtIndex:index];
    _editorDeskView.hidden = YES;
    editorDeskView.hidden = NO;
    _editorDeskView = editorDeskView;
}

@end
