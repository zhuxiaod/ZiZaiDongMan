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
#import "ZZTEditorPreviewView.h"
#import "ZZTEditorMaterialDetailView.h"

@interface ZZTEditorCartoonViewController ()<ZZTMaterialWindowViewDelegate,ZZTEditorImageViewDelegate,ZZTSquareRoundViewDelegate,ZZTEditorDeskViewdelegate,ZZTEditorBasisViewDelegate,ZZTColorPickerViewDelegate,ZZTEditorBrightnessView,ZZTAlbumAlertControllerViewDelegate,ZZTEditorTextViewDelegate,ZZTEditorFontViewDelegate,ZZTEditorMaterialDetailViewDelegate>{
    
    CIFilter *_colorControlsFilter;//色彩滤镜
    
    CIFilter *_hueFilter;//色相滤镜

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
//底部
@property (nonatomic,strong) ZZTEditorBottomView *bottomView;
@property (nonatomic,strong) UIButton *lastPageBtn;

@property (nonatomic,strong) UIButton *nextPageBtn;


@property (nonatomic,strong) ZZTEditorMaterialDetailView *materialDetailView;//分组框
@property (nonatomic,assign) BOOL collectStatus;
//素材类别索引
@property (nonatomic,assign) NSInteger collectIndex;
//填色slider
@property (nonatomic,strong) ZZTEditorBrightnessView *brightnessView;

@end

@implementation ZZTEditorCartoonViewController

- (NSMutableArray *)releseImgArray{
    if(_releseImgArray == nil){
        _releseImgArray = [NSMutableArray array];
    }
    return _releseImgArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _deskArray = [NSMutableArray array];
    
    //设置顶部UI
    [self setupUI];
    
    //请求布局
    [self loadData];
    
    self.collectStatus = NO;
    
    self.collectIndex = 0;
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
    //如果是X那么
    CGFloat topSpace = SCREEN_HEIGHT == 812.0f?30:0;
    CGFloat bottomSpace = SCREEN_HEIGHT == 812.0f?-49:0;
    
    [editorDeskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(topSpace);
        make.bottom.equalTo(self.view).offset(bottomSpace);
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
        make.top.equalTo(self.view).offset(topSpace);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(ZZTLayoutDistance(100));
    }];
    
    ZZTEditorBottomView *bottomView = [[ZZTEditorBottomView alloc] init];
    _bottomView = bottomView;
    [bottomView.materialBtn addTarget:self action:@selector(openTheMaterialLibrary) forControlEvents:UIControlEventTouchUpInside];
    [bottomView.lastBtn addTarget:self action:@selector(moveUpOneLevel) forControlEvents:UIControlEventTouchUpInside];
    [bottomView.nextBtn addTarget:self action:@selector(moveDownOneLevel) forControlEvents:UIControlEventTouchUpInside];
    [bottomView.colorBtn addTarget:self action:@selector(colorTheView) forControlEvents:UIControlEventTouchUpInside];
    [bottomView.paletteBtn addTarget:self action:@selector(paletteTheView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomView];
    

    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(bottomSpace);
        make.right.left.equalTo(self.view);
        make.height.mas_equalTo(ZZTLayoutDistance(130));
    }];
    
    //上一页
    UIButton *lastPageBtn = [self createButtionWithImg:@"上一页" selTaget:@selector(clickOnThePreviousPage)];
    _lastPageBtn = lastPageBtn;
    [self.view addSubview:lastPageBtn];

    [lastPageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomView.mas_top).offset(ZZTLayoutDistance(-100));
        make.left.equalTo(self.view).offset(10);
        make.width.height.mas_equalTo(ZZTLayoutDistance(70));
    }];
    
    //下一页
    UIButton *nextPageBtn = [self createButtionWithImg:@"下一页" selTaget:@selector(clickOnTheNextPage)];
    _nextPageBtn = nextPageBtn;
    [self.view addSubview:nextPageBtn];

    [nextPageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomView.mas_top).offset(ZZTLayoutDistance(-100));
        make.right.equalTo(self.view).offset(-10);
        make.width.height.mas_equalTo(ZZTLayoutDistance(70));
    }];
    
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotify:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

#pragma mark - 搜索功能
//前往搜索页
-(void)gotoSearchVC{
    
    ZXDSearchViewController *searchVC = [[ZXDSearchViewController alloc] init];
    searchVC.isFromEditorView = YES;
    //查找素材的坐标
    searchVC.getSearchMaterialData = ^(ZZTDetailModel *materialModel) {
        NSLog(@"materialModel:%@",materialModel);
        //跳转类别
//        _materialWindow;
        [self.materialWindow changeTypeCollectionViewWithIndex:[materialModel.fodderType integerValue] - 1];
        //加载数据 并 定为
        [self loadWindowDataAndPositioning:materialModel];
        
    };
    [self.navigationController pushViewController:searchVC animated:NO];
}

#pragma mark - 加载数据并定位
-(void)loadWindowDataAndPositioning:(ZZTDetailModel *)model{
    NSDictionary *dict = @{
                           @"fodderType":[NSString stringWithFormat:@"%ld", [model.fodderType integerValue]],
                           @"userId":[NSString stringWithFormat:@"%ld",[Utilities GetNSUserDefaults].id]
                           };
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    
    [manager POST:[ZZTAPI stringByAppendingString:@"fodder/fodderList"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        NSMutableArray *array = [ZZTDetailModel mj_objectArrayWithKeyValuesArray:dic];
        self.materialWindow.materialArray = array;
        [self.materialWindow postionMaterialData:model];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}



//快速创建btn
-(UIButton *)createButtionWithImg:(NSString *)img selTaget:(SEL)selTaget{
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [Btn setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    
    [Btn addTarget:self action:selTaget forControlEvents:UIControlEventTouchUpInside];
    return Btn;
}


#pragma mark 预览状态 隐藏
-(void)hiddenCurrentImgViewCloseBtn{
    //如果当前View是桌面上的
    if(self.editorDeskView.currentView){
        //如果是图
        if([self.editorDeskView.currentView isKindOfClass:[ZZTEditorImageView class]]){
            ZZTEditorImageView *currentView = (ZZTEditorImageView *)self.editorDeskView.currentView;
            currentView.imgView.hidden = YES;
        }else if([self.editorDeskView.currentView isKindOfClass:[ZZTEditorTextView class]]){
            ZZTEditorTextView *currentView = (ZZTEditorTextView *)self.editorDeskView.currentView;
            [currentView textViewHiddenState];
        }else if([self.editorDeskView.currentView isKindOfClass:[ZZTSquareRoundView class]]){
            [self hiddenCurrentSRViewEditorBtn];
        }
        self.editorDeskView.currentView = nil;
    }else{
        if([self.editor_squareRoundView.currentView isKindOfClass:[ZZTEditorImageView class]]){
            ZZTEditorImageView *currentView = (ZZTEditorImageView *)self.editor_squareRoundView.currentView;
            currentView.imgView.hidden = YES;
        }else if([self.editor_squareRoundView.currentView isKindOfClass:[ZZTEditorTextView class]]){
            ZZTEditorTextView *currentView = (ZZTEditorTextView *)self.editor_squareRoundView.currentView;
            [currentView textViewHiddenState];
        }
        self.editor_squareRoundView.currentView = nil;
    }
}
#pragma mark 预览状态 显示
-(void)showCurrentImgViewCloseBtn{
    
    if(self.editorDeskView.currentView){
        if([self.editorDeskView.currentView isKindOfClass:[ZZTEditorImageView class]]){
            ZZTEditorImageView *currentView = (ZZTEditorImageView *)self.editorDeskView.currentView;
            currentView.imgView.hidden = NO;
        }else if([self.editorDeskView.currentView isKindOfClass:[ZZTEditorTextView class]]){
            ZZTEditorTextView *currentView = (ZZTEditorTextView *)self.editorDeskView.currentView;
            [currentView textViewShowState];
        }
    }else{
        if([self.editor_squareRoundView.currentView isKindOfClass:[ZZTEditorImageView class]]){
            ZZTEditorImageView *currentView = (ZZTEditorImageView *)self.editor_squareRoundView.currentView;
            currentView.imgView.hidden = NO;
        }else if([self.editor_squareRoundView.currentView isKindOfClass:[ZZTEditorTextView class]]){
            ZZTEditorTextView *currentView = (ZZTEditorTextView *)self.editor_squareRoundView.currentView;
            [currentView textViewShowState];
        }
    }
}

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

#pragma mark - 返回
-(void)backLastVC{
    ZZTRemindView *remindView = [ZZTRemindView sharedInstance];
    remindView.viewTitle = @"是否确定退出";
    remindView.tureBlock = ^(UIButton *btn) {
        //清空桌面
        [self.editorDeskView Editor_removeAllView];
        //返回
        [self.navigationController popViewControllerAnimated:YES];
    };
    [remindView show];
}

-(void)loadData{
    
    //请求布局信息
}

#pragma mark - 上一层
-(void)moveUpOneLevel{
    if(self.editorDeskView.currentView){
        [self.editorDeskView Editor_moveCurrentImageViewToLastLayer];
    }else{
        [self.editor_squareRoundView SquareRound_moveCurrentImageViewToLastLayer];
    }
}

#pragma mark - 下一层
-(void)moveDownOneLevel{
    if(self.editorDeskView.currentView){
        [self.editorDeskView Editor_moveCurrentImageViewToNextLayer];
    }else{
        [self.editor_squareRoundView SquareRound_moveCurrentImageViewToNextLayer];
    }
}

#pragma mark - 填色功能
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

#pragma mark - 调色功能
-(void)paletteTheView{
    
    _context = [CIContext contextWithOptions:nil];//画布
    
    //亮度 饱和度 对比度 滤镜
    _colorControlsFilter = [CIFilter filterWithName:@"CIColorControls"];
    
    //色相滤镜
    _hueFilter = [CIFilter filterWithName:@"CIHueAdjust"];
    
    //设置需要修改的图像
    [self setupNewInputImage];

    //ZZTEditorBrightnessView
    ZZTEditorBrightnessView *brightnessView = [[ZZTEditorBrightnessView alloc] initWithFrame:CGRectMake(0, self.view.height - BrightnessToolBarHeight, self.view.width, BrightnessToolBarHeight)];
    
    _brightnessView = brightnessView;
    
    brightnessView.delegate = self;
    
    [self.view addSubview:brightnessView];
    
    //调色slider记录
    [self setupEditorBrightnessViewSliderValue];
}

//设置新的输入图片
-(void)setupNewInputImage{
    //拿到当前view的照片 判断
    ZZTEditorImageView *imageView = [self getCurrentViewImg];
    
    //初始化CIImage源图像
    _image = imageView.originalImg;
    
    NSLog(@"_image:%@",_image);
    NSLog(@"originalImg:%@",imageView.originalImg);
    
    [_colorControlsFilter setValue:_image forKey:@"inputImage"];//设置滤镜的输入图片
    
    [_hueFilter setValue:_image forKey:@"inputImage"];
}

//调色slider记录
-(void)setupEditorBrightnessViewSliderValue{
    
    ZZTEditorImageView *imageView = [self getCurrentViewImg];

    _brightnessView.imageViewModel = imageView;
    
    //重新设置
//    [_colorControlsFilter setValue:[NSNumber numberWithFloat:imageView.brightness] forKey:@"inputBrightness"];
//    [self setImageWithTag:105 Value:imageView.brightness];
//
//    [_colorControlsFilter setValue:[NSNumber numberWithFloat:imageView.saturation] forKey:@"inputSaturation"];//设置滤镜参数
//    [self setImageWithTag:106 Value:imageView.saturation];
//
//    [_colorControlsFilter setValue:[NSNumber numberWithFloat:imageView.contrast] forKey:@"inputContrast"];
//    [self setImageWithTag:107 Value:imageView.contrast];
//
//    [_hueFilter setValue:_colorControlsFilter.outputImage forKey:@"inputImage"];
//
//    [_hueFilter setValue:[NSNumber numberWithFloat:imageView.hue] forKey:@"inputAngle"];
//    [self setImageWithTag:108 Value:imageView.hue];
//
//    imageView.imageView.alpha = imageView.alpha;
}

#pragma mark - ZZTEditorBrightnessViewDelegate
-(void)brightnessChangeWithTag:(NSInteger)tag Value:(CGFloat)value img:(CIImage *)img
{
    //获取已被修改的图片
    if(tag == 108){
//        [_hueFilter setValue:_colorControlsFilter.outputImage forKey:@"inputImage"];
        [_hueFilter setValue:img forKey:@"inputImage"];
    }else{
//        [_colorControlsFilter setValue:_hueFilter.outputImage forKey:@"inputImage"];//设置滤镜的输入图片
        [_colorControlsFilter setValue:img forKey:@"inputImage"];//设置滤镜的输入图片
    }
    
    switch (tag) {
        case 105:
            [_colorControlsFilter setValue:[NSNumber numberWithFloat:value] forKey:@"inputBrightness"];
            [self setImageWithTag:tag Value:value];
            break;
        case 106:
            [_colorControlsFilter setValue:[NSNumber numberWithFloat:value] forKey:@"inputSaturation"];//设置滤镜参数
            [self setImageWithTag:tag Value:value];
            break;
        case 107:
            [_colorControlsFilter setValue:[NSNumber numberWithFloat:value] forKey:@"inputContrast"];
            [self setImageWithTag:tag Value:value];
            break;
        case 108://色相
            //拿到cgimage
            [_hueFilter setValue:[NSNumber numberWithFloat:value] forKey:@"inputAngle"];
            [self setImageWithTag:tag Value:value];
            break;
        case 109://透明度
            [self setImgAlphaWithValue:value];
            break;
        default:
            break;
    }
}

-(void)setImgAlphaWithValue:(CGFloat)value{
    ZZTEditorImageView *currentView = [self getCurrentWithPalette];
    currentView.imageView.alpha = value;
    currentView.alpha = value;
}

//导出修改完的图片
-(void)setImageWithTag:(NSInteger)tag Value:(CGFloat)value{
    
    CIImage *outputImage;
    
    if(tag == 108){
        //传一下
        //把那个编辑好的也传过来
        outputImage = [_hueFilter valueForKey:@"outputImage"];
    }else{
        outputImage = [_colorControlsFilter outputImage];//取得输出图像
    }
    
    CGImageRef temp = [_context createCGImage:outputImage fromRect:[outputImage extent]];
    
    ZZTEditorImageView *currentView = [self getCurrentWithPalette];
    
//    currentView.originalImg = outputImage;
    
    switch (tag) {
        case 105:
            currentView.brightness = value;
            break;
        case 106:
            currentView.saturation = value;
            break;
        case 107:
            currentView.contrast = value;
            break;
        case 108:
            currentView.hue = value;
            break;
        default:
            break;
    }
    
    currentView.imageView.image = [UIImage imageWithCGImage:temp];//转化为CGImage显示在界面中
    
    CGImageRelease(temp);//释放CGImage对象
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


#pragma mark 获得当前图 用于调色
-(ZZTEditorImageView *)getCurrentWithPalette{
    ZZTEditorImageView *currentView = [[ZZTEditorImageView alloc] init];
    //如果当前是放大状态 并且不是文本框
    if(_editor_squareRoundView && _editor_squareRoundView.isBig == YES && ![self.editor_squareRoundView.currentView isKindOfClass:[ZZTEditorTextView class]]){
        
        //选中方框中的当前图
        currentView = (ZZTEditorImageView *)self.editor_squareRoundView.currentView;
        
    }else{
        if(![self.editorDeskView.currentView isKindOfClass:[ZZTEditorTextView class]] && ![self.editorDeskView.currentView isKindOfClass:[ZZTSquareRoundView class]]){
            currentView = (ZZTEditorImageView *)self.editorDeskView.currentView;
        }
    }
    return currentView;
}

#pragma mark - 底部隐藏/显示
-(void)hiddenBottomView{
    _bottomView.hidden = YES;
    _nextPageBtn.hidden = YES;
    _lastPageBtn.hidden = YES;
    

}

//显示底部
-(void)showBottomView{
    _bottomView.hidden = NO;
    _nextPageBtn.hidden = NO;
    _lastPageBtn.hidden = NO;
    
//    _searchBtn.hidden = YES;

}

#pragma mark - 素材库
-(void)openTheMaterialLibrary{
    self.collectIndex = 0;
    //隐藏底部
    [self hiddenBottomView];
    
    ZZTMaterialWindowView *materialWindow = [[ZZTMaterialWindowView alloc] init];
    _materialWindow = materialWindow;
    materialWindow.delegate = self;
    [self.view addSubview:materialWindow];
    
    materialWindow.reloadMaterialData = ^{
        //刷新
        [self materialTypeView:nil index:self.collectIndex];
    };
    
    [materialWindow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.height.mas_equalTo(ZZTLayoutDistance(910));
    }];
    
    //加载初始数据
    [self materialTypeView:nil index:self.collectIndex];

    //收藏图素
    weakself(self);
    [_materialWindow.collectViewBtn addTarget:self action:@selector(collectMaterial:) forControlEvents:UIControlEventTouchUpInside];
    //获取收藏数据
    _materialWindow.favoritesBlock = ^{
        weakSelf.materialWindow.collectViewBtn.hidden = NO;
        
        weakSelf.collectStatus = YES;
        
        [weakSelf loadCollectionMaterialData];
    };
    
    [_materialWindow.cameraBtn addTarget:self action:@selector(openAlbum) forControlEvents:UIControlEventTouchUpInside];
    
    [_materialWindow.searchBtn addTarget:self action:@selector(gotoSearchVC) forControlEvents:UIControlEventTouchUpInside];
    
    [self reviseCollectBtnStatus];
}

-(void)materialWindowHidden{
    //素材框消失 下部显示出来
    [self showBottomView];
}

//打开本地相册
-(void)openAlbum{
    __block ZZTAlbumAlertControllerView *view = [ZZTAlbumAlertControllerView initAlbumAlertControllerViewWithAlertAction:^(NSInteger index) {
        if (index == 1) {
            [view takePhoto];
        }else{
            view.selectPhotoNum = 1;
            [view pushTZImagePickerController];
        }
    }];
    
    view.delegate = self;
    
    view.isImageClip = NO;
    
    [view showZCAlert];
    
}

//本地素材
-(void)albumAlertControllerViewWithImg:(NSArray *)phtots{
    UIImage *image = phtots[0];
    
    CGRect viewFrame = [self getMaterialFrameWithImage:image];

    [self creatEditorImageViewWithModel:nil img:image viewFrame:viewFrame];
    
    [self showBottomView];
}

#pragma mark - 收藏图素
-(void)collectMaterial:(UIButton *)btn{
    
    [self collectMaterialWithBtn:btn groupType:NO];
    
}

/*
 groupType:是否为组收藏
 */
-(void)collectMaterialWithBtn:(UIButton *)btn groupType:(BOOL)groupType{
    if(btn.selected == NO){
        
        if(groupType == YES){
            //如果为组收藏 那么没有选中素材 也可以收藏
            //组收藏
            [self materialDetailViewCollectSuccess:^{
                btn.selected = !btn.selected;
            }];
        }else{
            ZZTEditorImageView *imageView = [self getCurrentViewImg];
            
            if(imageView == nil){
                [MBProgressHUD showSuccess:@"请选中需要进行收藏的素材"];
                return;
            }
            
            if(imageView.imageUrl){
                //加载的
                [self uploadCollectIMGWithFodderImg:imageView.imageUrl fodderType:@"1" imageView:imageView Success:^{
                    btn.selected = !btn.selected;
                }];
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
                        [self uploadCollectIMGWithFodderImg:coverImg fodderType:@"2" imageView:nil Success:^{
                            btn.selected = !btn.selected;
                        }];
                    });
                });
            }
        }
        
    }else{
        
        NSDictionary *dict = [NSDictionary dictionary];
        
        ZZTEditorImageView *imageView = [self getCurrentViewImg];

        if(groupType == YES){
            //不选中就收藏
            dict = @{
                     //系统的
                     @"userId":[NSString stringWithFormat:@"%ld",[Utilities GetNSUserDefaults].id],
                     //系统默认的传数字
                     @"fodderId":[NSString stringWithFormat:@"%ld",_materialDetailView.model.id],//图片id 0
                     @"collectId":[NSString stringWithFormat:@"%ld",_materialDetailView.model.id]//收藏id 12
                     };
        }else{
            
            if(imageView == nil){
                return;
            }
            
            if([imageView.isCollectOpen isEqualToString:@"1"]){
                dict = @{
                         //普通打开
                         @"userId":[NSString stringWithFormat:@"%ld",[Utilities GetNSUserDefaults].id],
                         //系统默认的传数字
                         @"fodderId":[NSString stringWithFormat:@"%ld",imageView.fodderId],//图片id 0
                         @"collectId":imageView.imgId//收藏id 12
                         };
            }else if([imageView.isCollectOpen isEqualToString:@"0"]){
                dict = @{
                         //收藏打开
                         @"userId":[NSString stringWithFormat:@"%ld",[Utilities GetNSUserDefaults].id],
                         //系统默认的传数字
                         @"fodderId":imageView.imgId,//图片id 0
                         @"collectId":@"0"//收藏id 12
                         };
            }
        }
        AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];

        [manager POST:[ZZTAPI stringByAppendingString:@"fodder/deleteUserFodderCollect"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            imageView.ifCollect = @"0";
            //刷新素材的内容
            [self reloadMaterialData];
            btn.selected = !btn.selected;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}

//刷新素材数据
-(void)reloadMaterialData{
    if(self.collectStatus == YES){
        [self loadCollectionMaterialData];
    }else{
        [self materialTypeView:nil index:self.collectIndex];
    }
}

-(void)materialDetailViewCollectSuccess:(void (^)(void))success{
    NSDictionary *dic = @{
                          @"userId":[NSString stringWithFormat:@"%ld",[Utilities GetNSUserDefaults].id],
                          @"fodderImg":_materialDetailView.model.img,
                          @"fodderType":_materialDetailView.model.fodderType,//类型
                          @"fodderId":[NSString stringWithFormat:@"%ld",_materialDetailView.model.id],//图id
                          @"modelType":[NSString stringWithFormat:@"%ld",_materialDetailView.model.modelType]//几号
                          };
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    [manager POST:[ZZTAPI stringByAppendingString:@"fodder/insertUserFodderCollect"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //刷新素材的内容
        [self reloadMaterialData];
        success();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)uploadCollectIMGWithFodderImg:(NSString *)coverImg fodderType:(NSString *)fodderType imageView:(ZZTEditorImageView *)imageView Success:(void (^)(void))success{
    NSString *fodderId;//图id
    NSString *fodderTypeStr;//图id
    NSString *modelTypeStr;//图id

    if(imageView == nil){
        fodderId = @"0";
        fodderTypeStr = @"0";
        modelTypeStr = @"0";
    }else{
        fodderId = imageView.imgId;
        fodderTypeStr = imageView.kindIndex;
        modelTypeStr = imageView.modelType;
    }
    NSDictionary *dic = @{
                          @"userId":[NSString stringWithFormat:@"%ld",[Utilities GetNSUserDefaults].id],
                          @"fodderImg":coverImg,
                          @"fodderType":fodderTypeStr,//类型
                          @"fodderId":fodderId,//图id
                          @"modelType":modelTypeStr//几号
                          };
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    [manager POST:[ZZTAPI stringByAppendingString:@"fodder/insertUserFodderCollect"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZZTEditorImageView *imageView = [self getCurrentViewImg];
        imageView.ifCollect = @"1";
        //刷新素材的内容
        [self reloadMaterialData];
        success();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
    
-(void)materialTypeView:(UICollectionView *)materialTypeView index:(NSInteger)index{
    
    self.collectIndex = index;
    
    self.collectStatus = NO;
    
    //点击其他type  请求新的数据
    NSDictionary *dict = @{
                           @"fodderType":[NSString stringWithFormat:@"%ld",index + 1],
                           @"userId":[NSString stringWithFormat:@"%ld",[Utilities GetNSUserDefaults].id]
                           };
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    
    [manager POST:[ZZTAPI stringByAppendingString:@"fodder/fodderList"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        NSMutableArray *array = [ZZTDetailModel mj_objectArrayWithKeyValuesArray:dic];
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
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    
    [manager POST:[ZZTAPI stringByAppendingString:@"fodder/getFodderCollectInfo"] parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        NSMutableArray *array = [ZZTDetailModel mj_objectArrayWithKeyValuesArray:dic];
        self.materialWindow.materialArray = array;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 创建素材
- (void)materialContentView:(UICollectionView *)materialContentView materialModel:(ZZTDetailModel *)model kindIndex:(NSInteger)index materialIndex:(NSInteger)materialIndex materialImage:(UIImage *)materialImage{
    
    CGRect viewFrame = [self getMaterialFrameWithImage:materialImage];
    
    [self hiddenCurrentImgViewCloseBtn];
    
    //index 1.布局 2.场景 3.角色 4.表情 5.效果 6.对话
    //框类
    if(index == 1){
        CGRect viewFrame;
        
        //确定生成什么形状
        //方型 1
        if(model.modelType == 3){
            viewFrame = CGRectMake(50, 50, 140, 200);
            
        }else if (model.modelType == 4){
            viewFrame = CGRectMake(50, 50, 200, 140);
            
        }else{
            viewFrame = CGRectMake(50, 50, 200, 200);
        }
        
        //框类型
        ZZTSquareRoundView *squareRoundView = [[ZZTSquareRoundView alloc] initWithFrame:viewFrame];
        squareRoundView.squareRounddelegate = self;
        squareRoundView.delegate = self;
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

        //旁白框
        if(model.modelType == 12 || model.modelType == 13){
            //旁白
            ZZTEditorTextView *textView = [[ZZTEditorTextView alloc] initWithFrame:CGRectMake(50, 50, 100, 142)];
            //不同的对话框
            textView.type = model.modelType;
            textView.kindIndex = [NSString stringWithFormat:@"%ld",index];
            textView.textViewDelegate = self;
            [self addViewToDeskOrSRView:textView];
        }else{
            //创建文字视图
            ZZTEditorImageView *textView = [self creatEditorImageViewWithModel:model img:nil viewFrame:viewFrame];
            textView.kindIndex = [NSString stringWithFormat:@"%ld",index];
            textView.type = model.modelType;
        }
    }else{
        
        ZZTEditorImageView *textView = [self creatEditorImageViewWithModel:model img:nil viewFrame:viewFrame];
        textView.kindIndex = [NSString stringWithFormat:@"%ld",index];

    }
    [self reviseCollectBtnStatus];

//    [self showBottomView];
}

-(void)reviseCollectBtnStatus{
    //删除时
    //生成时
    //收藏时
    //如果当前图 属性为yes 那么btn改
    ZZTEditorImageView *imageView = [self getCurrentViewImg];
    if([imageView.ifCollect isEqualToString:@"1"] || imageView.fodderId != 0){
        self.materialWindow.collectViewBtn.selected = YES;
//        self.materialDetailView.collectViewBtn.selected = YES;
    }
}


#pragma mark - 创建分组框
- (void)createEditorMaterialDetailViewWithID:(NSString *)materialId superModel:(ZZTDetailModel *)superModel kindIndex:(NSInteger)kindIndex{
    [_materialDetailView removeFromSuperview];
    //隐藏素材的按钮
    self.materialWindow.collectViewBtn.hidden = YES;
    self.materialWindow.cameraBtn.hidden = YES;
    
    ZZTEditorMaterialDetailView *materialDetailView = [[ZZTEditorMaterialDetailView alloc] init];
    [materialDetailView.collectViewBtn addTarget:self action:@selector(MaterialDetailViewCollection:) forControlEvents:UIControlEventTouchUpInside];
    _materialDetailView = materialDetailView;
    materialDetailView.delegate = self;
    materialDetailView.kindIndex = kindIndex;
    materialDetailView.model = superModel;
    materialDetailView.superId = materialId;
    [self.view addSubview:materialDetailView];
    
    [materialDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(ZZTLayoutDistance(-716));
        make.right.equalTo(self.view.mas_right).offset(-ZZTLayoutDistance(24));
        make.left.equalTo(self.view.mas_left).offset(ZZTLayoutDistance(24));
        make.height.mas_equalTo(ZZTLayoutDistance(300) + 16);
    }];
    
    //请求数据
    NSDictionary *dict = @{
                           @"fodderId":[NSString stringWithFormat:@"%ld",materialId]
                           };
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    [manager POST:[ZZTAPI stringByAppendingString:@"fodder/getFodderMulticlassList"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [[EncryptionTools alloc] decry:responseObject[@"result"]];
        NSArray *array = [ZZTDetailModel mj_objectArrayWithKeyValuesArray:dic];
        NSLog(@"array:%@",array);
        materialDetailView.imgArray = array;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    if(superModel.ifCollect == 1){
        self.materialDetailView.collectViewBtn.selected = YES;
    }
    
    [self reviseCollectBtnStatus];

}
//显示被隐藏的内容
-(void)materialDetailViewRemoveTarget{
    self.materialWindow.collectViewBtn.hidden = NO;
    
    self.materialWindow.cameraBtn.hidden = NO;
}

#pragma mark - 素材组收藏
-(void)MaterialDetailViewCollection:(UIButton *)btn{
//    btn.selected = !btn.selected;
    
    [self collectMaterialWithBtn:btn groupType:YES];
//
//    //如果这个View在 那么
//    if(self.editorDeskView.currentView || self.editor_squareRoundView.currentView){
//    }else{
//        NSLog(@"没有");
//    }
}

//点击组图  生成素材
-(void)sendMaterialDetailWithKindIndex:(NSInteger)index materialImage:(UIImage *)materialImage model:(ZZTDetailModel *)model{
    // materialImage 图片
    // model 图片数据
    [self materialContentView:nil materialModel:model kindIndex:index materialIndex:0 materialImage:materialImage];
}

-(CGRect)getMaterialFrameWithImage:(UIImage *)image{
    NSLog(@"imageW :%f imageH :%f",image.size.width,image.size.height);
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

-(void)textViewHidden{
    [self.inputView removeFromSuperview];
    [self.fontView removeFromSuperview];
}

-(ZZTEditorImageView *)creatEditorImageViewWithModel:(ZZTDetailModel *)model img:(UIImage *)img viewFrame:(CGRect)viewFrame{
    //添加素材到界面中去
    //创建素材
    ZZTEditorImageView *newImageView = [[ZZTEditorImageView alloc] init];
    newImageView.fodderId = model.fodderId;
    newImageView.frame = viewFrame;
    newImageView.imgId = [NSString stringWithFormat:@"%ld",model.id];
    newImageView.imageViewDelegate = self;
    newImageView.ifCollect = [NSString stringWithFormat:@"%ld",model.ifCollect];;
    newImageView.modelType = [NSString stringWithFormat:@"%ld",model.modelType];
    
    if(self.collectStatus == YES){
        newImageView.ifCollect = @"1";
        newImageView.isCollectOpen = @"1";
    }else{
        newImageView.isCollectOpen = @"0";
    }
    if(img == nil){
        newImageView.imageUrl = model.img;
    }else{
        [newImageView.imageView setImage:img];
        newImageView.originalImg = [CIImage imageWithCGImage:img.CGImage];
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
#pragma mark - ZZTEditorImageViewDelegate
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

-(void)EditorImageViewCannelCurrentView{
    self.editor_squareRoundView.currentView = nil;
    self.editorDeskView.currentView = nil;
    [self showBottomView];
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

-(void)hiddenInputView{
    [self.inputView removeFromSuperview];
    [self.fontView removeFromSuperview];
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
    textView.viewScale = slider.value;
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

    UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    statusBar.alpha = 0;
    
    self.fd_interactivePopDisabled = YES;
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [IQKeyboardManager sharedManager].enable = NO;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    statusBar.alpha = 1;
}

#pragma mark - 桌面代理
-(void)tapEditorDeskView{
    
    [self showBottomView];
    
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
    
    [self.materialDetailView removeFromSuperview];
    
}

#pragma mark - 方框代理
-(void)setupViewForCurrentView:(ZZTEditorBasisView *)view{
    [self hiddenCurrentImgViewCloseBtn];

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
            [self showBottomView];
        }
        self.editorDeskView.currentView = view;
    }
}

-(void)squareRoundViewDidPinch:(ZZTSquareRoundView *)squareRoundView{
    [squareRoundView setNeedsLayout];
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
    
    [self addEndPageIMG];
    
    //将数组传给发布空间页
    
    ZZTZoneUpLoadViewController *uploadVC = [[ZZTZoneUpLoadViewController alloc] init];
    
    uploadVC.xuHuaModel = self.xuHuaModel;
    
    uploadVC.addPhotosArray = self.releseImgArray;
    
    [self presentViewController:uploadVC animated:YES completion:nil];

}

//隐藏所有无关按钮
-(void)hiddenAllBtn{
    //隐藏关闭按钮
    [self hiddenCurrentSRViewEditorBtn];
    [self hiddenCurrentImgViewCloseBtn];
    [_editor_squareRoundView editorBtnHidden:YES];
}

#pragma mark - 预览
-(void)previewCurrentView{
    //隐藏关闭按钮
    [self hiddenAllBtn];
    
    [self addEndPageIMG];
  
    ZZTEditorPreviewView *previewView = [[ZZTEditorPreviewView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:previewView];
    
    previewView.imgArray = self.releseImgArray;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    previewView.currentIndex = _deskIndex;
}

//查看最后一页是否添加
-(void)addEndPageIMG{
    UIImage *screenShotImg = [self screenShotWithFrame:self.editorDeskView.frame];
    
    [self addImgToReleseImgArrayWithIndex:_deskIndex img:screenShotImg];
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

- (UIImage *)screenShotWithFrame:(CGRect)imageRect {
    [self hiddenAllBtn];
    
    UIImage *image = [UIImage imageNamed:@"watermark"];
   //2.0几倍大小
    UIGraphicsBeginImageContextWithOptions(self.editorDeskView.frame.size, YES, 2.0);
    
    [self.editorDeskView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //水印
    [image drawInRect:CGRectMake(SCREEN_WIDTH - 54, SCREEN_HEIGHT - 68, 50, 64)];
    
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
        
        UIImage *screenShotImg = [self screenShotWithFrame:self.editorDeskView.frame];
        
        [self addImgToReleseImgArrayWithIndex:_deskIndex img:screenShotImg];

        [self changeThePageWith:_deskIndex];
        
    }else{
        
        UIImage *screenShotImg = [self screenShotWithFrame:self.editorDeskView.frame];
        
        [self addImgToReleseImgArrayWithIndex:_deskIndex img:screenShotImg];
        
        [self changeThePageWith:_deskIndex - 1];

        _deskIndex--;
        
    }
}

//下一页
-(void)clickOnTheNextPage{
    
    NSInteger nextIndex = self.deskIndex + 1;

    if(nextIndex == self.deskArray.count){
        //加入一张当前桌面到数组之中
        UIImage *screenShotImg = [self screenShotWithFrame:self.editorDeskView.frame];
        [self addImgToReleseImgArrayWithIndex:_deskIndex img:screenShotImg];
        
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
        
        UIImage *screenShotImg = [self screenShotWithFrame:self.editorDeskView.frame];
        
        [self addImgToReleseImgArrayWithIndex:_deskIndex img:screenShotImg];

        [self changeThePageWith:_deskIndex + 1];
        
        _deskIndex++;
    }
}

//添加图片到数组之中
-(void)addImgToReleseImgArrayWithIndex:(NSInteger)index img:(UIImage *)img{
//    NSLog(@"现在加入第%ld页",index);
    NSInteger isEnd;
    if(self.releseImgArray.count == 0){
        isEnd = 0;
    }else{
        isEnd  = self.releseImgArray.count;
    }
    
    if(index == isEnd){
        [self.releseImgArray addObject:img];
    }else{
        [self.releseImgArray replaceObjectAtIndex:index withObject:img];
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

-(void)setXuHuaModel:(ZZTChapterlistModel *)xuHuaModel{
    _xuHuaModel = xuHuaModel;
}
@end
