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
    CGFloat nameH = 20;
    
    [_cartoonName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(0);
        make.left.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(nameH);
    }];
    
    [_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(0);
        make.right.left.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.cartoonName.mas_top).offset(-4);
    }];
    
   
    
    self.image.layer.cornerRadius = 12;
    self.image.layer.masksToBounds = YES;
//    self.image.backgroundColor = [UIColor orangeColor];
}

-(void)setCartoon:(ZZTCarttonDetailModel *)cartoon{
    _cartoon = cartoon;
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:cartoon.cover] placeholderImage:[UIImage imageNamed:@"chapterPlaceV"] options:0];
    
    self.cartoonName.text = cartoon.bookName;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.cartoonName.text attributes:@{NSKernAttributeName : @(1.5f)}];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.cartoonName.text.length)];
    
    [self.cartoonName setAttributedText:attributedString];
    
    self.cartoonName.lineBreakMode = NSLineBreakByTruncatingTail;
}

@end
