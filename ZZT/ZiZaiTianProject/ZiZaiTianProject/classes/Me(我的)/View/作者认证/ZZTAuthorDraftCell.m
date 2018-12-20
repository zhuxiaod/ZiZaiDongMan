//
//  ZZTAuthorDraftCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/14.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTAuthorDraftCell.h"
#import "ZZTCarttonDetailModel.h"

@interface ZZTAuthorDraftCell()

@property (strong, nonatomic) UIImageView *image;

@property (strong, nonatomic) UILabel *cartoonName;

@property (strong, nonatomic) UIButton *button;

@end

@implementation ZZTAuthorDraftCell

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
    imageView.layer.cornerRadius = 12.0f;
    imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:imageView];
    
    UILabel *cartoonName = [[UILabel alloc] init];
    _cartoonName = cartoonName;
    [self.contentView addSubview:cartoonName];
    
    //发布按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button = button;
    button.userInteractionEnabled = NO;
    [button setBackgroundColor:ZZTSubColor];
    [button setTitle:@"发布" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 8.0f;
    button.layer.masksToBounds = YES;
    [self.contentView addSubview:button];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.height.mas_equalTo(40);
    }];
    
    [self.cartoonName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.button.mas_top).offset(-10);
        make.right.left.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(20);
    }];
    
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.cartoonName.mas_top).offset(-4);
        make.top.equalTo(self.contentView).offset(0);
        make.right.left.equalTo(self.contentView).offset(0);
    }];

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
