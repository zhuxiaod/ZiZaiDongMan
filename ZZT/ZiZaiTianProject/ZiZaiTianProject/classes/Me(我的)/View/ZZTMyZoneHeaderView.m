//
//  ZZTMyZoneHeaderView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTMyZoneHeaderView.h"
#import "ZZTMeEditViewController.h"

@interface ZZTMyZoneHeaderView ()
//背景
@property (nonatomic,strong) UIButton *backgroundBtn;
//用户
@property (nonatomic,strong) ZZTUserHeadView *userHead;

@property (nonatomic,strong) SBStrokeLabel *userName;

@end

@implementation ZZTMyZoneHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setUser:(UserInfo *)user{
    _user = user;
    
    [self.backgroundBtn sd_setImageWithURL:[NSURL URLWithString:user.cover] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"轻触更换背景"]];
    
    [self.backgroundBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    self.backgroundBtn.imageView.clipsToBounds = YES;
    
    [self.userHead setupUserHeadImg:user.headimg placeHeadImg:@"用户头像"];
 
    self.userName.text = user.nickName;
    
    [self.userName labOutline];

    //label宽度    
    CGFloat nameWidth = [user.nickName getTextWidthWithFont:self.userName.font] + 30;
    
    [_userName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(nameWidth);
    }];
}

-(void)setup{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _backgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backgroundBtn setImage:[UIImage imageNamed:@"轻触更换背景"] forState:UIControlStateNormal];
    [_backgroundBtn addTarget:self action:@selector(updateBackground) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    self.backgroundBtn.imageView.clipsToBounds = YES;
    [self.contentView addSubview:_backgroundBtn];
    
    _userHead = [[ZZTUserHeadView alloc] initWithFrame:CGRectZero];
//    [_userHead.viewClick addTarget:self action:@selector(print) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_userHead];

    //用户名
    _userName = [[SBStrokeLabel alloc] init];
    [_userName setTextColor:[UIColor whiteColor]];
    _userName.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_userName];
}

-(void)updateBackground{
    UserInfo *user = [Utilities GetNSUserDefaults];
    if(_user.id == user.id){
        //弹出更换视图
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"更换封面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //跳转编辑页
            ZZTMeEditViewController *meEditVC = [[ZZTMeEditViewController alloc] init];
            meEditVC.model = user;
            [[self myViewController].navigationController pushViewController:meEditVC animated:YES];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [actionSheet addAction:action1];
        [actionSheet addAction:action2];
        [[self myViewController] presentViewController:actionSheet animated:YES completion:nil];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [_backgroundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [_backgroundBtn.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self.backgroundBtn);
    }];
    
    [_userHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView).offset(-20);
        make.width.height.mas_equalTo(68);
    }];
    
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userHead);
        make.right.equalTo(self.userHead.mas_left).offset(-4);
        make.height.mas_equalTo(20);
    }];
}
@end
