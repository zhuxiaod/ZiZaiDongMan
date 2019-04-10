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
@property (nonatomic,weak) likeCountView *replyCountView;

@property (nonatomic,weak) UIView *bottomView;


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

    //举报
    _reportBtn = [[ZZTReportBtn alloc] init];
    [self.contentView addSubview:_reportBtn];
    
    //底线
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor colorWithRGB:@"246,246,251"];
    _bottomView = bottomView;
    [self.contentView addSubview:bottomView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(40);
        make.left.equalTo(self.contentView).offset(70);
    }];
    
    [self.replyCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-4);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    [self.likeCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.replyCountView.mas_left).offset(-8);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    //举报
    [self.reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.likeCountView);
        make.right.equalTo(self.likeCountView.mas_left).offset(-64);
        make.height.width.mas_equalTo(20);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
}

-(void)setModel:(ZZTCircleModel *)model{
    _model = model;
    self.timeLabel.text = model.commentDate;

    //点赞的数量
    self.likeCountView.likeCount = model.praiseNum;
    
    self.likeCountView.islike = [model.ifPraise integerValue];

    //回复评论数量
    self.replyCountView.likeCount = model.replyComment.count;

    _reportBtn.hidden = NO;
    if([Utilities GetNSUserDefaults].id == [self.model.customer.id integerValue]){
        _reportBtn.hidden = YES;
    }
    _reportBtn.circleModel = model;
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
        
        [self.contentView addSubview:lcv];
        
        [lcv likeCountViewWithImg:LikeIconImg selectImg:LikeIconImg_Select];
        
        _likeCountView = lcv;
        
        
        weakself(self);
        
        [lcv setOnClick:^(likeCountView *btn) {
            if(self.isFind == YES){
                [weakSelf findLikeTarget];
            }else{
                [weakSelf likeTarget];
            }
        }];
        
      
    }
    return _likeCountView;
}

//发现点赞
-(void)findLikeTarget{
    UserInfo *user = [Utilities GetNSUserDefaults];
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    NSDictionary *dic = @{
                          @"type":@"2",
                          @"typeId":_model.id,
                          @"userId":[NSString stringWithFormat:@"%ld",user.id],
                          };
    [manager POST:[ZZTAPI stringByAppendingString:@"great/praises"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(self.update){
            self.update();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//卡通点赞
-(void)likeTarget{

    UserInfo *user = [Utilities GetNSUserDefaults];
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    NSDictionary *dic = @{
                          @"type":@"3",
                          @"typeId":_model.id,
                          @"userId":[NSString stringWithFormat:@"%ld",user.id],
                          @"cartoonId":_bookId
                          };
    [manager POST:[ZZTAPI stringByAppendingString:@"great/cartoonPraise"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(self.update){
            self.update();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (likeCountView *)replyCountView {
    
    if (!_replyCountView) {
        
        likeCountView *lcv = [[likeCountView alloc] init];
        
        [self.contentView addSubview:lcv];
        
        [lcv likeCountViewWithImg:CommentIconImg selectImg:CommentIconImg_Select];
        
        _replyCountView = lcv;
        
        [lcv setOnClick:^(likeCountView *btn) {
            [self showCommentVc];
        }];

    }
    return _replyCountView;
}

-(void)showCommentVc{
    if ([_delegate respondsToSelector:@selector(StatusFooterView:didClickCommentButton:)]) {
        [_delegate StatusFooterView:self didClickCommentButton:self.model];
    }
}

-(void)setIsFind:(BOOL)isFind{
    _isFind = isFind;
}


-(void)cellLongPress:(UILongPressGestureRecognizer *)gesture{
    //代理出去
    if(self.LongPressBlock){
        self.LongPressBlock(self.model);
    }
}

@end
