//
//  ZZTZoneWordView.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/3/6.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import "ZZTZoneWordView.h"

@interface ZZTZoneWordView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UIView *wordTitleView;

@property (nonatomic,strong) UIView *wordView;

@property (nonatomic,strong) UILabel *titleLab;
//按钮
@property (nonatomic,strong) UIButton *actionBtn;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIView *bottomView;

@end

@implementation ZZTZoneWordView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self addUI];
    }
    return self;
}

-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    self.actionBtn.hidden = _dataArray.count > 3 ? 0:1;
    [self.collectionView reloadData];
}

-(void)addUI{
    //作品标题
    UIView *wordTitleView = [[UIView alloc] init];
    wordTitleView.backgroundColor = [UIColor whiteColor];
    _wordTitleView = wordTitleView;
    [self.contentView addSubview:wordTitleView];
    
    //lab
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"作品";
    _titleLab = titleLab;
    [wordTitleView addSubview:titleLab];
    
    //按钮
    UIButton *actionBtn = [[UIButton alloc] init];
    [actionBtn setImage:[UIImage imageNamed:@"wordsDetail_open"] forState:UIControlStateNormal];
    [actionBtn setImage:[UIImage imageNamed:@"wordsDetail_close"] forState:UIControlStateSelected];
    _actionBtn = actionBtn;
    [actionBtn addTarget:self action:@selector(changeHeight:) forControlEvents:UIControlEventTouchUpInside];
    [wordTitleView addSubview:actionBtn];
    
    //作品集
    UIView *wordView = [[UIView alloc] init];
    wordView.backgroundColor = [UIColor redColor];
    _wordView = wordView;
    [self.contentView addSubview:wordView];
    
    //collectionView
    UICollectionViewFlowLayout *layout = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //修改尺寸(控制)
        layout.itemSize = CGSizeMake((SCREEN_WIDTH - 36) / 3,[Utilities getCarChapterH] + 24);
        
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //行距
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 5;
        
        layout;
    });
    
    UICollectionView *collectionView = ({
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [wordView addSubview:collectionView];
        collectionView.scrollEnabled = NO;
        collectionView;
    });
    self.collectionView = collectionView;
    
    [collectionView registerClass:[ZZTCartoonCell class] forCellWithReuseIdentifier:@"cellId"];
    
    UIView *bottomView = [[UIView alloc] init];
    _bottomView = bottomView;
    bottomView.backgroundColor = [UIColor colorWithRGB:@"239,239,239"];
    [wordView addSubview:bottomView];
}

-(void)changeHeight:(UIButton *)btn{
    btn.selected = !btn.selected;
    if(self.changeHeight){
        self.changeHeight();
    }
    self.wordTitleView.hidden = NO;
    self.wordView.hidden = NO;
}

-(void)setIsSpreadWordHeight:(BOOL)isSpreadWordHeight{
    _isSpreadWordHeight = isSpreadWordHeight;
    self.actionBtn.selected = YES;
    if(self.changeHeight){
        self.changeHeight();
    }

}

-(void)setIsShowView:(BOOL)isShowView{
    _isShowView = isShowView;
    self.wordTitleView.hidden = YES;
    self.wordView.hidden = YES;
}

#pragma mark - collectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZZTCarttonDetailModel *model = _dataArray[indexPath.row];
    
    //独创
    ZZTWordDetailViewController *detailVC = [[ZZTWordDetailViewController alloc]init];
    //yes 就是有Id
    detailVC.isId = YES;
    detailVC.cartoonDetail = model;
    detailVC.hidesBottomBarWhenPushed = YES;
    [[self myViewController].navigationController pushViewController:detailVC animated:YES];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZTCartoonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    ZZTCarttonDetailModel *car = _dataArray[indexPath.row];
    cell.cartoon = car;
    return cell;
}



//边距设置:整体边距的优先级，始终高于内部边距的优先级
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 8, 8, 8);//分别为上、左、下、右
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if(self.contentView.bounds.size.height < 2) return;
    
    [self.wordTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_offset(50);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.wordTitleView.mas_centerY);
        make.left.equalTo(self.wordTitleView.mas_left).offset(10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(80);
    }];
    
    [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.wordTitleView.mas_centerY);
        make.right.equalTo(self.wordTitleView.mas_right).offset(-10);
        make.height.width.mas_equalTo(40);
    }];
    
    [self.wordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wordTitleView.mas_bottom);
        make.left.bottom.right.equalTo(self.contentView);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self.wordView);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.wordView);
        make.height.mas_equalTo(1);
    }];
}

-(CGFloat)viewHeight{
    if(self.actionBtn.selected){
        //计算
        NSInteger row = self.dataArray.count / 3;
        NSInteger remainder = self.dataArray.count % 3 ? row + 1 : row;
        NSLog(@"remainder:%ld",remainder);
        return ([Utilities getCarChapterH] + 24 + 10) * remainder + 50 + 10;
    }else{
        return 50 + [Utilities getCarChapterH] + 24 + 10;
    }
}
@end
