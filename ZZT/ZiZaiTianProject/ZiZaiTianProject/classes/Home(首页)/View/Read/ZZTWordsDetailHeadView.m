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

@property (weak, nonatomic) IBOutlet UIImageView *cartoonCover;
@property (weak, nonatomic) IBOutlet UILabel *cartoonName;
@property (weak, nonatomic) IBOutlet UILabel *cartoonTitle;
@property (weak, nonatomic) IBOutlet UILabel *heatNum;
@property (weak, nonatomic) IBOutlet UILabel *participationNum;
@property (weak, nonatomic) IBOutlet UILabel *likeNum;
@property (weak, nonatomic) IBOutlet UILabel *commentNum;
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIImageView *like;
@property (weak, nonatomic) IBOutlet UIImageView *comment;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic,weak) ZZTWordsDetailViewController *myVc;
@property (nonatomic,assign) BOOL  show;
@property (nonatomic,strong) NSMutableArray *array;
@property (weak, nonatomic) IBOutlet ZXDCartoonFlexoBtn *collectBtn;
@property (nonatomic,strong) NSString *ifCollect;
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

-(void)setDetailModel:(ZZTCarttonDetailModel *)detailModel
{
    _detailModel = detailModel;
    //设置数据
    if([detailModel.type isEqualToString:@"1"]){
        NSString *bookName = [detailModel.bookName stringByAppendingString:@"(漫画)"];
        NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:bookName];
        [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#598BE2"] range:NSMakeRange(attriStr.length - 4,4)];
        self.cartoonName.attributedText = attriStr;
    }else if([detailModel.type isEqualToString:@"2"]){
        NSString *bookName = [detailModel.bookName stringByAppendingString:@"(剧本)"];
        NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:bookName];
        [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#87CDBF"] range:NSMakeRange(attriStr.length - 4,4)];
        self.cartoonName.attributedText = attriStr;
    }
    
    [self.cartoonCover sd_setImageWithURL:[NSURL URLWithString:detailModel.cover]];
//    self.cartoonName.text = detailModel.bookName;
    NSString *bookType = [detailModel.bookType stringByReplacingOccurrencesOfString:@"," withString:@" "];
    self.cartoonTitle.text = [NSString stringWithFormat:@"标签  %@",bookType];
    //热度
//    self.heatNum.text = detailModel.praiseNum;

    if (detailModel.collectNum >= 10000) {
        self.participationNum.text = [NSString stringWithFormat:@"收藏： %zd万",detailModel.collectNum/10000];
    }else {
        self.participationNum.text = [NSString stringWithFormat:@"收藏： %zd",detailModel.collectNum];
    }
    
    self.likeNum.text = [NSString stringWithFormat:@"%ld",detailModel.praiseNum];

    self.commentNum.text = [NSString stringWithFormat:@"%ld",detailModel.commentNum];
    
    if (detailModel.clickNum >= 10000) {
        self.heatNum.text = [NSString stringWithFormat:@"热度：%zd",detailModel.clickNum/10000];
    }else {
        self.heatNum.text = [NSString stringWithFormat:@"热度：%zd",detailModel.clickNum];
    }
    
    if([detailModel.ifCollect isEqualToString:@"0"]){
        //未
        [self.collectBtn setImage:[UIImage imageNamed:@"作品-作品信息-收藏-未收藏"] forState:UIControlStateNormal];
    }else{
        [self.collectBtn setImage:[UIImage imageNamed:@"作品-作品信息-收藏-已收藏"] forState:UIControlStateNormal];
    }
    _ifCollect = detailModel.ifCollect;
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

//收藏
- (IBAction)clickCollectBtn:(ZXDCartoonFlexoBtn *)sender {
    if([_ifCollect isEqualToString:@"0"]){
        //收藏 变1
        _ifCollect = @"1";
        //换图
        [self.collectBtn setImage:[UIImage imageNamed:@"作品-作品信息-收藏-已收藏"] forState:UIControlStateNormal];
    }else{
        //取消收藏  变0
        _ifCollect = @"0";
        [self.collectBtn setImage:[UIImage imageNamed:@"作品-作品信息-收藏-未收藏"] forState:UIControlStateNormal];
    }
    //block
    
    if(_buttonAction){
        self.buttonAction(_detailModel);
    }
   
}


@end
