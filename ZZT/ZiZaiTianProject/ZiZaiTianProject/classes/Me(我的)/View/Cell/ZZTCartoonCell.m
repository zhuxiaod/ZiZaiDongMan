//
//  ZZTCartoonCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/6/28.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTCartoonCell.h"
@interface ZZTCartoonCell()

@property (strong, nonatomic) UIImageView *image;

@property (strong, nonatomic) UILabel *cartoonName;

@end

@implementation ZZTCartoonCell

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    UIImageView *imageView = [[UIImageView alloc] init];
    _image = imageView;
    [self.contentView addSubview:imageView];
    
    UILabel *cartoonName = [[UILabel alloc] init];
    _cartoonName = cartoonName;
    [self.contentView addSubview:cartoonName];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat imageH = self.height * 0.8;
    CGFloat nameH = self.height - imageH;
    [_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(0);
        make.right.left.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(imageH);
    }];
    
    [_cartoonName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.image.mas_bottom).offset(4);
        make.left.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(nameH);
    }];
    
    self.image.layer.cornerRadius = 12;
    self.image.layer.masksToBounds = YES;
    self.image.backgroundColor = [UIColor orangeColor];
}

-(void)setIsHaveLab:(BOOL)isHaveLab{
    _isHaveLab = isHaveLab;
    
    //计算高度
    CGFloat cellH = SCREEN_HEIGHT * 0.26;
    CGFloat airH = cellH - cellH * 0.8 - 20;
    
    self.cartoonName.hidden = YES;
    
    [_image mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_bottom).offset(4);
        make.left.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView).offset(0);
    }];
}

-(void)setCartoon:(ZZTCarttonDetailModel *)cartoon{
    _cartoon = cartoon;
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:cartoon.cover]];
    
    self.cartoonName.text = cartoon.bookName;
}

@end
