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
        make.left.equalTo(self.contentView).offset(70);
    }];
    
    [self.replyCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-4);
        make.centerY.equalTo(self.timeLabel);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    //点赞的地方  添加
    [self.replyCountView.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.replyCountView.mas_left).offset(2);
        make.centerY.equalTo(self);
    }];

    //点赞的地方  添加
    [self.replyCountView.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.replyCountView.imageView.mas_right).offset(2);
        make.centerY.equalTo(self);
        make.height.mas_offset(18);
        make.right.equalTo(self.replyCountView.mas_right);
    }];
    
    
    [self.likeCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLabel);
        make.right.equalTo(self.replyCountView.mas_left).offset(-8);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    //举报
    _reportBtn = [[ZZTReportBtn alloc] init];
    [self.contentView addSubview:_reportBtn];
    //如果是自己就隐藏

    //举报
    [self.reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.likeCountView);
        make.right.equalTo(self.likeCountView.mas_left).offset(-64);
        make.height.mas_equalTo(20);
    }];
}

-(void)setModel:(ZZTCircleModel *)model{
    _model = model;
    self.timeLabel.text = model.commentDate;

    //点赞的数量
    self.likeCountView.islike = [model.ifPraise integerValue];

    self.likeCountView.requestID = @"20";
    
    self.likeCountView.likeCount = model.praiseNum;

    //回复评论数量
    NSString *replayCountText = [NSString makeTextWithCount:model.replyComment.count];
    //回复数据
    [self.replyCountView setTitle:replayCountText forState:UIControlStateNormal];
//    //评论宽度
//    CGFloat replyCountWidth = [replayCountText getTextWidthWithFont:self.replyCountView.titleLabel.font] + 30;
//    //设置宽度
//    [self.replyCountView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@(replyCountWidth));
//    }];
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
        
        [lcv setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
      
        [lcv setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
        
        weakself(self);
        
        [lcv setOnClick:^(likeCountView *btn) {
            if(self.isFind == YES){
                [weakSelf findLikeTarget];
            }else{
                [weakSelf likeTarget];
            }
        }];
        
        [self.contentView addSubview:lcv];
        
        _likeCountView = lcv;
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

- (UIButton *)replyCountView {
    if (!_replyCountView) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:@"" forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [btn setTitleColor:ZZTSubColor forState:UIControlStateNormal];
        [btn setImage:[[UIImage imageNamed:@"commentImg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [btn addTarget:self action:@selector(showCommentVc) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
        _replyCountView = btn;
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
