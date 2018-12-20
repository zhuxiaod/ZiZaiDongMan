//
//  ZZTCartCoverSetView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/15.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTCartCoverSetView.h"
#import "replyCountView.h"

@interface ZZTCartCoverSetView ()<TZImagePickerControllerDelegate>

@property (nonatomic,strong) SBStrokeLabel *coverLab;

@property (nonatomic,strong) SBStrokeLabel *bannerLab;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UILabel *remindLab;
//评论
@property (strong, nonatomic) replyCountView *replyCountView;
//点赞
@property (strong, nonatomic) likeCountView *likeCountView;

@property (assign, nonatomic) NSInteger imageType;

@end

@implementation ZZTCartCoverSetView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        //添加UI
        [self addUI];
        
    }
    return self;
}

-(void)addUI{
//    200 - 42
    //540 * 390
    UIImageView *coverImgView = [[UIImageView alloc] init];
    coverImgView.backgroundColor = [UIColor redColor];
    _coverImgView = coverImgView;
    [self addSubview:coverImgView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCoverImgView)];
    [coverImgView addGestureRecognizer:tapGesture];
    coverImgView.userInteractionEnabled = YES;

    
    SBStrokeLabel *coverLab = [[SBStrokeLabel alloc] init];
    coverLab.textColor = [UIColor whiteColor];
    coverLab.text = @"540*390";
    [coverLab labOutline];
    _coverLab = coverLab;
    [self addSubview:coverLab];
    
    //1080 * 650
    UIImageView *bannerImgView = [[UIImageView alloc] init];
    bannerImgView.backgroundColor = [UIColor blueColor];
    [bannerImgView setContentMode:UIViewContentModeScaleAspectFill];
    
    bannerImgView.clipsToBounds = YES;
    _bannerImgView = bannerImgView;
    [self addSubview:bannerImgView];
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBannerImgView)];
    [bannerImgView addGestureRecognizer:tapGesture1];
    bannerImgView.userInteractionEnabled = YES;
    
    SBStrokeLabel *bannerLab = [[SBStrokeLabel alloc] init];
    bannerLab.textColor = [UIColor whiteColor];
    bannerLab.text = @"1080*650";
    [bannerLab labOutline];
    _bannerLab= bannerLab;
    [self addSubview:bannerLab];
    
    //点击图片条
    UILabel *remindLab = [[UILabel alloc] init];
    _remindLab = remindLab;
    remindLab.text = @"点击图片更换封面与轮播图";
    remindLab.textColor = [UIColor lightGrayColor];
    [self addSubview:remindLab];
    
    //底部条
    UIView *bottomView = [[UIView alloc] init];
    _bottomView = bottomView;
    bottomView.backgroundColor = ZZTLineColor;
    [self addSubview:bottomView];
    
    //点击图片btn
    self.imageType = 0;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat space = 10.0f;
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.right.left.equalTo(self);
        make.height.mas_equalTo(4);
    }];
    
    [self.remindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_top).offset(-4);
        make.left.equalTo(self).offset(space);
        make.height.mas_equalTo(20);
    }];
    
    [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(space);
        make.top.equalTo(self).offset(space);
        make.bottom.equalTo(self.remindLab.mas_top).offset(-4);
        make.width.mas_equalTo(114);
    }];
    
    [self.coverLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.coverImgView.mas_centerX);
        make.bottom.equalTo(self.coverImgView.mas_bottom).offset(-4);
        make.height.mas_equalTo(20);
    }];
    
    [self.bannerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImgView.mas_right).offset(10);
        make.bottom.equalTo(self.coverImgView.mas_bottom);
        make.top.equalTo(self.coverImgView.mas_top);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    [self.bannerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bannerImgView.mas_centerX);
        make.bottom.equalTo(self.bannerImgView.mas_bottom).offset(-4);
        make.height.mas_equalTo(20);
    }];
    
    [self.replyCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.remindLab);
        make.right.equalTo(self.mas_right).offset(-space);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(60);
    }];
    
    [self.likeCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.replyCountView);
        make.right.equalTo(self.replyCountView.mas_left).offset(-space);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(60);
    }];
}

-(void)clickCoverImgView{
    self.imageType = 1;
    NSLog(@"clickCoverImgView");
    //打开照片选择
    //如果选择张片是540 * 390 那么上传
    [self pushTZImagePickerController];

}

-(void)clickBannerImgView{
    self.imageType = 2;

    NSLog(@"clickBannerImgView");
    [self pushTZImagePickerController];
}

//图片选择控制器
#pragma mark - TZImagePickerController
- (void)pushTZImagePickerController {
    //最大选择数   最大显示照片
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    // imagePickerVc.navigationBar.translucent = NO;
    
    imagePickerVc.naviBgColor = [UIColor grayColor];
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = YES;
    
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
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    imagePickerVc.statusBarStyle = UIStatusBarStyleDefault;
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = YES;
    
#pragma mark - 到这里为止
    
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        UIImage *img = photos[0];
        if(self.imageType == 1){
            if(img.size.width == 390 && img.size.height == 540){
                self.coverImgView.image = img;
            }else{
                NSLog(@"图片不符合标准");
                [MBProgressHUD showSuccess:@"图片尺寸不符合标准" toView:[self myViewController].view];
            }
        }
        if(self.imageType == 2){
            if(img.size.width == 1080 && img.size.height == 650){
                self.bannerImgView.image = img;
            }else{
                NSLog(@"图片不符合标准");
                [MBProgressHUD showSuccess:@"图片尺寸不符合标准" toView:[self myViewController].view];
            }
        }
       
        
        
        self.imageType = 0;
    }];
    
    [[self myViewController] presentViewController:imagePickerVc animated:YES completion:nil];
}












//评论
- (replyCountView *)replyCountView {
    if (!_replyCountView) {
        
        replyCountView *btn = [[replyCountView alloc]init];
        
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        
        [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        
        [self addSubview:btn];
        
        _replyCountView = btn;
    }
    
    return _replyCountView;
}

- (likeCountView *)likeCountView {
    if (!_likeCountView) {
        
        likeCountView *lcv = [[likeCountView alloc] init];
        
        lcv.userInteractionEnabled = NO;
        
        lcv.titleLabel.textColor = ZZTSubColor;
        
        [lcv setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        
        [lcv setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        
        weakself(self);
        //发现点赞
        [lcv setOnClick:^(likeCountView *btn) {
            //用户点赞
//            [self userLikeTarget];
        }];
        
        [self addSubview:lcv];
        
        _likeCountView = lcv;
    }
    return _likeCountView;
}

-(void)setImgModel:(ZZTCarttonDetailModel *)imgModel{
    _imgModel = imgModel;
    
    [self.bannerImgView sd_setImageWithURL:[NSURL URLWithString:imgModel.lbCover] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:imgModel.cover] placeholderImage:nil options:0];

}

@end
