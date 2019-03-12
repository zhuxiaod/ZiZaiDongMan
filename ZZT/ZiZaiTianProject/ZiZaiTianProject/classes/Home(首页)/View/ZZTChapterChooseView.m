//
//  ZZTChapterChooseView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/10/30.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTChapterChooseView.h"
#import "ZZTChapterChooseCell.h"
#import "ZZTChapterChooseModel.h"

@interface ZZTChapterChooseView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UIView *bottom;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIView *backView;

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,strong) UIButton *openBtn;

@property (nonatomic,strong) NSMutableArray *itemStyleArray;

@property (nonatomic,strong) UILabel *mainText;

@property (nonatomic,strong) UIView *bottomView;
//连载中
@property (nonatomic,strong) UILabel *serializeLab;

@end

@implementation ZZTChapterChooseView

-(void)setTitle:(NSString *)title{
    _title = title;
    _mainText.text = title;

}

//-(UILabel *)mainText{
//    if(!_mainText){
//        //正篇lab
//        _mainText = [[UILabel alloc] init];
//
//        [self.backView addSubview:_mainText];
//    }
//    return _mainText;
//}

//点击样式
-(NSMutableArray *)itemStyleArray{
    if(!_itemStyleArray){
        if(self.dataArray.count > 0){
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 0; i < self.dataArray.count; i++) {
                NSNumber *isChange = @0;//不改变
                [array addObject:isChange];
            }
            NSNumber *change = @1;//改变
            [array replaceObjectAtIndex:0 withObject:change];
            _itemStyleArray = array;
        }
    }
    return _itemStyleArray;
}

-(NSArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    //backView
    UIView *backView = [[UIView alloc] init];
    _backView = backView;
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    
    //正篇lab
    UILabel *mainText = [[UILabel alloc] init];
    mainText.text = @"正篇";
    _mainText = mainText;
    [self.contentView addSubview:mainText];
    
    //连载中
    UILabel *serializeLab = [[UILabel alloc] init];
    serializeLab.font = [UIFont systemFontOfSize:14];
    serializeLab.textColor = [UIColor colorWithHexString:@"#A7A8A9"];
    serializeLab.text = @"(连载中)";
    _serializeLab = serializeLab;
    [self.contentView addSubview:serializeLab];
    
    UICollectionViewFlowLayout *layout = [self setupCollectionViewFlowLayout];
    
    [self setupCollectionView:layout];
    
    //按钮View
    UIView *bottom = [[UIView alloc] init];
    bottom.backgroundColor = [UIColor whiteColor];
    _bottom = bottom;
    [backView addSubview:bottom];
    
    //展开按钮
    UIButton *openButton = [UIButton buttonWithType:UIButtonTypeCustom];
    openButton.backgroundColor = [UIColor whiteColor];
//    openButton.titleLabel.font = [UIFont systemFontOfSize:10];
//    [openButton setTitle:@"展开更多章节" forState:UIControlStateNormal];
//    [openButton setTitle:@"收起" forState:UIControlStateSelected];
//    [openButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [openButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    
    [openButton setImage:[UIImage imageNamed:@"wordsDetail_open"] forState:UIControlStateNormal];
    [openButton setImage:[UIImage imageNamed:@"wordsDetail_close"] forState:UIControlStateSelected];
    _openBtn = openButton;
//    openButton.enabled = NO;
    [openButton addTarget:self action:@selector(openOrClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:openButton];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor colorWithRGB:@"239,239,239"];
    _bottomView = bottomView;
    [backView addSubview:bottomView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //背景
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
    
    //正篇
    [self.mainText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_top).offset(8);
        make.left.equalTo(self.backView.mas_left).offset(12);
        make.height.mas_equalTo(30);
//        make.right.equalTo(self.backView.mas_right).offset(-8);
    }];
    
    [self.serializeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mainText.mas_bottom);
        make.left.equalTo(self.mainText.mas_right).offset(8);
        make.height.equalTo(self.mainText);
    }];
    
    //没有设置高度
    if(_openBtn.selected == NO){
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mainText.mas_bottom).offset(8);
            make.right.equalTo(self.backView.mas_right).offset(-20);
            make.left.equalTo(self.backView.mas_left).offset(20);
        }];
    }

    
    [_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.backView.mas_bottom).offset(0);
        make.right.equalTo(self.backView.mas_right).offset(0);
        make.left.equalTo(self.backView.mas_left).offset(0);
//        make.top.equalTo(self.collectionView.mas_bottom);
    }];
    //写一个按钮 展开收缩的
    //如果item大于8
    //那么这个按钮才会被显示出来
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.left.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - 创建流水布局
-(UICollectionViewFlowLayout *)setupCollectionViewFlowLayout{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    [self layoutIfNeeded];
    NSLog(@"self.contentView:%f",self.contentView.height);
    //修改尺寸(控制)
    layout.itemSize = CGSizeMake(SCREEN_WIDTH/4 - 15,_collectionView.height/2 - 5);
    
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
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [_backView addSubview:collectionView];
    
    [collectionView registerClass:[ZZTChapterChooseCell class] forCellWithReuseIdentifier:@"ChapterChooseCell"];
}

//设置分组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
    
}
//设置每个分组个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.dataArray.count > 8){
        //设置没有展开样式
        if(_openBtn.isSelected == NO){
            return 8;
        }
        else{
            //已经再开显示所用
            return self.dataArray.count;
        }
    }else{
        //没有到达8个
        return self.dataArray.count;
    }
}
//只有新的cell出现的时候才会调用
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZZTChapterChooseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChapterChooseCell" forIndexPath:indexPath];
    ZZTChapterChooseModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    NSNumber *isChange = self.itemStyleArray[indexPath.row];
    cell.isChangeStyle = isChange;
    return cell;
}

//点击选中
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //设置选中的状态
    for (int i = 0; i < self.itemStyleArray.count; i++) {
        if(i == indexPath.row){
            //代表是我选中的
            [self.itemStyleArray replaceObjectAtIndex:i withObject:@1];
        }else{
            [self.itemStyleArray replaceObjectAtIndex:i withObject:@0];
        }
    }
    [self.collectionView reloadData];
    ZZTChapterChooseModel *model = self.dataArray[indexPath.row];
    //点击发送新的请求
    if (self.delegate && [self.delegate respondsToSelector:@selector(chapterChooseView:didItemWithModel:)]) {
        [self.delegate chapterChooseView:self didItemWithModel:model];
    }
}

//cell 大小
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self layoutIfNeeded];
    return CGSizeMake(SCREEN_WIDTH / 4 - 20 , 30);
}

//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

//总数
-(void)setTotal:(NSInteger)total{
    _total = total;

    NSInteger count = total;
    //    23 / 5
    NSInteger itemCount = 0;

    if(count % 5 == 0){
        //没有余数
        itemCount = count / 5;
    }else{
        itemCount = count / 5 + 1;
    }

    NSInteger bp = 0;
    //结束
    NSInteger ep = 0;
    //api参数
    NSInteger APINum = 1;

    NSMutableArray *modelArray = [NSMutableArray array];

    for(NSInteger i = 0; i < itemCount;i++){
        ZZTChapterChooseModel *model = [[ZZTChapterChooseModel alloc] init];
        //起始页
        bp = bp + 1;
        model.benginPage = [NSString stringWithFormat:@"%ld",bp];
        ep = bp + 4;
        //结束页
        if(i == itemCount - 1){
            model.endPage = [NSString stringWithFormat:@"%ld",total];
        }else{
            model.endPage = [NSString stringWithFormat:@"%ld",ep];
        }
        model.APIPage = APINum;
        bp = ep;
        APINum++;
        [modelArray addObject:model];
    }

    self.dataArray = modelArray;

    if(modelArray.count <= 4)
    {
        //一行的时候 8 + 20 + 8
        [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
        }];
        [_bottom mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.collectionView.mas_bottom);
            make.bottom.equalTo(self.backView.mas_bottom).offset(-8);
        }];
    }else{
        //如果大于4
        [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(70);
        }];
        //大于4小于8
        if(modelArray.count <= 8 ){
            [_bottom mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.backView.mas_bottom).offset(-8);
                make.top.equalTo(self.collectionView.mas_bottom);
            }];
        }else{
            if(_openBtn.selected == YES){
                CGFloat collectionH = [self getCollectionViewHeight];
                
                [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(collectionH);
                }];
            }
       
            //大于8的时候
            [_bottom mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.collectionView.mas_bottom).offset(4);
                make.bottom.equalTo(self.backView.mas_bottom).offset(-8);
//                make.height.mas_equalTo(0);
            }];
            //设置open按钮
//            if(_openBtn.enabled)
            _openBtn.enabled = YES;
            [_openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mainText.mas_top);
                make.right.equalTo(self.backView).offset(-8);
                make.bottom.equalTo(self.mainText.mas_bottom);
                make.width.mas_equalTo(30);
            }];
        }
    }
    [self.collectionView reloadData];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
}

- (CGFloat)myHeight {
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGFloat height = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
    
}

-(void)openOrClose:(UIButton *)btn{
    //开关状态
    btn.selected = !btn.selected;
    if(btn.selected == NO){
        //没有点击
        [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(70);
        }];
    }else{
        
        CGFloat collectionH = [self getCollectionViewHeight];
    
        [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(collectionH);
        }];
        [_bottom mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.collectionView.mas_bottom).offset(4);
            make.bottom.equalTo(self.backView.mas_bottom).offset(-8);
            make.height.mas_equalTo(20);
        }];
        
    }
    [self.collectionView reloadData];
    
    if (self.needReloadHeight) {
        //写更新高度的逻辑
        
        self.needReloadHeight();
    }
}

-(CGFloat)getCollectionViewHeight{
    CGFloat collectionH;
    //如果有余数加一行
    //没有余数 就是三方
    NSInteger rowNum = self.dataArray.count / 4;
    if(self.dataArray.count % 4 == 0){
        //没有余数
        rowNum = rowNum - 2;
    }else{
        rowNum = rowNum - 2 + 1;
    }
    collectionH = 70 + 40 * rowNum;
    return collectionH;
}

-(void)setSerializeStatus:(NSInteger)serializeStatus{
    _serializeStatus = serializeStatus;
    if(_serializeStatus == 1){
        _serializeLab.text = @"(已完结)";
    }
}
@end
