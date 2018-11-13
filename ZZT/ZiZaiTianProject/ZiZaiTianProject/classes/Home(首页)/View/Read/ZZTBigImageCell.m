//
//  ZZTBigImageCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/13.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTBigImageCell.h"
@interface ZZTBigImageCell ()

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation ZZTBigImageCell

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    [self addSubview:imageView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self).offset(0);
    }];
}

-(void)setModel:(ZZTCarttonDetailModel *)model{
    _model = model;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    
    self.imageView.layer.cornerRadius = 12;
    self.imageView.layer.masksToBounds = YES;
}
@end
