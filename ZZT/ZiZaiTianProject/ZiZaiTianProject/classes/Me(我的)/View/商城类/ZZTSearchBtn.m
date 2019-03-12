//
//  ZZTSearchBtn.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/2/22.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import "ZZTSearchBtn.h"

@implementation ZZTSearchBtn

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //添加UI
        [self addUI];
    }
    return self;
}

-(void)addUI{
    //圆view
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor colorWithRGB:@"90,71,118"];
    bottomView.userInteractionEnabled = YES;
    [self addSubview:bottomView];
    
    bottomView.layer.cornerRadius = 15;
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self);
    }];
    
    //放大镜
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"搜索图标"];
    [self addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(8);
        make.height.width.mas_equalTo(18);
    }];
}

@end
