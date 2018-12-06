//
//  replyCountView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/6.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "replyCountView.h"


#define MyWidth 30.0f

@implementation replyCountView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    
    [self setup];
    
}

- (void)setup {
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0,8, 0, 0)];
    
    self.titleLabel.font = [UIFont systemFontOfSize:12];

    [self setTitle:@"0" forState:UIControlStateNormal];
    
    
    [self setTitleColor:ZZTSubColor forState:UIControlStateNormal];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //点赞的地方  添加
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(2);
        make.centerY.equalTo(self);
    }];
    
    //点赞的地方  添加
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(2);
        make.centerY.equalTo(self);
        make.height.mas_offset(18);
    }];
    
    [self setImage:[[UIImage imageNamed:@"wordDetail_comment"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    
    [self setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
}


@end
