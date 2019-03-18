//
//  ZZTMaterialWindowView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/25.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTMaterialWindowView.h"
#import "ZZTMaterialTypeCell.h"
#import "ZZTKindModel.h"
#import "ZZTDetailModel.h"
#import "ZZTEditorImgCell.h"
#import "ZZTAlbumAlertControllerView.h"
#import "ZZTMallDetailViewController.h"

@interface ZZTMaterialWindowView ()<UICollectionViewDataSource,UICollectionViewDelegate,ZZTMaterialWindowViewDelegate,ZZTAlbumAlertControllerViewDelegate>

@property(nonatomic , weak)UIView *topView;
@property(nonatomic , weak)UIView *midView;
@property(nonatomic , weak)UIView *bottomView;
@property (nonatomic ,strong)NSArray *typeArray;
@property(nonatomic , weak)UIView *midLine;
@property(nonatomic , assign)NSInteger materialIndex;
@property(nonatomic , assign)BOOL isCollect;
@property (nonatomic ,strong) ZZTKindModel *selectKindModel;
@property (nonatomic ,weak) UIButton *topBtn;
@property (nonatomic ,strong) NSString *fodderType;

@end

@implementation ZZTMaterialWindowView

-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        self.typeArray = @[[ZZTKindModel initKindModelWith:@"布局" isSelect:@"1"],
                           [ZZTKindModel initKindModelWith:@"场景" isSelect:@"0"],
                           [ZZTKindModel initKindModelWith:@"角色" isSelect:@"0"],
                           [ZZTKindModel initKindModelWith:@"表情" isSelect:@"0"],
                           [ZZTKindModel initKindModelWith:@"效果" isSelect:@"0"],
                           [ZZTKindModel initKindModelWith:@"对话" isSelect:@"0"],
                           ];
        
        self.fodderType = @"0";
        
        _selectKindModel = self.typeArray[0];
        
        self.delegate = self;
        
        //添加UI
        [self addUI];

        //直接传一个数组过来
        self.materialIndex = 1;
        
        self.isCollect = NO;
        
    }
    return self;
}
//设置数据
-(void)setMaterialArray:(NSMutableArray *)materialArray{
    _materialArray = materialArray;
    if(![_selectKindModel.kindTitle isEqualToString:@"布局"] && ![_selectKindModel.kindTitle isEqualToString:@"对话"]){
        //插入一个
        ZZTDetailModel *model = [ZZTDetailModel initDetailModelWith:@"editorUpload" flag:0 ifCollect:0];
        [self.materialArray insertObject:model atIndex:0];
    }
    [self.contentCollectionView reloadData];
}

-(void)addUI{
    //3个部分
    //按钮区
    UIView *topView = [[UIView alloc] init];
    _topView = topView;
    topView.backgroundColor = [UIColor clearColor];
    [self addSubview:topView];
    
    //底部空白区域
    UIButton *topBtn = [[UIButton alloc] init];
    [topBtn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    _topBtn = topBtn;
    [topView addSubview:topBtn];
    
    //搜索按钮
    UIButton *searchBtn = [GlobalUI createButtonWithImg:[UIImage imageNamed:@"editorSearch"] title:nil titleColor:nil];
    _searchBtn = searchBtn;
    searchBtn.userInteractionEnabled = YES;
    [topView addSubview:searchBtn];
    
    //收藏 相机
    UIButton *collectViewBtn = [GlobalUI createButtonWithImg:[UIImage imageNamed:@"editor_noCollection"] title:nil titleColor:nil];
    [collectViewBtn setImage:[UIImage imageNamed:@"editor_collect_select"] forState:UIControlStateSelected];
    _collectViewBtn = collectViewBtn;
    [topView addSubview:collectViewBtn];
    
    UIButton *cameraBtn = [GlobalUI createButtonWithImg:[UIImage imageNamed:@"editor_camera"] title:nil titleColor:nil];
    _cameraBtn = cameraBtn;
    [topView addSubview:cameraBtn];
    /********************************************************************/

    //分类区
    UIView *midView = [[UIView alloc] init];
    _midView = midView;
    midView.backgroundColor = [UIColor colorWithHexString:@"#1C1522" alpha:0.7];
    [self addSubview:midView];
    
    UIButton *favoritesBtn = [GlobalUI createButtonWithImg:[UIImage imageNamed:@"收藏夹"] title:nil titleColor:nil];
    _favoritesBtn = favoritesBtn;
    [midView addSubview:favoritesBtn];
    
    UIView *midLine = [[UIView alloc] init];
    _midLine = midLine;
    midLine.backgroundColor = [UIColor lightGrayColor];
    [midView addSubview:midLine];
    
    //选择区
    UIView *bottomView = [[UIView alloc] init];
    _bottomView = bottomView;
    bottomView.backgroundColor = [UIColor colorWithHexString:@"#1C1522" alpha:0.5];
    [self addSubview:bottomView];
    
    //创建UICollectionView：黑色
    [self setupCollectionView];

    //收藏数据按钮事件
    [self.favoritesBtn addTarget:self action:@selector(favoriteTarget) forControlEvents:UIControlEventTouchUpInside];
}

//收藏事件
-(void)favoriteTarget{
    //改变索引的样式
    [self changeTypeCollectionViewWithIndex:7];
    self.materialIndex = 0;
    self.favoritesBlock();
    self.isCollect = YES;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self);
        make.height.mas_equalTo(ZZTLayoutDistance(224));
    }];
    
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(ZZTLayoutDistance(24));
        make.top.equalTo(self.topView.mas_top).offset(ZZTLayoutDistance(8));
        make.width.height.mas_equalTo(ZZTLayoutDistance(93));
    }];
    
    [self.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(self.topView);
    }];
    
    [self.collectViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(ZZTLayoutDistance(24));
        make.top.equalTo(self.searchBtn.mas_bottom).offset(ZZTLayoutDistance(22));
        make.width.height.mas_equalTo(ZZTLayoutDistance(93));
    }];
    
    [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView.mas_right).offset(ZZTLayoutDistance(-24));
        make.centerY.equalTo(self.collectViewBtn);
        make.width.height.mas_equalTo(ZZTLayoutDistance(93));
    }];
    
/********************************************************************/
    
    [self.midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self);
        make.top.equalTo(self.topView.mas_bottom);
        make.height.mas_equalTo(ZZTLayoutDistance(108));
    }];
    
    [self.favoritesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.midView.mas_centerY);
        make.left.equalTo(self).offset(ZZTLayoutDistance(22));
        make.width.height.mas_equalTo(ZZTLayoutDistance(70));
    }];
    
    [self.midLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.favoritesBtn.mas_right).offset(ZZTLayoutDistance(28));
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(ZZTLayoutDistance(68));
        make.centerY.equalTo(self.midView.mas_centerY);
    }];
    
    [self.typeCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.midView.mas_centerY);
        make.height.mas_equalTo(ZZTLayoutDistance(80));
        make.left.equalTo(self.midLine).offset(ZZTLayoutDistance(24));
        make.right.equalTo(self).offset(-10);
    }];
    /********************************************************************/

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self);
        make.top.equalTo(self.midView.mas_bottom);
        make.bottom.equalTo(self);
    }];
    
    [self.contentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self.bottomView);
    }];
}

#pragma mark - 创建CollectionView
-(void)setupCollectionView
{
    //类别
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 5;
    
    UICollectionView *typeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, Height_NavBar, Screen_Width, Screen_Height) collectionViewLayout:layout];
    typeCollectionView.backgroundColor = [UIColor clearColor];
    self.typeCollectionView = typeCollectionView;
    typeCollectionView.dataSource = self;
    typeCollectionView.delegate = self;
    [self.midView addSubview:self.typeCollectionView];
    
    [typeCollectionView registerClass:[ZZTMaterialTypeCell class] forCellWithReuseIdentifier:@"materialTypeCell"];
    
    //素材
    UICollectionViewFlowLayout *contentCollectionViewlayout = [[UICollectionViewFlowLayout alloc] init];
    
    UICollectionView *contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, Height_NavBar, Screen_Width, Screen_Height) collectionViewLayout:contentCollectionViewlayout];
    contentCollectionView.backgroundColor = [UIColor clearColor];
    self.contentCollectionView = contentCollectionView;
    contentCollectionView.dataSource = self;
    contentCollectionView.delegate = self;
    [self.bottomView addSubview:self.contentCollectionView];
    
    [contentCollectionView registerClass:[ZZTEditorImgCell class] forCellWithReuseIdentifier:@"materialCell"];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == self.typeCollectionView){
        return self.typeArray.count;
    }else{
        return self.materialArray.count;
    }
 
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.typeCollectionView){
        ZZTMaterialTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"materialTypeCell" forIndexPath:indexPath];
        ZZTKindModel *model = self.typeArray[indexPath.row];
        cell.model = model;
        return cell;
    }else{
        //如果是场景...第一个显示上传按钮   注意数据索引
        ZZTEditorImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"materialCell" forIndexPath:indexPath];
        cell.deleteCell = ^(ZZTDetailModel *model) {
            //删除提示
            [self deleteCellRemind:model];
        };
        ZZTDetailModel *model = self.materialArray[indexPath.row];
        model.indexRow = indexPath.row;
        cell.model = model;
        return cell;
    }
}

-(void)deleteCellRemind:(ZZTDetailModel *)model{
    //弹出举报框
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"是否删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //删除逻辑
        [self materialDeleteData:model];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    [actionSheet addAction:action];
    
    [actionSheet addAction:action2];
    
    [[self myViewController] presentViewController:actionSheet animated:YES completion:nil];
}

//删除数据
-(void)materialDeleteData:(ZZTDetailModel *)model{
    
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    NSDictionary *dict = @{
                           @"fodderId":[NSString stringWithFormat:@"%ld",model.id]
                           };
    [manager POST:[ZZTAPI stringByAppendingString:@"fodder/deleteUserSeekFodder"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject:%@",responseObject);
        
        if(self.reloadMaterialData){
            self.reloadMaterialData();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //标题点击
    if(collectionView == self.typeCollectionView){
        self.isCollect = NO;

        self.materialIndex = indexPath.row + 1;
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(materialTypeView:index:)]){
            // 调用代理方法
            [self.delegate materialTypeView:collectionView index:indexPath.row];
        }
        
        [self changeTypeCollectionViewWithIndex:indexPath.row];
        
    }else{
        if(![_selectKindModel.kindTitle isEqualToString:@"布局"] && ![_selectKindModel.kindTitle isEqualToString:@"对话"] && indexPath.row == 0){
            NSLog(@"点击了上传");
            //出现选择图片的view然后选中多少上传图片
            ZZTAlbumAlertControllerView *view = [[ZZTAlbumAlertControllerView alloc] init];
            view.delegate = self;
            view.isImageClip = NO;
            [view pushTZImagePickerController];
            return;
        }
        //素材视图点击
        ZZTEditorImgCell *cell = (ZZTEditorImgCell *)[collectionView cellForItemAtIndexPath:indexPath];
        //分2种  多种 和 单种
        ZZTDetailModel *model = self.materialArray[indexPath.row];
        //收费的 -> 跳商城详情页
        if([model.owner isEqualToString:@"3"]){
            ZZTMallDetailViewController *vc = [[ZZTMallDetailViewController alloc] init];
            vc.model = model;
            [[self myViewController].navigationController pushViewController:vc animated:YES];
            return;
        }
        
        if(model.flag == 1){
            //多
            if (self.delegate && [self.delegate respondsToSelector:@selector(createEditorMaterialDetailViewWithID:superModel:kindIndex:)])
            {
                if(self.isCollect == YES){
                    model.id = model.fodderId;
                }
                [self.delegate createEditorMaterialDetailViewWithID:model.id superModel:model kindIndex:self.materialIndex];
            }
        }else{
            //单
            if (self.delegate && [self.delegate respondsToSelector:@selector(materialContentView:materialModel:kindIndex:materialIndex:materialImage:)])
            {
                //模型 类型
                [self.delegate materialContentView:collectionView materialModel:model kindIndex:[model.fodderType
                                                            integerValue]
                        materialIndex:indexPath.row materialImage:cell.imageView.image];
            }
        }
    }
}

#pragma mark - 上传图片
-(void)albumAlertControllerViewWithImg:(NSArray *)photos{
    //上传后 加载出来 上传到七牛云 然后给后台
    [SYQiniuUpload QiniuPutImageArray:photos complete:nil uploadComplete:^(NSString *imgsStr) {
        [self uploadSeverWithImageStr:imgsStr];
    }];
    
    
}

-(void)uploadSeverWithImageStr:(NSString *)str{
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    NSDictionary *dict = @{
                           @"fodderImg":str,
                            @"userId":[NSString stringWithFormat:@"%ld",[Utilities GetNSUserDefaults].id],
                            @"fodderType":self.fodderType
                           };
    [manager POST:[ZZTAPI stringByAppendingString:@"fodder/insertUserSeekFodder"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        if(self.reloadMaterialData){
            self.reloadMaterialData();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *view = [super hitTest:point withEvent:event];
    
    if(view == nil){
        [self removeView];
    }
    return view;
}


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.contentCollectionView){
        return CGSizeMake(ZZTLayoutDistance(200), ZZTLayoutDistance(200));
    }else if(collectionView == self.typeCollectionView){
        return CGSizeMake((self.typeCollectionView.width)/self.typeArray.count - 10, self.typeCollectionView.height);
    }else{
        return CGSizeZero;
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    if(collectionView == self.contentCollectionView){
        return UIEdgeInsetsMake(ZZTLayoutDistance(50), ZZTLayoutDistance(40), ZZTLayoutDistance(50), ZZTLayoutDistance(40));
    }else if(collectionView == self.typeCollectionView){
        return UIEdgeInsetsZero;
    }else{
        return UIEdgeInsetsZero;
    }
}

-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if(collectionView == self.contentCollectionView){
        return ZZTLayoutDistance(50);
    }else{
        return 0;
    }
}

-(void)removeView{
    [self removeFromSuperview];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(materialWindowHidden)])
    {
        //模型 类型
        [self.delegate materialWindowHidden];
    }
}

-(void)changeTypeCollectionViewWithIndex:(NSInteger)index{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NSInteger i = 0; i < self.typeArray.count; i++) {
            
            ZZTKindModel *model = self.typeArray[i];
            if(index == i){
                model.isSelect = @"1";
                self.selectKindModel = model;
                self.fodderType = [NSString stringWithFormat:@"%ld",i + 1];
            }else{
                model.isSelect = @"0";
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.typeCollectionView reloadData];
        });
    });
}
@end
