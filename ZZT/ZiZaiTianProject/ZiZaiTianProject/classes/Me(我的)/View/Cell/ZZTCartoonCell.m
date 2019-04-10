//
//  ZZTCartoonCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/6/28.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTCartoonCell.h"
#import "ZZTDetailModel.h"

@interface ZZTCartoonCell()

@property (strong, nonatomic) UIImageView *image;

@property (strong, nonatomic) UILabel *cartoonName;
@property (weak, nonatomic) UIImageView *rightImg;
@property (weak, nonatomic) UIView *topView;
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
    
    UIView *topView = [[UIView alloc] init];
    self.topView = topView;
    [self.contentView addSubview:topView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    _image = imageView;
    [topView addSubview:imageView];
    
    UILabel *cartoonName = [[UILabel alloc] init];
    _cartoonName = cartoonName;
    [self.contentView addSubview:cartoonName];
    
    UIImageView *rightImg = [[UIImageView alloc] init];
    self.rightImg = rightImg;
//    rightImg.contentMode = UIViewContentModeScaleToFill;
    rightImg.image = [UIImage imageNamed:@"众创作品角标"];
    [topView addSubview:rightImg];
    
    [self setupImgStyle];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat nameH = 20;
    
    [_cartoonName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(0);
        make.left.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(nameH);
    }];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(0);
        make.right.left.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.cartoonName.mas_top).offset(-4);
    }];
    
    
    [_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self.topView);
    }];
    
    [_rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.topView);
//        make.width.height.mas_equalTo(50);
    }];
//    self.image.backgroundColor = [UIColor orangeColor];
}

-(void)setCartoon:(ZZTCarttonDetailModel *)cartoon{
    _cartoon = cartoon;
    
    [self.image setContentMode:UIViewContentModeScaleAspectFill];

    [self.image sd_setImageWithURL:[NSURL URLWithString:cartoon.cover] placeholderImage:[UIImage imageNamed:@"chapterPlaceV"] options:0];
    
    self.cartoonName.text = cartoon.bookName;
    
    _rightImg.hidden = [cartoon.cartoonType isEqualToString:@"2"] ? NO:YES;

//    [self setupImgStyle];

    
//    NSLog(@"self.cartoonName.text:%@",self.cartoonName.text);
    
//    [self addLineSpacing:self.cartoonName];
}

-(void)setMaterialModel:(ZZTDetailModel *)materialModel{
    _materialModel = materialModel;
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:materialModel.img] placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {

    }];
    
    //判断是什么类型 选择不同的显示方式
    [self.image setContentMode:UIViewContentModeScaleAspectFill];
    
    self.cartoonName.text = materialModel.fodderName;
    
    _rightImg.hidden = [materialModel.cartoonType isEqualToString:@"2"] ? NO:YES;

 
}

-(void)setupImgStyle{
    
    [self setupStyle:self.topView];

}

-(void)setupStyle:(UIView *)imgView{
    imgView.layer.cornerRadius = 12;
    
    imgView.layer.masksToBounds = YES;
    
    imgView.layer.borderColor = [UIColor blackColor].CGColor;
    
    imgView.layer.borderWidth = 1.0f;

}

-(void)addLineSpacing:(UILabel *)label
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text attributes:@{NSKernAttributeName : @(1.5f)}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, label.text.length)];
    
    [label setAttributedText:attributedString];
    
    label.lineBreakMode = NSLineBreakByTruncatingTail;
}

@end
