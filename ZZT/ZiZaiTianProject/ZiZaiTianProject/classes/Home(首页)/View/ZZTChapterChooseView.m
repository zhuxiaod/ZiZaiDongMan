//
//  ZZTChapterChooseView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/10/30.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTChapterChooseView.h"
@interface ZZTChapterChooseView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UIView *btnView;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIView *backView;

@end

@implementation ZZTChapterChooseView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
//        [self setupData];
    }
    return self;
}

-(void)setup{
    //backView
    UIView *backView = [[UIView alloc] init];
    _backView = backView;
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    
    UICollectionViewFlowLayout *layout = [self setupCollectionViewFlowLayout];
    [self setupCollectionView:layout];
    
    //按钮View
    UIView *btnView = [[UIView alloc] init];
    btnView.backgroundColor = [UIColor orangeColor];
    _btnView = btnView;
    [backView addSubview:btnView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
    }];
    //只有三种清空
    //1.只有1行
    //如果只有1 2行的话 是不需要有展开章节的按钮的
    //2.只有2行
    //如果是大于8个的话  就需要显示出来
    //3.2行以上
    
    //如果是1的话  高度为8 + 8 + 高
    
    [_btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_top).offset(8);
        make.right.equalTo(self.backView.mas_right).offset(-20);
        make.left.equalTo(self.backView.mas_left).offset(20);
        make.height.equalTo(self.backView.mas_height).multipliedBy(0.7);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backView.mas_bottom).offset(0);
        make.right.equalTo(self.backView.mas_right).offset(0);
        make.left.equalTo(self.backView.mas_left).offset(0);
        make.top.equalTo(self.btnView.mas_bottom);
    }];
}

#pragma mark - 创建流水布局
-(UICollectionViewFlowLayout *)setupCollectionViewFlowLayout{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //修改尺寸(控制)
    layout.itemSize = CGSizeMake(SCREEN_WIDTH/3 - 10,200);
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //行距
    layout.minimumLineSpacing = 0;
    
    layout.minimumInteritemSpacing = 5;
    
    return layout;
}

#pragma mark - 创建CollectionView
-(void)setupCollectionView:(UICollectionViewFlowLayout *)layout
{
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor orangeColor];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [_backView addSubview:collectionView];
    
//    [collectionView registerNib:[UINib nibWithNibName:@"ZZTCartoonCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
}

@end
