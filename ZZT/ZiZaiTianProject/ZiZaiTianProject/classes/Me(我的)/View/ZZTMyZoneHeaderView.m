//
//  ZZTMyZoneHeaderView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTMyZoneHeaderView.h"

@implementation ZZTMyZoneHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

-(void)setup{
    self.backgroundColor = [UIColor whiteColor];
    UIImageView *bgImgV = [UIImageView new];
    bgImgV.contentMode = UIViewContentModeScaleAspectFill;
    bgImgV.clipsToBounds = YES;
    bgImgV.image = [UIImage imageNamed:@"peien"];
    
    UIView *headBgView = [UIView new];
    headBgView.backgroundColor = [UIColor whiteColor];
    headBgView.layer.borderWidth = 0.5;
    headBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UIImageView *headImgV = [UIImageView new];
    headImgV.contentMode = UIViewContentModeScaleAspectFill;
    headImgV.clipsToBounds = YES;
    headImgV.image = [UIImage imageNamed:@"peien"];
    
    UILabel *label = [UILabel new];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont systemFontOfSize:19];
    label.text = @"雏田";
    
    [self addSubview:bgImgV];
    [bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-40);
        make.top.equalTo(self).offset(-TOPBAR_HEIGHT);
    }];
    [self addSubview:headBgView];
    [headBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-20);
        make.right.equalTo(self).offset(-10);
        make.width.height.equalTo(@75);
    }];
    [headBgView addSubview:headImgV];
    [headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(headBgView).offset(3);
        make.right.bottom.equalTo(headBgView).offset(-3);
    }];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headBgView.mas_left).offset(-20);
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(bgImgV).offset(-7);
        make.height.equalTo(@25);
    }];
}
@end
