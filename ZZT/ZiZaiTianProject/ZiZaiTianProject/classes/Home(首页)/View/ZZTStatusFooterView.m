//
//  ZZTStatusFooterView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/6.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTStatusFooterView.h"
#import "likeCountView.h"
#import "ZZTCircleModel.h"

@interface ZZTStatusFooterView ()

//时间
@property (nonatomic,strong) UILabel *timeLabel;

//点赞
@property (nonatomic,strong) likeCountView *likeCountView;

//评论
@property (nonatomic,weak) UIButton *replyCountView;


@end

@implementation ZZTStatusFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(4);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-4);
        make.left.equalTo(self.contentView).offset(52);
    }];
    
    [self.replyCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-4);
        make.centerY.equalTo(self.timeLabel);
        make.width.equalTo(@0);
    }];
    
    [self.likeCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLabel);
        make.right.equalTo(self.replyCountView.mas_left).offset(-8);
    }];
}

-(void)setModel:(ZZTCircleModel *)model{
    _model = model;
    self.timeLabel.text = model.commentDate;

    //点赞的数量
    self.likeCountView.likeCount = model.praiseNum;
    self.likeCountView.requestID = @"20";
    //是否点赞
    self.likeCountView.islike = [model.ifPraise integerValue];
    
    //回复评论数量
    NSString *replayCountText = [NSString makeTextWithCount:model.replyComment.count];
    //回复数据
    [self.replyCountView setTitle:replayCountText forState:UIControlStateNormal];
    //评论宽度
    CGFloat replyCountWidth = [replayCountText getTextWidthWithFont:self.replyCountView.titleLabel.font] + 30;
    //设置宽度
    [self.replyCountView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(replyCountWidth));
    }];
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        
        UILabel *label = [[UILabel alloc] init];
        
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor lightGrayColor];
        label.numberOfLines = 1;
        
        [self.contentView addSubview:label];
        
        _timeLabel = label;
        
    }
    return _timeLabel;
}

- (likeCountView *)likeCountView {
    if (!_likeCountView) {
        likeCountView *lcv = [[likeCountView alloc] init];
        
        weakself(self);
        
        [lcv setOnClick:^(likeCountView *btn) {
//            weakSelf.model.is_liked = !weakSelf.model.is_liked;
        }];
        
        [self.contentView addSubview:lcv];
        
        _likeCountView = lcv;
    }
    return _likeCountView;
}

- (UIButton *)replyCountView {
    if (!_replyCountView) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [btn setTitleColor:[self.likeCountView titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"作品-作品信息-评论(灰色）"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showCommentVc) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
        _replyCountView = btn;
    }
    
    return _replyCountView;
}

-(void)showCommentVc{
    if ([_delegate respondsToSelector:@selector(didClickCommentButton:)]) {
        [_delegate didClickCommentButton:self.model];
    }
}
@end
