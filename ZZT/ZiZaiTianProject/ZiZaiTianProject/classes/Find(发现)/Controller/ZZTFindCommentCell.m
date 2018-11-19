//
//  ZZTFindCommentCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/29.
//  Copyright © 2018年 zxd. All rights reserved.
//

#define imgHeight  (CGRectGetWidth([UIScreen mainScreen].bounds) - 80)/3

#import "ZZTFindCommentCell.h"
#import <XHImageViewer.h>
#import "ZZTMyZoneModel.h"
#import "AttentionButton.h"

@interface ZZTFindCommentCell ()<UIGestureRecognizerDelegate>

@property (strong, nonatomic)  UIButton *headBtn;
@property (strong, nonatomic)  UILabel *userName;
@property (strong, nonatomic)  UIButton *vipLab;
@property (strong, nonatomic)  AttentionButton *attentionBtn;
@property (strong, nonatomic)  UILabel *contentLab;
@property (strong, nonatomic)  UIImageView *contentImg;
@property (strong, nonatomic)  UILabel *dataLab;
@property (strong, nonatomic)  UIView *bgImgsView;
@property (strong, nonatomic)  UIView *bottomView;
@property (nonatomic,strong) NSMutableArray * groupImgArr;
@property (nonatomic,strong) NSArray *imgArray;
@property (nonatomic,assign) BOOL isZan;
@property (nonatomic,assign) BOOL isAttention;

//评论
@property (strong, nonatomic) UIButton *replyCountView;
//点赞
@property (strong, nonatomic) likeCountView *likeCountView;

@end

@implementation ZZTFindCommentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    //头像
    _headBtn = [[UIButton alloc] init];
    
    [_headBtn.imageView  setContentMode:UIViewContentModeScaleAspectFill];
    
    _headBtn.imageView .clipsToBounds = YES;
    
    [_headBtn addTarget:self action:@selector(clickHead) forControlEvents:UIControlEventTouchUpInside];
    _headBtn.adjustsImageWhenHighlighted = NO;
    
    //用户名
    _userName = [GlobalUI createLabelFont:18 titleColor:ZZTSubColor bgColor:[UIColor clearColor]];
    
    //vip
    _vipLab = [GlobalUI createButtonWithImg:nil title:@"VIP" titleColor:[UIColor whiteColor]];
    [_vipLab setHidden:YES];
    _vipLab.layer.cornerRadius = 2.0f;
    _vipLab.backgroundColor = [UIColor purpleColor];
    
    //内容
    _contentLab = [GlobalUI createLabelFont:14 titleColor:[UIColor blackColor] bgColor:[UIColor whiteColor]];
    _contentLab.numberOfLines = 0;
    
    //图片
    _bgImgsView = [[UIView alloc]init];

    //关注
    _attentionBtn = [[AttentionButton alloc] init];

    //时间
    _dataLab = [GlobalUI createLabelFont:14 titleColor:[UIColor grayColor] bgColor:[UIColor whiteColor]];
    
    [self.contentView addSubview:_headBtn];
    [self.contentView addSubview:_userName];
    [self.contentView addSubview:_vipLab];
    [self.contentView addSubview:_attentionBtn];
    [self.contentView addSubview:_contentLab];
    [self.contentView addSubview:_bgImgsView];
    [self.contentView addSubview:_dataLab];
    
    _groupImgArr = [NSMutableArray array];
    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor colorWithRGB:@"239,239,239"];
    [self.contentView addSubview:_bottomView];
}

-(void)clickHead{
    //跳转页面
    ZZTMyZoneViewController *zoneVC = [[ZZTMyZoneViewController alloc] init];
    //用户id
    zoneVC.userId = _model.userId;
    [[self myViewController].navigationController pushViewController:zoneVC animated:YES];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat space = 8;
    CGFloat distance = 4;
    //头像
    [_headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(space);
        make.height.width.mas_equalTo(40);
    }];
    
    [_attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headBtn);
        make.right.equalTo(self.contentView).offset(-8);
        make.width.height.mas_equalTo(36);
    }];
    
    //用户名   计算出宽度 然后在写vip
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headBtn);
        make.left.equalTo(self.headBtn.mas_right).offset(distance);
        make.height.mas_equalTo(20);
    }];
    
    [_vipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headBtn);
        make.left.equalTo(self.userName.mas_right).offset(distance);
        make.height.width.mas_equalTo(16);
    }];
    
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headBtn.mas_left);
        make.right.equalTo(self.attentionBtn.mas_right);
        make.top.equalTo(self.headBtn.mas_bottom).offset(space);
//        make.height.mas_equalTo(contentHeight);
    }];
    
    NSInteger row = _imgArray.count / 3;// 多少行图片
    if (_imgArray.count %3 !=0) {
        ++row;
    }
    
    //这里是没有数据的
    [_bgImgsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLab.mas_bottom).offset(space);
        make.right.equalTo(self.attentionBtn.mas_right);
        make.left.equalTo(self.headBtn.mas_left);
    }];
    
    [_dataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headBtn.mas_left);
        make.top.equalTo(self.bgImgsView.mas_bottom).offset(space);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(100);
    }];
    
    [self.replyCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.dataLab);
        make.right.equalTo(self.contentView).offset(-8);
        make.height.mas_equalTo(20);
    }];
    
    [self.likeCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.replyCountView);
        make.right.equalTo(self.replyCountView.mas_left).offset(-space);
        make.height.mas_equalTo(20);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}

- (void)setModel:(ZZTMyZoneModel *)model{
    _model = model;
    //重置图片View
    if (_groupImgArr.count) {
        [_groupImgArr enumerateObjectsUsingBlock:^(UIImageView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [_groupImgArr removeAllObjects];
    }
    _imgArray = [model.contentImg componentsSeparatedByString:@","];

    if (_imgArray.count) {
        //拼接字符串
        NSMutableArray *urlArray = [NSMutableArray array];
        for(int i = 0; i < _imgArray.count;i++){
            NSString *imgUrl = [NSString stringWithFormat:@"%@%@",model.qiniu,_imgArray[i]];
            [urlArray addObject:imgUrl];
        }
        _imgArray = urlArray;
        [self setupImageGroupView];
    }
    
    NSInteger row = _imgArray.count / 3;// 多少行图片
    if (_imgArray.count %3 !=0) {
        ++row;
    }
    
    CGFloat bgH = _imgArray.count ? row * imgHeight + (row-1) * 10 :0;
    [_bgImgsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(bgH);
    }];
    
    //更新时间
    [_dataLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImgsView.mas_bottom).offset(8);
    }];
    
    _contentLab.text = model.content;
    //时间
    _dataLab.text = [NSString compareCurrentTime:model.publishtime];
    
    //更新内容高度
    CGFloat contentHeight = [_contentLab.text heightWithWidth:CGRectGetWidth(self.contentView.bounds) - 16 font:14];
    contentHeight += 10;
    [_contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(contentHeight);
    }];

    //先把时间搓换成nstime
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [_headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.headimg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"peien"]];
    //名字位置刷新 vip的位置也刷新
    _userName.text = model.nickName;
    
    CGFloat replyCountWidth = [_userName.text getTextWidthWithFont:self.userName.font];
    replyCountWidth += 30;
    [_userName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(replyCountWidth);
    }];
    
    //评论
    NSString *replayCountText = [NSString makeTextWithCount:model.replycount];
    
    CGFloat replyWidth = 70;

    [self.replyCountView setTitle:replayCountText forState:UIControlStateNormal];

    //设置宽度
    [self.replyCountView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(replyWidth));
    }];
    
    [self.replyCountView.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.replyCountView.mas_top).offset(1);
        make.left.equalTo(self.replyCountView.mas_left).offset(2);
        make.bottom.equalTo(self.replyCountView.mas_bottom).offset(-1);
        make.width.mas_equalTo(18);
    }];
    
    [self.replyCountView.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.replyCountView.imageView.mas_top);
        make.left.equalTo(self.replyCountView.imageView.mas_right).offset(4);
        make.bottom.equalTo(self.replyCountView.mas_bottom);
        make.width.mas_equalTo(replyWidth - 22);
    }];
    
    //评论跳转
    [self.replyCountView addTarget:self action:@selector(gotoCommentView) forControlEvents:UIControlEventTouchUpInside];

    //点赞
    self.likeCountView.islike  = [model.ifpraise integerValue];
    self.likeCountView.requestID = model.userId;
    self.likeCountView.likeCount = model.praisecount;
//    self.likeCountView.likeCount = 10000;

    [self.likeCountView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(replyWidth);
    }];
    
    [self.likeCountView.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.likeCountView.mas_top).offset(1);
        make.left.equalTo(self.likeCountView.mas_left).offset(2);
        make.bottom.equalTo(self.likeCountView.mas_bottom).offset(-1);
        make.width.mas_equalTo(18);
    }];
    
    [self.likeCountView.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.likeCountView.imageView.mas_top);
        make.left.equalTo(self.likeCountView.imageView.mas_right).offset(4);
        make.bottom.equalTo(self.likeCountView.mas_bottom);
        make.width.mas_equalTo(replyWidth - 22);
    }];
    
    
  
    
    //关注
    _attentionBtn.isAttention = [model.ifConcern integerValue];
    _attentionBtn.requestID = model.userId;
}

-(void)gotoCommentView{
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    ZZTCommentViewController *commentView = [[ZZTCommentViewController alloc] init];
    commentView.isFind = YES;
    commentView.chapterId = _model.id;
    commentView.cartoonType = @"3";
    [[self myViewController].navigationController presentViewController:commentView animated:YES completion:nil];
    [commentView hiddenTitleView];
}

- (void)setupImageGroupView{
    CGFloat w = imgHeight;
    CGFloat h = imgHeight;
    
    CGFloat edge = 10;
    for (int i = 0; i<_imgArray.count; i++) {
        
        int row = i / 3;
        int loc = i % 3;
        
        CGFloat x = (edge + w) * loc ;
        CGFloat y = (edge + h) * row;
        
        UIImageView * img =[[UIImageView alloc]init];
        
        [img setContentMode:UIViewContentModeScaleAspectFill];
        
        img.clipsToBounds = YES;
        
        [img sd_setImageWithURL:[NSURL URLWithString:_imgArray[i]]];
        //        img.image = [UIImage imageNamed:_imgArray[i]];
//        img.backgroundColor = [UIColor greenColor];
        img.frame = CGRectMake(x, y, w, h);
        
        img.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(browerImage:)];
        
        [img addGestureRecognizer:tap];
        
        [_bgImgsView addSubview:img];
        
        [_groupImgArr addObject:img];
    }
}

#pragma mark - brower image
- (void)browerImage:(UITapGestureRecognizer *)gest{
    UIImageView *tapView = (UIImageView *)gest.view;
    XHImageViewer *brower  = [[XHImageViewer alloc]init];
    [brower showWithImageViews:_groupImgArr selectedView:tapView];
}

//时间显示过大了
+ (CGFloat)cellHeightWithStr:(NSString *)str imgs:(NSArray *)imgs{
    CGFloat strH = [str heightWithWidth:CGRectGetWidth([UIScreen mainScreen].bounds) - 40 font:14];
    CGFloat cellH = strH + 110;
    NSInteger row = imgs.count / 3;
    if (imgs.count) {
        if (imgs.count % 3 !=0) {
            row += 1;
        }
        cellH +=  row * imgHeight  + (row-1) * 10; // 图片高度 + 间隙
    }
    return  cellH;
}

//评论
- (UIButton *)replyCountView {
    if (!_replyCountView) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [btn setTitleColor:[self.likeCountView titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"wordDetail_comment"] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(showCommentVc) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
        _replyCountView = btn;
    }
    
    return _replyCountView;
}

- (likeCountView *)likeCountView {
    if (!_likeCountView) {
        likeCountView *lcv = [[likeCountView alloc] init];
        
        weakself(self);
        //发现点赞
        [lcv setOnClick:^(likeCountView *btn) {
            //用户点赞
            [self userLikeTarget];
        }];
        
        [self.contentView addSubview:lcv];
        
        _likeCountView = lcv;
    }
    return _likeCountView;
}

////显示评论页
//-(void)showCommentVc{
//    if([[UserInfoManager share] hasLogin] == NO){
//        [UserInfoManager needLogin];
//        return;
//    }
//    ZZTCommentViewController *commentVC = [[ZZTCommentViewController alloc] init];
//    commentVC.chapterId = @"1";
//    commentVC.cartoonType = @"2";
//    [[self myViewController].navigationController presentViewController:commentVC animated:YES completion:nil];
//    [commentVC hiddenTitleView];
//}

-(void)userLikeTarget{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    NSDictionary *dict = @{
                           @"typeId":_model.id,
                           @"userId":[UserInfoManager share].ID
                           };
    [manager POST:[ZZTAPI stringByAppendingString:@"great/praises"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
@end
