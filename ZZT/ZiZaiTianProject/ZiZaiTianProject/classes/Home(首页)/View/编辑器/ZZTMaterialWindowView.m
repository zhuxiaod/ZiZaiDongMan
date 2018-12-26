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
#import "ZZTMaterialCell.h"

@interface ZZTMaterialWindowView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic , strong)UIView *topView;
@property(nonatomic , strong)UIView *midView;
@property(nonatomic , strong)UIView *bottomView;
@property(nonatomic , strong)UICollectionView *typeCollectionView;
@property (nonatomic ,strong)NSArray *typeArray;
@property(nonatomic , strong) UICollectionView *contentCollectionView;
@property(nonatomic , strong)UIView *midLine;
@end

@implementation ZZTMaterialWindowView

-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        //添加UI
        [self addUI];
        
        self.typeArray = @[[ZZTKindModel initKindModelWith:@"布局" isSelect:@"1"],
                           [ZZTKindModel initKindModelWith:@"场景" isSelect:@"0"],
                           [ZZTKindModel initKindModelWith:@"角色" isSelect:@"0"],
                           [ZZTKindModel initKindModelWith:@"表情" isSelect:@"0"],
                           [ZZTKindModel initKindModelWith:@"效果" isSelect:@"0"],
                           [ZZTKindModel initKindModelWith:@"对话" isSelect:@"0"],
                        ];
    }
    return self;
}

-(void)addUI{
    self.backgroundColor = [UIColor colorWithHexString:@"#1C1522" alpha:0.3];
    //3个部分
    //按钮区
    UIView *topView = [[UIView alloc] init];
    _topView = topView;
    topView.backgroundColor = [UIColor redColor];
    [self addSubview:topView];
    
    //收藏 相机
    UIButton *collectViewBtn = [GlobalUI createButtonWithImg:[UIImage imageNamed:@"预览"] title:nil titleColor:nil];
    _collectViewBtn = collectViewBtn;
    [topView addSubview:collectViewBtn];
    
    UIButton *cameraBtn = [GlobalUI createButtonWithImg:[UIImage imageNamed:@"预览"] title:nil titleColor:nil];
    _cameraBtn = cameraBtn;
    [topView addSubview:cameraBtn];
    
    /********************************************************************/

    //分类区
    UIView *midView = [[UIView alloc] init];
    _midView = midView;
    midView.backgroundColor = [UIColor yellowColor];
    [self addSubview:midView];
    
    UIButton *favoritesBtn = [GlobalUI createButtonWithImg:[UIImage imageNamed:@"收藏夹"] title:nil titleColor:nil];
    _favoritesBtn = favoritesBtn;
    [midView addSubview:favoritesBtn];
    
    UIView *midLine = [[UIView alloc] init];
    _midLine = midLine;
    midLine.backgroundColor = [UIColor colorWithRGB:@"75,75,75"];
    [midView addSubview:midLine];
    
    //选择区
    UIView *bottomView = [[UIView alloc] init];
    _bottomView = bottomView;
    bottomView.backgroundColor = [UIColor brownColor];
    [self addSubview:bottomView];
    
    //创建UICollectionView：黑色
    [self setupCollectionView];
    
  
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self);
        make.height.mas_equalTo(ZZTLayoutDistance(108));
    }];
    
    [self.collectViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(ZZTLayoutDistance(24));
        make.top.equalTo(self.topView.mas_top).offset(ZZTLayoutDistance(8));
        make.width.height.mas_equalTo(ZZTLayoutDistance(93));
    }];
    
    [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView.mas_right).offset(ZZTLayoutDistance(-24));
        make.top.equalTo(self.topView.mas_top).offset(ZZTLayoutDistance(8));
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
    
    
    UICollectionViewFlowLayout *contentCollectionViewlayout = [[UICollectionViewFlowLayout alloc] init];
    
    UICollectionView *contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, Height_NavBar, Screen_Width, Screen_Height) collectionViewLayout:contentCollectionViewlayout];
    contentCollectionView.backgroundColor = [UIColor clearColor];
    self.contentCollectionView = contentCollectionView;
    contentCollectionView.dataSource = self;
    contentCollectionView.delegate = self;
    [self.bottomView addSubview:self.contentCollectionView];
    
    [contentCollectionView registerNib:[UINib nibWithNibName:@"ZZTMaterialCell" bundle:nil] forCellWithReuseIdentifier:@"materialCell"];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == self.typeCollectionView){
        return self.typeArray.count;
    }else{
        return self.typeArray.count + 30;
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
        ZZTMaterialCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"materialCell" forIndexPath:indexPath];
        cell.imageStr = @"http://img.cdn.zztian.cn/zmnmsy.jpg";
        return cell;
    }
   
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if(collectionView == self.typeCollectionView){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (NSInteger i = 0; i < self.typeArray.count; i++) {
                ZZTKindModel *model = self.typeArray[i];
                if(indexPath.row == i){
                    model.isSelect = @"1";
                }else{
                    model.isSelect = @"0";
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.typeCollectionView reloadData];
            });
        });
        if (self.delegate && [self.delegate respondsToSelector:@selector(materialTypeView:index:)])
        {
            // 调用代理方法
            [self.delegate materialTypeView:collectionView index:indexPath.row];
        }
   
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(materialContentView:index:)])
        {
            // 调用代理方法
            [self.delegate materialContentView:collectionView index:indexPath.row];
        }
    }


}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *view = [super hitTest:point withEvent:event];
    
    if(view == nil){
        [self removeFromSuperview];
    }
    return view;
}
@end
