//
//  ZZTWordsDetailHeadView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/11.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTWordsDetailHeadView.h"
#import "ZZTWordsDetailViewController.h"
#import "ZXDCartoonFlexoBtn.h"
@interface ZZTWordsDetailHeadView()

@property (weak, nonatomic) IBOutlet UIImageView *bookCover;

@property (weak, nonatomic) IBOutlet SBStrokeLabel *bookName;

@property (weak, nonatomic) IBOutlet SBStrokeLabel *autherName;

@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (weak, nonatomic) IBOutlet UIButton *collectBtn;

@property (weak, nonatomic) IBOutlet SBStrokeLabel *likeLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titileViewW;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (nonatomic,weak) ZZTWordsDetailViewController *myVc;

@property (nonatomic,assign) BOOL show;

@property (nonatomic,strong) NSMutableArray *array;

@property (nonatomic,strong) NSString *ifCollect;

@property (weak, nonatomic) IBOutlet SBStrokeLabel *collectLab;

@end

@implementation ZZTWordsDetailHeadView

static NSString * const offsetKeyPath = @"contentOffset";

+(instancetype)wordsDetailHeadViewWithFrame:(CGRect)frame scorllView:(UIScrollView *)sc{
    //初始化xib
    ZZTWordsDetailHeadView *head = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil] firstObject];
    
    //赋值位置
    [head setFrame:frame];
    
    return head;
}

-(void)setDetailModel:(ZZTCarttonDetailModel *)detailModel{
    _detailModel = detailModel;
    
    self.collectLab.strokeColor = [UIColor blackColor];
    self.collectLab.strokeWidth = 1;
    
    //书名
    self.bookName.text = detailModel.bookName;
    self.bookName.strokeColor = [UIColor blackColor];
    self.bookName.strokeWidth = 1;
    
    //作者名
    self.autherName.text = detailModel.author;
    self.autherName.strokeColor = [UIColor blackColor];
    self.autherName.strokeWidth = 1;
    
    //热度
    if (detailModel.collectNum >= 10000) {
        self.likeLab.text = [NSString stringWithFormat:@"总热度 %ld万",detailModel.collectNum/10000];
    }else {
        self.likeLab.text = [NSString stringWithFormat:@"总热度 %ld",detailModel.collectNum];
    }
    self.likeLab.strokeColor = [UIColor blackColor];
    self.likeLab.strokeWidth = 1;
    
    //收藏
    if([detailModel.ifCollect isEqualToString:@"0"]){
        //未
        self.collectBtn.selected = NO;
    }else{
        self.collectBtn.selected = YES;
    }
    self.ifCollect = detailModel.ifCollect;
    
    //背景
    [self.bookCover sd_setImageWithURL:[NSURL URLWithString:detailModel.lbCover]];
    
    //title
    NSArray *titleArray = [detailModel.bookType componentsSeparatedByString:@","];
    self.titileViewW.constant = titleArray.count * 44;
    [self.titleView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger arrayCount = 0;
    if(titleArray.count >= 3){
        arrayCount = 3;
    }else{
        arrayCount = titleArray.count;
    }
    CGFloat space = 4;
    CGFloat labW = 50;
    CGFloat labH = 20;
    CGFloat y = (self.titleView.height - labH) / 2;
    CGFloat x = 0;
    for (NSUInteger i = 0; i < arrayCount; i++) {
        UILabel *label = [GlobalUI createLabelFont:14 titleColor:[UIColor whiteColor] bgColor:[UIColor colorWithWhite:0 alpha:0.6]];
        NSString *str = titleArray[i];
        label.layer.cornerRadius = 10.0f;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.borderColor = [UIColor whiteColor].CGColor;
        label.layer.borderWidth = 1;
        label.layer.masksToBounds = YES;
        label.text = str;
        label.frame = CGRectMake(x, y, labW, labH);
        x += labW + space;
        [self.titleView addSubview:label];
    }
    
    [self.collectBtn addTarget:self action:@selector(collectBook:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)collectBook:(UIButton *)sender {
    self.collectBtn.selected = !self.collectBtn.selected;
    
    //发送收藏代码
    if(_buttonAction){
        self.buttonAction(_detailModel);
    }
}

- (IBAction)back:(UIButton *)sender {
    [[self findResponderWithClass:[UINavigationController class]] popViewControllerAnimated:YES];
}

//懒加载
- (ZZTWordsDetailViewController *)myVc {
    
    if (!_myVc) {
        _myVc = [self findResponderWithClass:[ZZTWordsDetailViewController class]];
    }
    return _myVc;
}



@end
