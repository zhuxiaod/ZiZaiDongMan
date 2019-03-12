//
//  ZZTEditorMaterialDetailView.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/1/29.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import "ZZTEditorMaterialDetailView.h"
#import "ZZTEditorImgCell.h"
#import "ZZTDetailModel.h"

@interface ZZTEditorMaterialDetailView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UIView *yellowView;

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation ZZTEditorMaterialDetailView

-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        //添加UI
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    //收藏 相机
    UIButton *collectViewBtn = [GlobalUI createButtonWithImg:[UIImage imageNamed:@"editor_noCollection"] title:nil titleColor:nil];
    [collectViewBtn setImage:[UIImage imageNamed:@"editor_collect_select"] forState:UIControlStateSelected];
    _collectViewBtn = collectViewBtn;
    [self addSubview:collectViewBtn];
    
    //colletionView
    [self setupCollectionView];
    
    //圆角
    self.collectionView.layer.cornerRadius = 10.0f;
    self.collectionView.layer.masksToBounds = YES;
    
    //半透明黑底
    //collectionView 一排6个
}

-(void)setupCollectionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 5;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, Height_NavBar, Screen_Width, Screen_Height) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor colorWithHexString:@"#1C1522" alpha:0.5];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;//显示水平滚动条->NO
    collectionView.delegate = self;
    [self addSubview:self.collectionView];
    
    [collectionView registerClass:[ZZTEditorImgCell class] forCellWithReuseIdentifier:@"EditorMateriaDetailView"];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imgArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZTEditorImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EditorMateriaDetailView" forIndexPath:indexPath];
    ZZTDetailModel *model = self.imgArray[indexPath.row];
    cell.model = model;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZZTEditorImgCell *cell = (ZZTEditorImgCell *)[collectionView cellForItemAtIndexPath:indexPath];
    ZZTDetailModel *model = self.imgArray[indexPath.row];
    model.id = self.superId;
    self.model.img = model.img;
    //单
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendMaterialDetailWithKindIndex:materialImage:model:)])
    {
        //模型 类型
        [self.delegate sendMaterialDetailWithKindIndex:self.kindIndex materialImage:cell.imageView.image model:self.model];
    }
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.collectionView.height, self.collectionView.height);
}

-(void)layoutSubviews{
    [self.collectViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(ZZTLayoutDistance(8));
        make.width.height.mas_equalTo(ZZTLayoutDistance(93));
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectViewBtn.mas_bottom).offset(ZZTLayoutDistance(8));
        make.right.left.bottom.equalTo(self);
    }];
}

-(void)setImgArray:(NSArray *)imgArray{
    _imgArray = imgArray;
    [self.collectionView reloadData];
}

-(void)setModel:(ZZTDetailModel *)model{
    _model = model;
}

-(void)setKindIndex:(NSInteger)kindIndex{
    _kindIndex = kindIndex;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *view = [super hitTest:point withEvent:event];
    
    if(view == nil){
        [self removeFromSuperview];
        //移除代理
        if (self.delegate && [self.delegate respondsToSelector:@selector(materialDetailViewRemoveTarget)])
        {
            //模型 类型
            [self.delegate materialDetailViewRemoveTarget];
        }
    }
    return view;
}
@end
