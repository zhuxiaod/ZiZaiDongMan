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

@interface ZZTEditorCartoonViewController ()<ZZTMaterialWindowViewDelegate,ZZTEditorImageViewDelegate>

@property (nonatomic,strong) ZZTEditorDeskView *editorDeskView;

@end

@implementation ZZTEditorCartoonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置顶部UI
    [self setupUI];
    
    //请求布局
    [self loadData];
}

-(void)setupUI{
    ZZTEditorDeskView *editorDeskView = [[ZZTEditorDeskView alloc] init];
    _editorDeskView = editorDeskView;
    [self.view addSubview:editorDeskView];
    
    [editorDeskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self.view);
    }];

    
    ZZTEditorTopView *topView = [[ZZTEditorTopView alloc] init];
    [topView.backBtn addTarget:self action:@selector(backLastVC) forControlEvents:UIControlEventTouchUpInside];
    [topView.deletBtn addTarget:self action:@selector(cleanAllView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(ZZTLayoutDistance(100));
    }];
    
    ZZTEditorBottomView *bottomView = [[ZZTEditorBottomView alloc] init];
    [bottomView.materialBtn addTarget:self action:@selector(openTheMaterialLibrary) forControlEvents:UIControlEventTouchUpInside];
    [bottomView.lastBtn addTarget:self action:@selector(moveUpOneLevel) forControlEvents:UIControlEventTouchUpInside];
    [bottomView.nextBtn addTarget:self action:@selector(moveDownOneLevel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.view);
        make.height.mas_equalTo(ZZTLayoutDistance(130));
    }];
    
    //上一页
    UIButton *lastPageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lastPageBtn setImage:[UIImage imageNamed:@"上一页"] forState:UIControlStateNormal];
    [self.view addSubview:lastPageBtn];
    
    [lastPageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomView.mas_top).offset(ZZTLayoutDistance(-100));
        make.left.equalTo(self.view).offset(10);
        make.width.height.mas_equalTo(ZZTLayoutDistance(70));
    }];
    
    //下一页
    UIButton *nextPageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextPageBtn setImage:[UIImage imageNamed:@"下一页"] forState:UIControlStateNormal];
    [self.view addSubview:nextPageBtn];
    
    [nextPageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomView.mas_top).offset(ZZTLayoutDistance(-100));
        make.right.equalTo(self.view).offset(-10);
        make.width.height.mas_equalTo(ZZTLayoutDistance(70));
    }];
}

//返回上一页面
-(void)backLastVC{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadData{
    
    //请求布局信息
}

//上一层
-(void)moveUpOneLevel{
    [self.editorDeskView Editor_moveCurrentImageViewToLastLayer];
}

//下一层
-(void)moveDownOneLevel{
    
    [self.editorDeskView Editor_moveCurrentImageViewToNextLayer];

}

//填色
-(void)colorTheView{
    
}

//调色
-(void)paletteTheView{
    
}

//素材库
-(void)openTheMaterialLibrary{
    ZZTMaterialWindowView *materialWindow = [[ZZTMaterialWindowView alloc] init];
    materialWindow.delegate = self;
    [self.view addSubview:materialWindow];
    
    [materialWindow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.height.mas_equalTo(ZZTLayoutDistance(800));
    }];
}

-(void)materialTypeView:(UICollectionView *)materialTypeView index:(NSInteger)index{
    //点击其他type  请求新的数据
    
    //刷新
}

-(void)materialContentView:(UICollectionView *)materialContentView index:(NSInteger)index{
    
    //创建素材
//    ZZTEditorImageView *newImageView = [[ZZTEditorImageView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
//    newImageView.imageViewDelegate = self;
//    newImageView.imageUrl = @"http://img.cdn.zztian.cn/zmnmsy.jpg";
//    [self.editorDeskView Editor_addSubView:newImageView];

    
    //创建对话框
    
    //框类型
    
    //图片型
    
    //写字型
}

//当前View
-(void)sendCurrentViewToDeskView:(ZZTEditorImageView *)imageView{
    
    self.editorDeskView.currentView = imageView;
    
}

//上一页
-(void)clickOnThePreviousPage{
    
}

//下一页
-(void)clickOnTheNextPage{
    
}

//清空
-(void)cleanAllView{
    
    [self.editorDeskView Editor_removeAllView];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [UIApplication sharedApplication].statusBarHidden = YES;
    
    self.fd_interactivePopDisabled = YES;
}



@end
