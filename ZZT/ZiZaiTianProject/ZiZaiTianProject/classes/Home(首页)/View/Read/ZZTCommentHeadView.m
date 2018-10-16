//
//  ZZTCommentHeadView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/24.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTCommentHeadView.h"

@implementation ZZTCommentHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupUI];
    }
    return self;
    
}

-(void)setupUI{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    [lab setText:@"精彩点评"];
    [self addSubview:lab];
    
    CGFloat btnW = 50;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - btnW, 10, btnW, 20)];
    [btn setTitle:@"点评" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithHexString:@"#C4A9D3"];
    [self addSubview:btn];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor grayColor];
    [self addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.height.mas_equalTo(@1);
    }];
}

@end
