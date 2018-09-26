//
//  ZZTShoppingMallViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/5.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTShoppingMallViewController.h"
#import "ZZTShoppingMallCell.h"
#import "ZZTShoppingBtnModel.h"
#import "ZZTShoppingHeader.h"
#import "ZZTShoppingBtnCell.h"
#import "ZZTMaterialCell.h"
#import "ZZTShoppingHeaderView.h"
#import <SDCycleScrollView.h>
#import "ZXDCartoonFlexoBtn.h"
#import "ZZTMallRecommendView.h"

@interface ZZTShoppingMallViewController ()<SDCycleScrollViewDelegate,UICollectionViewDelegate>
@property (nonatomic,assign) int i;

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *btnView;
@end

@implementation ZZTShoppingMallViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = self.viewTitle;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView = scrollView;
    scrollView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [self.view addSubview:scrollView];
    
    NSArray *imagesURLStrings = [NSArray arrayWithObjects: @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535282045025&di=b648e41d5d5a3535e5518a545459d351&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20161123%2Fbfa082e23cd94089a907a29b021946bf_th.jpeg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535282045025&di=d2ddcf88c11b57887d64db25c870bd4f&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20170919%2F210211af972f4e3c8c5a7fda0fda7493.jpeg", nil];
    
    //网络轮播图
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180) delegate:self placeholderImage:[UIImage imageNamed:@"peien"]];
    //数组
    cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    cycleScrollView.autoScrollTimeInterval = 5.0f;// 自动滚动时间间隔
    [scrollView addSubview:cycleScrollView];
    
    //btnView
    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(0, 180, SCREEN_WIDTH, 90)];
    midView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:midView];
    
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 120, 0, 240, 90)];
//    btnView.backgroundColor = [UIColor yellowColor];
    self.btnView = btnView;
    [midView addSubview:btnView];
    
    self.i = 0;
    [self getBtnWithTitle:@"定制形象" image:@"图标-定制-形象"];
    [self getBtnWithTitle:@"定制封面" image:@"图标-定制-封面"];
    [self getBtnWithTitle:@"定制漫画" image:@"图标-定制-漫画"];
    [self getBtnWithTitle:@"定制剧本" image:@"图标-定制-剧本"];

    //素材推荐
    ZZTMallRecommendView *mallRecommendView = [[ZZTMallRecommendView alloc] initWithFrame:CGRectMake(0, midView.y+midView.height + 15, SCREEN_WIDTH, 200)];
    mallRecommendView.title = @"素材推荐";
    mallRecommendView.backgroundColor = [UIColor yellowColor];
    [scrollView addSubview:mallRecommendView];
    
    //漫画推荐
    ZZTMallRecommendView *cartoonRecommendView = [[ZZTMallRecommendView alloc] initWithFrame:CGRectMake(0, mallRecommendView.y+mallRecommendView.height + 15, SCREEN_WIDTH, 200)];
    cartoonRecommendView.title = @"漫画推荐";
    cartoonRecommendView.backgroundColor = [UIColor yellowColor];
    [scrollView addSubview:cartoonRecommendView];
    
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, cartoonRecommendView.y + cartoonRecommendView.height+100);
}

-(void)getBtnWithTitle:(NSString *)title image:(NSString *)image
{
    CGFloat space = 10;

    CGFloat btnW = self.btnView.width / 4 - space;
    CGFloat btnH = self.btnView.height-10;
    CGFloat x = (btnW + space) * self.i;

    ZXDCartoonFlexoBtn *btn = [[ZXDCartoonFlexoBtn alloc] init];
    btn.frame = CGRectMake(x, 10, btnW, btnH);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [self.btnView addSubview:btn];
    self.i++;
}
@end
