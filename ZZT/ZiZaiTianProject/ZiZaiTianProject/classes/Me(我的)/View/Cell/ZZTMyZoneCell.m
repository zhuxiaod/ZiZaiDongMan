//
//  ZZTMyZoneCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 zxd. All rights reserved.
//
#define imgHeight  (CGRectGetWidth([UIScreen mainScreen].bounds) - 80)/3

#import "ZZTMyZoneCell.h"
#import "ZZTMyZoneModel.h"
#import "HZPhotoBrowser.h"

@interface ZZTMyZoneCell ()

@property (nonatomic,strong) UILabel *dateLab;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UIView  *bgImgsView; // 9张图片bgView
@property (nonatomic,strong) NSMutableArray * groupImgArr;
@property (nonatomic,strong) NSArray *imgArray;
@property (nonatomic,strong) UIView *bottomView;

//评论
@property (strong, nonatomic) UIButton *replyCountView;
//点赞
@property (strong, nonatomic) likeCountView *likeCountView;
//举报
@property (strong, nonatomic) UIButton *reportBtn;

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
    _contentLab = [GlobalUI createLabelFont:14 titleColor:[UIColor blackColor] bgColor:[UIColor whiteColor]];
    _contentLab.numberOfLines = 0;
    
    //多图
    _bgImgsView = [[UIView alloc]init];
    
    [self.contentView addSubview:_dateLab];
    [self.contentView addSubview:_contentLab];
    [self.contentView addSubview:_bgImgsView];
    
    _groupImgArr = [NSMutableArray array];
    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor colorWithRGB:@"239,239,239"];
    [self.contentView addSubview:_bottomView];
    
//    //长按手势
//    UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
//
//    longPressGesture.minimumPressDuration=1.0f;//设置长按 时间
//    [self addGestureRecognizer:longPressGesture];
    
    //举报
    _reportBtn = [[UIButton alloc] init];
    [_reportBtn setImage:[[UIImage imageNamed:@"commentReport"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_reportBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [_reportBtn addTarget:self action:@selector(cellLongPress:) forControlEvents:UIControlEventTouchUpInside];
    [_reportBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.contentView addSubview:_reportBtn];
}

-(void)cellLongPress:(UILongPressGestureRecognizer *)gesture{
    //代理出去
    if(![[NSString stringWithFormat:@"%ld",[Utilities GetNSUserDefaults].id] isEqualToString:self.model.userId]){
        if(self.LongPressBlock){
            self.LongPressBlock(self.model);
        }
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    _dateLab.frame = CGRectMake(10, 10, 100, 50);
    
    [_dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.contentView).offset(8);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLab.mas_bottom).offset(8);
        make.left.equalTo(self.contentView).offset(8);
        make.right.equalTo(self.contentView).offset(-8);
    }];
    
    [_bgImgsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLab.mas_bottom).offset(8);
        make.left.equalTo(self.contentLab.mas_left);
        make.right.equalTo(self.contentLab.mas_right);
    }];
    
    [self.replyCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentLab.mas_right);
        make.width.mas_equalTo(70);
        make.top.equalTo(self.bgImgsView.mas_bottom).offset(8);
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
    }];
    
    [self.likeCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.replyCountView);
        make.right.equalTo(self.replyCountView.mas_left).offset(-8);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(20);
    }];

    //举报
    [self.reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.replyCountView);
        make.right.equalTo(self.likeCountView.mas_left).offset(-64);
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
    CGFloat contentHeight = [_contentLab.text heightWithWidth:CGRectGetWidth(self.contentView.bounds) - 16 font:14];
    contentHeight += 10;
    [_contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(contentHeight);
    }];
    
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
            NSString *imgUrl = [NSString stringWithFormat:@"%@",_imgArray[i]];
            [urlArray addObject:imgUrl];
        }
        _imgArray = urlArray;
        [self setupImageGroupView];
    }

    //计算图片的高度
    NSInteger row = _imgArray.count / 3;// 多少行图片
    
    if (_imgArray.count %3 !=0) {
        ++row;
    }
    
    //更新图片View的高度
    CGFloat bgH = _imgArray.count ? row * imgHeight + (row-1) * 10 :0;
    
    [_bgImgsView mas_updateConstraints:^(MASConstraintMaker *make) {
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
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.layer.masksToBounds = YES;
        img.tag = i;
        [img sd_setImageWithURL:[NSURL URLWithString:_imgArray[i]] placeholderImage:[UIImage imageNamed:@"worldPlaceV"] options:0];
        img.backgroundColor = [UIColor whiteColor];
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
    
    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
    browser.isFullWidthForLandScape = YES;
    browser.isNeedLandscape = YES;
    
    browser.currentImageIndex = [[NSString stringWithFormat:@"%ld",gest.view.tag] intValue];
    browser.imageArray = self.imgArray;
    
    [browser show];
    
}

//高度有问题
//时间显示过大了
+ (CGFloat)cellHeightWithStr:(NSString *)str imgs:(NSArray *)imgs{
    CGFloat strH = [str heightWithWidth:CGRectGetWidth([UIScreen mainScreen].bounds) - 40 font:14];
    CGFloat cellH = strH + 120;
    NSInteger row = imgs.count / 3;
    if (imgs.count) {
        if ( imgs.count % 3 !=0) {
            row += 1;
        }
        cellH +=  row * imgHeight  + (row-1) * 10; // 图片高度 + 间隙
    }
    return  cellH;
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
    ZZTNavigationViewController *nav = [[ZZTNavigationViewController alloc] initWithRootViewController:commentView];
    commentView.isFind = YES;
    commentView.chapterId = _model.id;
    commentView.cartoonType = @"3";
    [[self myViewController].navigationController presentViewController:nav animated:YES completion:nil];
    [commentView hiddenTitleView];
}
@end
