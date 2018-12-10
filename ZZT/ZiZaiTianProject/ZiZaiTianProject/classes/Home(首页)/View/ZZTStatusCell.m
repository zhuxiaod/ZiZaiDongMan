//
//  ZZTStatusCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/6.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTStatusCell.h"
#import "userAuthenticationIcon.h"
#import "likeCountView.h"
#import "ZZTCircleModel.h"
#import "customer.h"

@interface ZZTStatusCell ()

@property (nonatomic,strong) UIView *statusContentView;

@property (nonatomic,strong) UIButton *userAuthenticationIcon;

@property (nonatomic,strong) UILabel *userNameLabel;

@property (nonatomic,strong) TTTAttributedLabel *contentTextLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) likeCountView *likeCountView;

@property (nonatomic,strong) UIButton *replyCountView;

@end

static CGFloat iconSize = 50;

@implementation ZZTStatusCell

- (void)setModel:(ZZTCircleModel *)model {
    _model = model;
    [self updateUIWithModel:model];
}

//更新数据
- (void)updateUIWithModel:(ZZTCircleModel *)model {
    
    customer *customer = model.customer;
    
    [self.userAuthenticationIcon sd_setBackgroundImageWithURL:[NSURL URLWithString:customer.headimg] forState:UIControlStateNormal];
    
    self.userNameLabel.text = customer.nickName;
    [self.userNameLabel setFont:[UIFont systemFontOfSize:18]];
    
    //内容
    self.contentTextLabel.text = model.content;
    
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat spaceing = SafetyW;
    CGFloat margin = 8;
    
    //头像 40*40
    [self.userAuthenticationIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(spaceing);//8
        make.width.height.equalTo(@(iconSize));
    }];
    
    //用户名
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userAuthenticationIcon.mas_right).offset(margin);
        make.centerY.equalTo(self.userAuthenticationIcon.mas_centerY);
        make.height.mas_equalTo(30);
        make.right.equalTo(self.contentView);
    }];
    
    //内容
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userAuthenticationIcon.mas_right).offset(margin);
        make.right.equalTo(self.contentView).offset(-margin);
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(spaceing);//8
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-8);
    }];
    
    UILongPressGestureRecognizer *longPressGest = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressView)];
    [self addGestureRecognizer:longPressGest];
}

-(void)longPressView{
    if ([_delegate respondsToSelector:@selector(longPressDeleteReply:)]) {
        [_delegate longPressDeleteReply:self.model];
    }
}

- (TTTAttributedLabel *)contentTextLabel {
    if (!_contentTextLabel) {
        //内容lab
        _contentTextLabel = [TTTAttributedLabel new];
        
        //16号字体
        _contentTextLabel.font = [UIFont systemFontOfSize:SectionHeaderBigFontSize];
        //不限制行数
        _contentTextLabel.numberOfLines = 0;
        //行距2
        _contentTextLabel.lineSpacing = SectionHeaderLineSpace;
        //省略号的样式
        _contentTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        //宽度
        _contentTextLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 8 - 40 - 8;

        [_contentTextLabel sizeToFit];
    
        [self.contentView addSubview:_contentTextLabel];

    }
    return _contentTextLabel;
}

//作者名
- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        
        UILabel *label = [[UILabel alloc] init];
        
        label.textColor = ZZTSubColor;
        label.font = [UIFont systemFontOfSize:14];
        
        [self.contentView addSubview:label];
        
        _userNameLabel = label;
        
    }
    return _userNameLabel;
}

//头像
- (UIButton *)userAuthenticationIcon {
    if (!_userAuthenticationIcon) {
        
        UIButton *headImg = [UIButton new];
        
        [headImg addTarget:self action:@selector(gotoZone) forControlEvents:UIControlEventTouchUpInside];
        
        _userAuthenticationIcon = headImg;
        
        [self.contentView addSubview:headImg];
    }
    return _userAuthenticationIcon;
}

//前往空间
-(void)gotoZone{
    ZZTMyZoneViewController *zoneVC = [[ZZTMyZoneViewController alloc] init];
    //用户id
    customer *customer = _model.customer;
    zoneVC.userId = customer.id;
    [[self myViewController].navigationController pushViewController:zoneVC animated:YES];
}

//前往作者页
- (void)gotoAuthorInfoVc {
    
//    AuthorInfoViewController *aiVc = [[AuthorInfoViewController alloc] init];
//    
//    aiVc.authorID = self.model.user.ID.stringValue;
//    
//    [self.myViewController.navigationController pushViewController:aiVc animated:YES];
}

- (CGFloat)myHeight {
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    return [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}
@end
