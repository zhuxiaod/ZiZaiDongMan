//
//  userAuthenticationIcon.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/7/6.
//  Copyright © 2016年 name. All rights reserved.
//

#import "userAuthenticationIcon.h"
#import <Masonry.h>
#import "UIImageView+Extension.h"

@interface userAuthenticationIcon ()
//用户头像
@property (nonatomic,weak,) UIImageView *userIcon;
//Vip标识
@property (nonatomic,weak)  UIImageView *authenticatIcon;

@end

@implementation userAuthenticationIcon
//更新用户头像
- (void)updateIconWithImageUrl:(NSString *)imageUrl {
    
    [self.userIcon setRoundImageWithURL:imageUrl placeImageName:@"ic_personal_avatar_83x83_"];
    
}
//初始化大小
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}
//初始化UI
- (void)setupUI {
    //添加头像
    UIImageView *icon = [[UIImageView alloc] init];
    
    [self addSubview:icon];
    //适应
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _userIcon = icon;
    
    self.backgroundColor = [UIColor clearColor];
    icon.backgroundColor = self.backgroundColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat size = self.bounds.size.width;
    CGFloat margin = size * 0.01;
    //vip
    [self.authenticatIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(margin, margin, margin, margin));
    }];
    
    NSString *imageName = size > 30 ? @"ic_author_info_headportrait_v_78x78_":@"ic_details_top_auther_headportrait_v_45x45_";
    
    self.authenticatIcon.image = [UIImage imageNamed:imageName];
    
    [super layoutSubviews];
}

//隐藏vip
- (void)setHasAuthentication:(BOOL)hasAuthentication {
    _hasAuthentication = hasAuthentication;
    self.authenticatIcon.hidden = !hasAuthentication;
}
//创建vip
- (UIImageView *)authenticatIcon {
    if (!_authenticatIcon) {
        
        UIImageView *authenticatIcon = [[UIImageView alloc] init];
        [self addSubview:authenticatIcon];
        
        [authenticatIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        _authenticatIcon = authenticatIcon;
    }
    return _authenticatIcon;
}

@end
