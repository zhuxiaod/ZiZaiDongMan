//
//  ZZTChapterPayViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/30.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTChapterPayViewController.h"
#import "ZZTChapterChooseCell.h"
#import "ZZTMeWalletViewController.h"

@interface ZZTChapterPayViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *buyOptionView;

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *dataArray;

@property (nonatomic,strong) NSMutableArray *itemStyleArray;

@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (weak, nonatomic) IBOutlet UILabel *ZbLab;

@property (weak, nonatomic) IBOutlet UIView *moneyView;

@end

@implementation ZZTChapterPayViewController
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.moneyView.layer.cornerRadius = 2;
    self.moneyView.layer.borderWidth = 1.0f;
    self.moneyView.layer.borderColor = ZZTSubColor.CGColor;
    self.moneyView.layer.masksToBounds = YES;
    
    //赋值ZB
    self.ZbLab.text = [NSString stringWithFormat:@"%ld", (long)[Utilities GetNSUserDefaults].zzbNum];
//    NSLog(@"%@",);
    
    //确认支付Btn
    self.payBtn.layer.cornerRadius = 32;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];
    }];

    
    UICollectionViewFlowLayout *layout = [self setupCollectionViewFlowLayout];
    [self setupCollectionView:layout];
    
    self.dataArray = [NSArray arrayWithObjects:@"购买话",@"后10话",@"后30话",@"剩余30话", nil];
}

#pragma mark - 创建流水布局
-(UICollectionViewFlowLayout *)setupCollectionViewFlowLayout{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    [self.view layoutIfNeeded];
    NSLog(@"self.contentView:%f",self.buyOptionView.height);
    //修改尺寸(控制)
//    layout.itemSize = CGSizeMake(SCREEN_WIDTH/4 - 15,_collectionView.height/2 - 5);
    
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
    [_buyOptionView addSubview:collectionView];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.buyOptionView.mas_centerY);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(30);
    }];
    
    [collectionView registerClass:[ZZTChapterChooseCell class] forCellWithReuseIdentifier:@"ChapterChooseCell"];
}

//设置分组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
    
}
//设置每个分组个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

//只有新的cell出现的时候才会调用
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZZTChapterChooseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChapterChooseCell" forIndexPath:indexPath];
    NSString *str = self.dataArray[indexPath.row];
    cell.str = str;
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
    
    //点击发生什么
}

//cell 大小
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [self layoutIfNeeded];
    return CGSizeMake(SCREEN_WIDTH / 4 - 20 , 30);
}

#pragma mark 定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 8, 0, 8);//（上、左、下、右 ）
    
}


- (IBAction)back:(UIButton *)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];

//    self.view.backgroundColor = [UIColor clearColor];
//    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.1];
}

- (IBAction)pushTopUpView:(UIButton *)sender {
    //钱包
    ZZTMeWalletViewController *walletVC = [[ZZTMeWalletViewController alloc] init];
    [self.navigationController pushViewController:walletVC animated:YES];
}


@end
