//
//  ZZTEditorFontView.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/1/10.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import "ZZTEditorFontView.h"

static NSString *const cellId = @"cellId";

@interface ZZTEditorFontView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UIView *topView;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UIButton *fontSizeBtn;

@property (nonatomic,strong) UIButton *fontColorBtn;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSArray *dateArray;

@property (nonatomic,strong) UIView *sliderViw;

@property (nonatomic,strong) UILabel *mixLab;

@property (nonatomic,strong) UILabel *maxLab;

@property (nonatomic,strong) UISlider *fontSlider;

@end

@implementation ZZTEditorFontView

-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        //添加UI
        [self setupUI];
        
        _dateArray = @[@"#FFFFFF",@"#000000",@"#ADFF2F",@"#FF8C00",@"#FF0000",@"#DB7093",@"#6A5ACD",@"#00BFFF"];
    }
    return self;
}

-(void)setupUI{
    //2个部分
    UIView *topView = [[UIView alloc] init];
    _topView = topView;
    topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topView];
    
    UIView *bottomView = [[UIView alloc] init];
    _bottomView = bottomView;
    bottomView.backgroundColor = ZZTSubColor;
    [self addSubview:bottomView];
    
    //选择项 2个btn
    //字体大小
    UIButton *fontSizeBtn = [[UIButton alloc] init];
    _fontSizeBtn = fontSizeBtn;
    [fontSizeBtn setTitle:@"字体大小" forState:UIControlStateNormal];
    [fontSizeBtn addTarget:self action:@selector(showFontSizeView) forControlEvents:UIControlEventTouchUpInside];
    [fontSizeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomView addSubview:fontSizeBtn];
    
    //字体颜色
    UIButton *fontColorBtn = [[UIButton alloc] init];
    _fontColorBtn = fontColorBtn;
    [fontColorBtn setTitle:@"字体颜色" forState:UIControlStateNormal];
    [fontColorBtn addTarget:self action:@selector(showFontColorView) forControlEvents:UIControlEventTouchUpInside];
    [fontColorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomView addSubview:fontColorBtn];
    
    //collection
    UICollectionViewFlowLayout *layout = [self setupCollectionViewFlowLayout];
    
    //创建UICollectionView：黑色
    UICollectionView *collectionView = [self setupCollectionView:layout];
    _collectionView = collectionView;
    [topView addSubview:collectionView];
    
    //sliderView
    UIView *sliderViw = [[UIView alloc] init];
    _sliderViw = sliderViw;
    [topView addSubview:sliderViw];
    
    UILabel *mixLab = [[UILabel alloc] init];
    _mixLab = mixLab;
    [mixLab setText:@"小"];
    [mixLab setTextColor:[UIColor lightGrayColor]];
    [sliderViw addSubview:mixLab];
    
    UILabel *maxLab = [[UILabel alloc] init];
    _maxLab = maxLab;
    [maxLab setText:@"大"];
    [maxLab setTextColor:[UIColor lightGrayColor]];
    [sliderViw addSubview:maxLab];
    
    UISlider *fontSlider = [[UISlider alloc] init];
    _fontSlider = fontSlider;
    fontSlider.minimumValue = 17;
    fontSlider.maximumValue = 50;
    fontSlider.value = 17;
    [sliderViw addSubview:fontSlider];
    [fontSlider addTarget:self action:@selector(fontSizeChange) forControlEvents:UIControlEventValueChanged];
    self.sliderViw.hidden = YES;
}

//改变字体的大小
-(void)fontSizeChange{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(editorFontViewSliderTarget:)]){
        [self.delegate editorFontViewSliderTarget:self.fontSlider] ;
    }
}



-(void)showFontSizeView{
    self.collectionView.hidden = YES;
    self.sliderViw.hidden = NO;
}

-(void)showFontColorView{
    self.sliderViw.hidden = YES;
    self.collectionView.hidden = NO;
}

-(void)layoutSubviews{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.5);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.5);
    }];

    if([_currentView isEqualToString:@"ZZTEditorImageView"]){
        self.fontSizeBtn.hidden = YES;
        
        [self.fontColorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bottomView.mas_centerX);
            make.top.bottom.equalTo(self.bottomView);
            make.width.mas_equalTo(100);
        }];
    }else{
        [self.fontSizeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bottomView.mas_centerX).offset(-20);
            make.top.bottom.equalTo(self.bottomView);
            make.width.mas_equalTo(100);
        }];
        
        [self.fontColorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomView.mas_centerX).offset(20);
            make.top.bottom.equalTo(self.bottomView);
            make.width.mas_equalTo(100);
        }];
    }
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self.topView);
    }];
    
    [self.sliderViw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self.topView);
    }];
    
    [self.mixLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sliderViw.mas_centerY);
        make.left.equalTo(self.sliderViw.mas_left).offset(10);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.maxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sliderViw.mas_centerY);
        make.right.equalTo(self.sliderViw.mas_right).offset(-10);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.fontSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sliderViw.mas_centerY);
        make.right.equalTo(self.maxLab.mas_left).offset(-10);
        make.left.equalTo(self.mixLab.mas_right).offset(10);
    }];
}

#pragma mark - 创建流水布局
-(UICollectionViewFlowLayout *)setupCollectionViewFlowLayout{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //行距
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 5;
    
    return layout;
}

#pragma mark - 创建CollectionView
-(UICollectionView *)setupCollectionView:(UICollectionViewFlowLayout *)layout
{
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 1) collectionViewLayout:layout];
    
    collectionView.backgroundColor = [UIColor whiteColor];
    
    collectionView.dataSource = self;
    
    collectionView.delegate = self;
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];
    
    return collectionView;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dateArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    NSString *colorStr = self.dateArray[indexPath.row];
    cell.backgroundColor = [UIColor colorWithHexString:colorStr];
    cell.layer.cornerRadius = cell.width/2;
    cell.layer.masksToBounds = YES;
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *colorStr = self.dateArray[indexPath.row];
    if(self.delegate && [self.delegate respondsToSelector:@selector(editorFontViewColorTarget:)]){
        [self.delegate editorFontViewColorTarget:colorStr];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"self.topView.height:%f",self.topView.height);
    return (CGSize){40,40};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}

-(void)setFontValue:(CGFloat)fontValue{
    _fontValue = fontValue;
    self.fontSlider.value = fontValue;
}

-(void)setCurrentView:(NSString *)currentView{
    _currentView = currentView;
}
@end
