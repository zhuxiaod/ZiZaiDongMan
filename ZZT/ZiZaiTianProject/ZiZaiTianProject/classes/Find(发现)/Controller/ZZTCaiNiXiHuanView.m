//
//  ZZTCaiNiXiHuanView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/28.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTCaiNiXiHuanView.h"

@interface ZZTCaiNiXiHuanView ()

@property (weak, nonatomic) IBOutlet UIView *mainView;


@property (weak, nonatomic) IBOutlet UIButton *updateBtn;

@end

@implementation ZZTCaiNiXiHuanView

+(instancetype)CaiNiXiHuanView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self setupMainView];
    }
    return self;
}

-(void)setupMainView{
    
    [self layoutIfNeeded];
    CGFloat space = 5;
    CGFloat btnW = (SCREEN_WIDTH - space * 5)/6;
    CGFloat btnH = btnW;
    
    //获得数据 几个 6个
    for (int i = 0; i < 6; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"peien"] forState:UIControlStateNormal];
        CGFloat x = (btnW + space) * i;
        btn.frame = CGRectMake(x, 0, btnW, btnH);
        [self.mainView addSubview:btn];
    }
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [_updateBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClick:(UIButton *)button{
    // 判断下这个block在控制其中有没有被实现
    if (self.buttonAction) {
        // 调用block传入参数
        self.buttonAction(button);
    }
}
@end
