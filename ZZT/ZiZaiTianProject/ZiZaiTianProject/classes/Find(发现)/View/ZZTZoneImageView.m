//
//  ZZTZoneImageView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/7.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTZoneImageView.h"

@interface ZZTZoneImageView()

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation ZZTZoneImageView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    [self.contentView addSubview:imageView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self.contentView);
    }];
}

-(void)setImage:(UIImage *)image{
    _image = image;
    _imageView.image = image;
}
@end
