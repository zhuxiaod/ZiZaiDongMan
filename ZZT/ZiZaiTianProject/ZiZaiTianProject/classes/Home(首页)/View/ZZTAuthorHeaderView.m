//
//  ZZTAuthorHeaderView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/1.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTAuthorHeaderView.h"
#import "CommentSectionHeadView.h"

@interface ZZTAuthorHeaderView ()

@property (nonatomic,strong) UIView *authorDataView;

@property (nonatomic,strong) CommentSectionHeadView *commentSectionHeadView;

@property (nonatomic,strong) userAuthenticationIcon *userImg;

@property (nonatomic,strong) UILabel *userName;

@property (nonatomic,strong) UILabel *userIntro;

@property (nonatomic,strong) UILabel *bottomView;

@end

@implementation ZZTAuthorHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CommentSectionHeadView *commentSectionHeadView = [[CommentSectionHeadView alloc] init];
    _commentSectionHeadView = commentSectionHeadView;
    commentSectionHeadView.text = @"作者";
    [self.contentView addSubview:commentSectionHeadView];
    
    UIView *authorDataView = [[UIView alloc] init];
    _authorDataView = authorDataView;
    [self.contentView addSubview:authorDataView];
    
    //头像
    userAuthenticationIcon *userImg = [[userAuthenticationIcon alloc] init];
//    userImg.backgroundColor = [UIColor redColor];
    _userImg = userImg;
//    [userImg updateIconWithImageUrl:];
    [self.contentView addSubview:userImg];
    
    //ID
    UILabel *userName = [[UILabel alloc] init];
//    userName.backgroundColor = [UIColor orangeColor];
    _userName = userName;
    [self.contentView addSubview:userName];
    
    //介绍
    UILabel *userIntro = [[UILabel alloc] init];
//    userIntro.backgroundColor = [UIColor blueColor];
    _userIntro = userIntro;
    userIntro.numberOfLines = 2;
    userIntro.font = [UIFont systemFontOfSize:12];
    userIntro.text = @"测试数据：欢迎大家来看我的新作品，我是朱晓俊哈哈哈哈哈哈哈哈哈哈哈哈啊哈哈哈哈哈哈啊哈哈哈哈哈啊哈哈哈哈哈哈啊哈哈哈哈哈啊哈哈哈哈啊哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈";
    [self.contentView addSubview:userIntro];
    
    //底View
    UILabel *bottomView = [[UILabel alloc] init];
    _bottomView = bottomView;
    bottomView.backgroundColor = [UIColor colorWithRGB:@"246,246,251"];
    [self.contentView addSubview:bottomView];
}

-(void)layoutSubviews{
    [super layoutSubviews];

    [_commentSectionHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(0);
        make.right.left.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(40);
    }];
    
    [_authorDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentSectionHeadView.mas_bottom).offset(0);
        make.right.left.bottom.equalTo(self.contentView).offset(0);
    }];
    
    [self layoutIfNeeded];
    CGFloat userHW = self.authorDataView.height * 0.6;
    [_userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.authorDataView);
        make.left.equalTo(self.authorDataView.mas_left).offset(8);
        make.height.width.mas_equalTo(userHW);
    }];
    
    CGFloat userNameH = userHW * 0.6;
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.authorDataView);
        make.left.equalTo(self.userImg.mas_right).offset(4);
        make.height.mas_equalTo(userNameH);
        make.width.equalTo(self.authorDataView).multipliedBy(0.26);
    }];
    
    [_userIntro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.authorDataView);
        make.left.equalTo(self.userName.mas_right).offset(8);
        make.height.equalTo(self.authorDataView).multipliedBy(0.54);
        make.right.equalTo(self.authorDataView.mas_right).offset(-8);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.authorDataView).offset(0);
        make.height.mas_equalTo(4);
    }];
}

-(void)setUserModel:(UserInfo *)userModel{
    _userModel = userModel;
    [self.userImg updateIconWithImageUrl:userModel.headimg];
    
    self.userName.text = userModel.nickName;
    
    //简介
}

@end
