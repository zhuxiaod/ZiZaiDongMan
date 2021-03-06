//
//  ZZTMeTopView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/6/26.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTMeTopView.h"


@interface ZZTMeTopView ()
@property (weak, nonatomic) IBOutlet UIButton *backgroundBtn;

@property (weak, nonatomic) IBOutlet ZZTUserHeadView *userHead;

@property (weak, nonatomic) IBOutlet UIButton *userName;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameW;

@property (weak, nonatomic) IBOutlet UILabel *likeNum;

@property (weak, nonatomic) IBOutlet UILabel *attentionNum;

@end

@implementation ZZTMeTopView 

-(void)setUserModel:(UserInfo *)userModel{
    _userModel = userModel;
    
    [self.backgroundBtn sd_setImageWithURL:[NSURL URLWithString:userModel.cover] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Me_homeBackground"] options:0];

    [self.userHead setupUserHeadImg:userModel.headimg placeHeadImg:@"Me_topView_headImage"];
    
    //得到字的宽度 + 20距离
    if(userModel.nickName == nil || [userModel.nickName isEqualToString:@""]){
        [self.userName setTitle:@"我要登录" forState:UIControlStateNormal];
    }else{
        [self.userName setTitle:userModel.nickName forState:UIControlStateNormal];
    }
    
    CGFloat replyCountWidth = [_userName.titleLabel.text getTextWidthWithFont:self.userName.titleLabel.font];
    replyCountWidth += 20;
    self.userNameW.constant = replyCountWidth;
    
    self.likeNum.text = [NSString stringWithFormat:@"粉丝:%ld",[userModel.fansNum integerValue]];
    
    self.attentionNum.text = [NSString stringWithFormat:@"关注:%ld",[userModel.attentionNum integerValue]];

}


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"ZZTMeTopView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
        
        [self.userHead setupUserHeadImg:@"Me_topView_headImage" placeHeadImg:@"Me_topView_headImage"];

    }
    return self;
}


+(instancetype)meTopView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    [self.backgroundBtn.imageView setImage:[UIImage imageNamed:@"Me_homeBackground"]];

    [self.backgroundBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    _backgroundBtn.adjustsImageWhenHighlighted=NO;
    
    self.backgroundBtn.imageView.clipsToBounds = YES;
    
    [self.backgroundBtn.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundBtn.mas_top);
        make.right.equalTo(self.backgroundBtn.mas_right);
        make.left.equalTo(self.backgroundBtn.mas_left);
        make.bottom.equalTo(self.backgroundBtn.mas_bottom);
    }];
    
    self.userName.layer.cornerRadius = 10;
    
    self.userName.layer.masksToBounds = YES;
    
    //name手势
    [self.userName addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.userHead.viewClick addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backgroundBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)buttonClick:(UIButton *)button{
    // 判断下这个block在控制其中有没有被实现
    if (self.buttonAction && ![self.userModel.userType isEqualToString:@"3"] && self.userModel != nil) {
        // 调用block传入参数
        self.buttonAction(button);
    }else{
        //登录
        self.loginAction(button);
    }
}

////跳转签到界面
//- (IBAction)pushSignInView:(id)sender {
//    //登录了才能签到
//    if(self.userModel.isLogin == YES){
//        ZZTSignInViewController *signInVC = [[ZZTSignInViewController alloc] init];
//        signInVC.hidesBottomBarWhenPushed = YES;
//        [[self myViewController].navigationController pushViewController:signInVC animated:YES];
//    }else{
//        self.loginAction(sender);
//    }
//}

@end
