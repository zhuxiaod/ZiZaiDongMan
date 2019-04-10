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
//关注btn
@property (nonatomic,strong) AttentionButton *attentionButton;

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
    _userImg = userImg;
    [authorDataView addSubview:userImg];
    
    //ID
    UILabel *userName = [[UILabel alloc] init];
//    userName.backgroundColor = [UIColor orangeColor];
    _userName = userName;
    userName.textColor = ZZTSubColor;
    [authorDataView addSubview:userName];
    
    //介绍
    UILabel *userIntro = [[UILabel alloc] init];
//    userIntro.backgroundColor = [UIColor blueColor];
    _userIntro = userIntro;
    userIntro.numberOfLines = 2;
    userIntro.font = [UIFont systemFontOfSize:12];
//    userIntro.text = @";
    [authorDataView addSubview:userIntro];
    
    //关注btn
//    _attentionButton = [[AttentionButton alloc] init];
//    _attentionButton.hidden = YES;
//    [self.contentView addSubview:_attentionButton];
    
    //底View
    UILabel *bottomView = [[UILabel alloc] init];
    _bottomView = bottomView;
    bottomView.backgroundColor = [UIColor colorWithRGB:@"246,246,251"];
    [authorDataView addSubview:bottomView];
}

-(void)layoutSubviews{
    [super layoutSubviews];

    [_commentSectionHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.width.mas_equalTo(Screen_Width);
        make.height.mas_equalTo(40);
    }];
    
    [_authorDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentSectionHeadView.mas_bottom).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.width.mas_equalTo(Screen_Width);
        make.height.mas_equalTo(90);
    }];
    
    [_userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.authorDataView.mas_centerY);
        make.left.equalTo(self.authorDataView.mas_left).offset(8);
    make.height.width.equalTo(self.authorDataView.mas_height).multipliedBy(0.6);
    }];
    
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userImg.mas_top);
        make.left.equalTo(self.userImg.mas_right).offset(8);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    [_userIntro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.userImg.mas_bottom);
        make.left.equalTo(self.userImg.mas_right).offset(8);
        make.height.equalTo(self.userImg.mas_height).multipliedBy(0.6);
        make.width.mas_equalTo(100);
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
    
    //关注
//    _attentionButton.isAttention = NO;
//    _attentionButton.hidden = YES;
//    self.attentionButton.userInteractionEnabled = NO;
}

@end
