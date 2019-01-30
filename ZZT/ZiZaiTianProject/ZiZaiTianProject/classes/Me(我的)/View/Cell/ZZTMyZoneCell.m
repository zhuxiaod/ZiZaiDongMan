//
//  ZZTMyZoneCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 zxd. All rights reserved.
//



#import "ZZTMyZoneCell.h"
#import "ZZTMyZoneModel.h"
#import "HZPhotoBrowser.h"
#import "ZZTCommentImgView.h"

@interface ZZTMyZoneCell ()

@property (nonatomic,strong) UILabel *dateLab;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) ZZTCommentImgView  *bgImgsView; // 9张图片bgView
@property (nonatomic,strong) NSMutableArray * groupImgArr;
@property (nonatomic,strong) NSArray *imgArray;
@property (nonatomic,strong) UIView *bottomView;

//评论
@property (strong, nonatomic) UIButton *replyCountView;
//点赞
@property (strong, nonatomic) likeCountView *likeCountView;

@property (assign, nonatomic) CGFloat bgH;

@end

@implementation ZZTMyZoneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    //时间lab
    _dateLab = [GlobalUI createLabelFont:14 titleColor:[UIColor blackColor] bgColor:[UIColor whiteColor]];
    
    //内容lab
    _contentLab = [GlobalUI createLabelFont:MomentFontSize titleColor:[UIColor blackColor] bgColor:[UIColor whiteColor]];
    _contentLab.numberOfLines = 0;
    
    //多图
    _bgImgsView = [[ZZTCommentImgView alloc] init];
    
    [self.contentView addSubview:_dateLab];
    [self.contentView addSubview:_contentLab];
    [self.contentView addSubview:_bgImgsView];
    
    _groupImgArr = [NSMutableArray array];
    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor colorWithRGB:@"239,239,239"];
    [self.contentView addSubview:_bottomView];
    
    //举报
    _reportBtn = [[ZZTReportBtn alloc] init];
    [self.contentView addSubview:_reportBtn];
    
    self.bgH = 0.0f;
    
    UILongPressGestureRecognizer *tapGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(delMomment)];
    [self addGestureRecognizer:tapGesture];
}

-(void)delMomment{
    //显示删除UI
    //点击删除时  删除
    if(self.LongPressBlock){
        self.LongPressBlock(self.model);
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [_dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(SafetyW);
        make.left.equalTo(self.contentView).offset(SafetyW);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLab.mas_bottom).offset(SafetyW);
        make.left.equalTo(self.contentView).offset(SafetyW);
        make.right.equalTo(self.contentView).offset(-SafetyW);
    }];
    
    [_bgImgsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLab.mas_bottom).offset(SafetyW);
        make.left.equalTo(self.contentLab.mas_left);
        make.right.equalTo(self.contentLab.mas_right);
    }];
    
    [self.replyCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentLab.mas_right);
        make.width.mas_equalTo(60);
        make.top.equalTo(self.bgImgsView.mas_bottom).offset(SafetyW);
        make.height.mas_equalTo(20);
    }];
    
    //点赞的地方  添加
    [self.replyCountView.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.replyCountView.mas_left).offset(2);
        make.centerY.equalTo(self.replyCountView);
    }];

    //点赞的地方  添加
    [self.replyCountView.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.replyCountView.imageView.mas_right).offset(2);
        make.centerY.equalTo(self.replyCountView);
        make.height.mas_offset(18);
        make.right.equalTo(self.replyCountView.mas_right);
    }];
    
    [self.likeCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.replyCountView);
        make.right.equalTo(self.replyCountView.mas_left).offset(-8);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];

    //举报
    [self.reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.replyCountView);
        make.right.equalTo(self.likeCountView.mas_left).offset(-54);
        make.height.mas_equalTo(20);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}


- (void)setModel:(ZZTMyZoneModel *)model{
    _model = model;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    _contentLab.text = model.content;
    
    //更新内容高度
    CGFloat contentHeight = 0.0f;
    
    [_contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLab.mas_bottom).offset(SafetyW);
        make.left.equalTo(self.contentView).offset(SafetyW);
        make.right.equalTo(self.contentView).offset(-SafetyW);
    }];
    
    if([model.content isEqualToString:@""]){
        contentHeight = 0;
        [_contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dateLab.mas_bottom);
        }];
    }else{
       contentHeight = [_contentLab.text heightWithWidth:CGRectGetWidth(self.contentView.bounds) - 24 font:MomentFontSize];
        contentHeight += 10;
    }
    
    [_contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(contentHeight);
    }];
    
    //图片
    _bgImgsView.model = model;

    _imgArray = [model.contentImg componentsSeparatedByString:@","];
    
    CGFloat bgH = [_bgImgsView getIMGHeight:_imgArray.count];
    
    [self.bgImgsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(bgH);
    }];
    
    //时间戳显示
    NSString *time = [NSString timeWithStr:[NSString stringWithFormat:@"%@",model.publishtime]];
    
    NSArray *times = [time componentsSeparatedByString:@"-"];
    time = [NSString stringWithFormat:@"%@%@月",times[2],times[1]];
    
    _dateLab.attributedText = [self getPriceAttribute:time];;
    
    //评论
    NSString *replayCountText = [NSString makeTextWithCount:model.replycount];
    
    [self.replyCountView setTitle:replayCountText forState:UIControlStateNormal];
    
    //设置赞
    self.likeCountView.islike  = [model.ifpraise integerValue];
    self.likeCountView.requestID = model.userId;
    self.likeCountView.likeCount = model.praisecount;
    
    _reportBtn.hidden = NO;
    _reportBtn.zoneModel = model;
    if([Utilities GetNSUserDefaults].id == [self.model.userId integerValue]){
        _reportBtn.hidden = YES;
    }
    
}

//年月混排
-(NSMutableAttributedString *)getPriceAttribute:(NSString *)string{
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:string];
    //目的是想改变 ‘/’前面的字体的属性，所以找到目标的range
    NSRange pointRange = NSMakeRange(0, 2);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:30];
    dic[NSKernAttributeName] = @2;
    //赋值
    [attribut addAttributes:dic range:pointRange];
    return attribut;
}

- (likeCountView *)likeCountView {
    if (!_likeCountView) {
        likeCountView *lcv = [[likeCountView alloc] init];
        
        [lcv setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        
        [lcv setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        
        weakself(self);
        //发现点赞
        [lcv setOnClick:^(likeCountView *btn) {
            [self findLikeTarget];
        }];
        
        [self.contentView addSubview:lcv];
        
        _likeCountView = lcv;
    }
    return _likeCountView;
}

//发现点赞
-(void)findLikeTarget{
    UserInfo *user = [Utilities GetNSUserDefaults];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    NSDictionary *dic = @{
                          @"type":@"1",//外面1 里面2
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

//评论
- (UIButton *)replyCountView {
    if (!_replyCountView) {
        
        UIButton *btn = [[UIButton alloc] init];
        
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;

        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];

        [btn setTitleColor:[self.likeCountView titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
        
        [btn setTitle:@"0" forState:UIControlStateNormal];

        [btn setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(gotoCommentView) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:btn];
        
        _replyCountView = btn;
    }
    return _replyCountView;
}

-(void)gotoCommentView{
    
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    
    ZZTCommentViewController *commentView = [[ZZTCommentViewController alloc] init];
//    [commentView hiddenTitleView];
    ZZTNavigationViewController *nav = [[ZZTNavigationViewController alloc] initWithRootViewController:commentView];
    commentView.isFind = YES;
    commentView.chapterId = _model.id;
    commentView.cartoonType = @"3";
//    commentView.ishiddenTitleView = YES;
    commentView.hiddenTitleView = YES;
    commentView.ishiddenTitleView = YES;
    [[self myViewController].navigationController presentViewController:nav animated:YES completion:nil];
    
}

-(void)setIndexRow:(NSInteger)indexRow{
    _indexRow = indexRow;
}
@end
