//
//  ZZTChapterPriceView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/17.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTChapterPriceView.h"
#import "ZZTChapterPriceCell.h"
#import "ZZTChapterlistModel.h"
#import "ZZTLittleBoxView.h"

@interface ZZTChapterPriceView ()<UICollectionViewDataSource,UICollectionViewDelegate,TTTAttributedLabelDelegate,ZZTLittleBoxViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

//@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,strong) NSMutableArray *itemStyleArray;

@property (nonatomic,strong) TTTAttributedLabel *chapterPrice;

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UITextField *priceTF;

@property (nonatomic,assign) CGFloat labSpace;

@property (nonatomic,strong) TTTAttributedLabel *payChapterLab;

@property (nonatomic,assign) CGFloat payChapterLabW;

@end

@implementation ZZTChapterPriceView

//点击样式
-(NSMutableArray *)itemStyleArray{
    if(!_itemStyleArray){
        if(self.dataArray.count > 0){
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 0; i < self.dataArray.count; i++) {
                //创建价格模型
                NSNumber *isChange = @0;//不改变
                [array addObject:isChange];
            }
            _itemStyleArray = array;
        }
    }
    return _itemStyleArray;
}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    //每次点击这里都会创造出新的数组
    self.itemStyleArray = nil;
    [self.collectionView reloadData];
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        //添加UI
        [self addUI];
        
    }
    return self;
}

-(void)addUI{
//    _dataArray = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5", nil];

    //collectionView
    UICollectionViewFlowLayout *layout = [self setupCollectionViewFlowLayout];
    
    [self setupCollectionView:layout];
    
    //lab
    TTTAttributedLabel *chapterPrice = [TTTAttributedLabel new];
    chapterPrice.textColor = [UIColor lightGrayColor];
    chapterPrice.text = @"点击设定章节付费,单章价格为";
    CGFloat labW = [chapterPrice.text getTextWidthWithFont:chapterPrice.font];
    CGFloat labSpace = (SCREEN_WIDTH - labW - 96) / 2;
    _labSpace = labSpace;
    //计算长度
    _chapterPrice = chapterPrice;
    [self addSubview:chapterPrice];
    
    //img
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.image = [UIImage imageNamed:@"VIPChapterImage"];
    _imageView = imageView;
    [self addSubview:imageView];
    
    //金额输入框
    UITextField *priceTF = [[UITextField alloc] init];
    priceTF.keyboardType = UIKeyboardTypeDecimalPad;
    _priceTF = priceTF;
    [priceTF setTextColor:[UIColor lightGrayColor]];
    priceTF.delegate = self;
    priceTF.borderStyle = UITextBorderStyleRoundedRect;
    priceTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self addSubview:priceTF];
    
    //小box
    ZZTLittleBoxView *box = [[ZZTLittleBoxView alloc] init];
    box.delegate = self;
    _littleBox = box;
    [self addSubview:box];
    
    //lab
    TTTAttributedLabel *payChapterLab = [TTTAttributedLabel new];
    payChapterLab.textColor = [UIColor lightGrayColor];
    payChapterLab.lineSpacing = SectionHeaderLineSpace;
    payChapterLab.font = [UIFont systemFontOfSize:16];
    NSString *commitToMailStr = @"新章节默认设定为付费章节";
    _payChapterLabW = (SCREEN_WIDTH - (20 + 4 + [commitToMailStr getTextWidthWithFont:payChapterLab.font])) / 2;
    // 没有点击时候的样式
    payChapterLab.linkAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                       (NSString *)kCTForegroundColorAttributeName:[UIColor lightGrayColor],
                                       (NSString *)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
//
    payChapterLab.activeLinkAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIColor lightGrayColor],(NSString *)kCTForegroundColorAttributeName,nil];
    
    NSRange selRange1 = [commitToMailStr rangeOfString:@"新章节默认设定为付费章节"];
    
    payChapterLab.text = commitToMailStr;
    
    [payChapterLab addLinkToTransitInformation:@{@"select":@"新章节默认设定为付费章节"} withRange:selRange1];
    
    payChapterLab.delegate = self;
    
    self.payChapterLab = payChapterLab;
    
    [self addSubview:payChapterLab];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-20);
        make.left.equalTo(self).offset(20);
        make.height.mas_equalTo(40);
    }];
    
    [self.chapterPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
        make.left.equalTo(self).offset(self.labSpace);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chapterPrice.mas_centerY);
        make.left.equalTo(self.chapterPrice.mas_right).offset(4);
        make.height.width.mas_equalTo(20);
    }];
    
    [self.priceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chapterPrice.mas_centerY);
        make.left.equalTo(self.imageView.mas_right).offset(4);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(68);
    }];
    
    [self.littleBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceTF.mas_bottom).offset(10);
        make.height.width.mas_equalTo(20);
        make.left.equalTo(self).offset(self.payChapterLabW);
    }];
    
    [self.payChapterLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.littleBox.mas_centerY);
        make.left.equalTo(self.littleBox.mas_right).offset(4);
        make.height.mas_equalTo(20);
    }];
    
}

#pragma mark - 创建流水布局
-(UICollectionViewFlowLayout *)setupCollectionViewFlowLayout{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    [self layoutIfNeeded];
    //修改尺寸(控制)
    layout.itemSize = CGSizeMake(SCREEN_WIDTH/5 - 15,40/2 - 5);
    
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
    [self addSubview:collectionView];
    
    [collectionView registerClass:[ZZTChapterPriceCell class] forCellWithReuseIdentifier:@"ChapterPriceCell"];
}

//设置分组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//设置每个分组个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

//只有新的cell出现的时候才会调用
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZZTChapterlistModel *model = self.dataArray[indexPath.row];
    ZZTChapterPriceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChapterPriceCell" forIndexPath:indexPath];
    cell.model = model;
    cell.isChangeStyle = model.ifrelease;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //获取我点到的数据
    ZZTChapterlistModel *model = self.dataArray[indexPath.row];
    
    if(model.ifrelease == 1){
        
        model.ifrelease = 2;
        
        
    }else{
        
        model.ifrelease = 1;
        
    }
    
    [self.collectionView reloadData];
    
    //将这个数据传到C里面 进行比对
    
    //数组的
    if (self.delegate && [self.delegate respondsToSelector:@selector(setChapterPriceViewModel:)])
    {
        // 调用代理方法
        [self.delegate setChapterPriceViewModel:model];
    }
}

//cell 大小
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self layoutIfNeeded];
    return CGSizeMake((SCREEN_WIDTH - 40)/ 5 - 4 , 40);
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components {
    [self.littleBox btnTarget];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(setupPriceEnding:)])
    {
        // 调用代理方法
        [self.delegate setupPriceEnding:textField.text];
    }
}
@end
