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
@property (nonatomic,strong) UIView *cellView;
@property (nonatomic,strong) UIImageView *rightImg;
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
    
    UIView *cellView = [[UIView alloc] init];
    _cellView = cellView;
    cellView.layer.cornerRadius = 12;
    cellView.layer.masksToBounds = YES;
    cellView.layer.borderWidth = 1.0f;
    cellView.layer.borderColor = [UIColor blackColor].CGColor;
    [self addSubview:cellView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
 
    [cellView addSubview:imageView];
    
    UIImageView *rightImg = [[UIImageView alloc] init];
    _rightImg = rightImg;
    rightImg.image = [UIImage imageNamed:@"众创作品角标"];
    [cellView addSubview:rightImg];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [_cellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self);
    }];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self).offset(0);
    }];
    
    [_rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.imageView);
    }];
}


-(void)setModel:(ZZTCarttonDetailModel *)model{
    _model = model;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.lbCover] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        NSLog(@"imageW:%f imageH:%f",image.size.width,image.size.height);
    }];
    
    _rightImg.hidden = [model.cartoonType isEqualToString:@"2"] ? NO:YES;


}

@end
