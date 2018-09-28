//
//  ZZTContinueToDrawHeadView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/23.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTContinueToDrawHeadView.h"
#import "ZZTXuHuaBtn.h"
#import "ZZTCartoonModel.h"
#import "ZZTChapterlistModel.h"

@interface ZZTContinueToDrawHeadView ()

@property (weak, nonatomic) IBOutlet UIButton *XuHuaBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *xuHuaView;

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImageView *headView;
@property (nonatomic,strong) UIImageView *likeView;
@property (nonatomic,strong) UILabel *likeNum;



@end

@implementation ZZTContinueToDrawHeadView



+(instancetype)ContinueToDrawHeadView{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZZTContinueToDrawHeadView" owner:nil options:nil]lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.XuHuaBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.XuHuaBtn.layer.borderWidth = 2.0f;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.XuHuaBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnClick:(UIButton *)sender{
    if(self.buttonAction){
        self.buttonAction(sender);
    }
}
-(void)setArray:(NSArray *)array{
    _array = array;

    CGFloat titleW = self.XuHuaBtn.width;
    CGFloat titleH = self.scrollView.height;
    CGFloat space = 10;
    self.scrollView.contentSize = CGSizeMake(600, titleH);
    NSLog(@"scrollView frame:%@",NSStringFromCGRect(self.scrollView.frame));
    for (int i = 0; i < array.count; i++) {
        ZZTChapterlistModel *model = array[i];
        //数据源
        CGFloat x = space + (titleW + space) * i;
        ZZTXuHuaBtn *btn = [[ZZTXuHuaBtn alloc] initWithFrame:CGRectMake(x, 0, titleW, titleH)];
        btn.imageUrl = model.headimg;
        btn.loveNum = [NSString stringWithFormat:@"%ld",model.praiseNum];
        [self.scrollView addSubview:btn];
    }
    //算出移动的内容距离
    self.scrollView.contentSize = CGSizeMake((titleW+space)*array.count, titleH);
}

@end
