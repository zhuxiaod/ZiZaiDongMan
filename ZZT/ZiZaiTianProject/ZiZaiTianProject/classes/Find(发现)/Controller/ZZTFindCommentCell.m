//
//  ZZTFindCommentCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/29.
//  Copyright © 2018年 zxd. All rights reserved.
//

#define imgHeight  (CGRectGetWidth([UIScreen mainScreen].bounds) - 24 - 24)/3
#define imgRowW  (CGRectGetWidth([UIScreen mainScreen].bounds))
#import "ZZTFindCommentCell.h"
#import "ZZTMyZoneModel.h"
#import "AttentionButton.h"
#import "ZZTMaterialCell.h"
#import "HZPhotoBrowser.h"
#import "replyCountView.h"

@interface ZZTFindCommentCell ()<UIGestureRecognizerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic)  UIButton *headBtn;
@property (strong, nonatomic)  UILabel *userName;
@property (strong, nonatomic)  UIButton *vipLab;
@property (strong, nonatomic)  AttentionButton *attentionBtn;
@property (strong, nonatomic)  UILabel *contentLab;
@property (strong, nonatomic)  UIImageView *contentImg;
@property (strong, nonatomic)  UILabel *dataLab;
@property (strong, nonatomic)  UIView *bottomView;
@property (nonatomic,strong) NSMutableArray * groupImgArr;
@property (nonatomic,strong) NSArray *imgArray;
@property (nonatomic,assign) BOOL isZan;
@property (nonatomic,assign) BOOL isAttention;
@property (nonatomic,strong) NSMutableArray * downImageArray;

//评论
@property (strong, nonatomic) replyCountView *replyCountView;
//点赞
@property (strong, nonatomic) likeCountView *likeCountView;
//图片View
@property (strong, nonatomic) UICollectionView *collectionView;


@end

@implementation ZZTFindCommentCell

-(NSArray *)imgArray{
    if(!_imgArray){
        _imgArray = [NSArray array];
    }
    return _imgArray;
}

-(NSMutableArray *)downImageArray{
    if(!_downImageArray){
        _downImageArray = [NSMutableArray array];
    }
    return _downImageArray;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"findCommentCell";
    //1.判断是否存在可重用cell
    ZZTFindCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        //2.为nib文件注册并指定可重用标识
        [tableView registerNib:[UINib nibWithNibName:@"ZZTFindCommentCell" bundle:nil] forCellReuseIdentifier:ID];
        [tableView registerClass:[ZZTFindCommentCell class] forCellReuseIdentifier:ID];
        //3.重新获取cell
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    //不要选中状态
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //4.返回cell
    return cell;
}

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
    _contentLab = [GlobalUI createLabelFont:MomentFontSize titleColor:[UIColor blackColor] bgColor:[UIColor whiteColor]];
    _contentLab.numberOfLines = 0;
    

    //使用collectionView
    UICollectionViewFlowLayout *layout = [self setupCollectionViewFlowLayout];
    
    [self setupCollectionView:layout];
    
    
    //关注
    _attentionBtn = [[AttentionButton alloc] init];

    //时间
    _dataLab = [GlobalUI createLabelFont:14 titleColor:[UIColor grayColor] bgColor:[UIColor whiteColor]];
    
    //举报
    _reportBtn = [[ZZTReportBtn alloc] init];

    [self.contentView addSubview:_reportBtn];
    
    [self.contentView addSubview:_headBtn];
    [self.contentView addSubview:_userName];
    [self.contentView addSubview:_vipLab];
    [self.contentView addSubview:_attentionBtn];
    [self.contentView addSubview:_contentLab];
    [self.contentView addSubview:_dataLab];

    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor colorWithRGB:@"239,239,239"];
    [self.contentView addSubview:_bottomView];
    
}


#pragma mark - 创建流水布局
-(UICollectionViewFlowLayout *)setupCollectionViewFlowLayout{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //修改尺寸(控制)
    layout.itemSize = CGSizeMake(imgHeight,imgHeight);
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //行距
    layout.minimumLineSpacing = 10;
    
    layout.minimumInteritemSpacing = 10;
    
    return layout;
}

#pragma mark - 创建CollectionView
-(void)setupCollectionView:(UICollectionViewFlowLayout *)layout
{
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZZTMaterialCell" bundle:nil]  forCellWithReuseIdentifier:@"wordImageCell"];

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
    CGFloat space = SafetyW;
    CGFloat distance = 8;
    
    //头像
    [_headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(space);
        make.height.width.mas_equalTo(50);
    }];
    
    [_attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headBtn);
        make.right.equalTo(self.contentView).offset(-space);
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
    }];
    
    NSInteger row = _imgArray.count / 3;// 多少行图片
    if (_imgArray.count %3 !=0) {
        ++row;
    }
    
    //这里是没有数据的
    CGFloat collectionW = SCREEN_WIDTH - 24;
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLab.mas_bottom).offset(space);
        make.width.mas_equalTo(collectionW);
        make.left.equalTo(self.headBtn.mas_left);
    }];
    
    [_dataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headBtn.mas_left);
        make.top.equalTo(self.collectionView.mas_bottom).offset(space);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(100);
    }];
    
    [self.replyCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dataLab);
        make.right.equalTo(self.contentView.mas_right).offset(-8);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(60);
    }];

//    //点赞的地方  添加
//    [self.replyCountView.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.replyCountView.mas_left).offset(2);
//        make.centerY.equalTo(self.dataLab);
////        make.width.mas_equalTo(18);
//    }];
////
//    //点赞的地方  添加
//    [self.replyCountView.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.replyCountView.imageView.mas_right).offset(2);
//        make.centerY.equalTo(self.dataLab);
//        make.height.mas_offset(18);
//    }];
    
    [self.likeCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.replyCountView);
        make.right.equalTo(self.replyCountView.mas_left).offset(-space);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(60);
    }];
    
//    //点赞的地方  添加
//    [self.likeCountView.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.likeCountView.mas_left).offset(2);
//        make.centerY.equalTo(self.replyCountView);
//    }];
//
//    //点赞的地方  添加
//    [self.likeCountView.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.likeCountView.imageView.mas_right).offset(2);
//        make.centerY.equalTo(self.replyCountView);
//        make.height.mas_offset(18);
//    }];
    
    //举报
    [self.reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dataLab);
        make.right.equalTo(self.likeCountView.mas_left).offset(-54);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}

- (void)setModel:(ZZTMyZoneModel *)model{
    _model = model;
    
    //更新时间
    [_dataLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(8);
    }];
    
    _contentLab.text = model.content;
    [_contentLab setFont:[UIFont systemFontOfSize:MomentFontSize]];
    //时间
    _dataLab.text = [NSString compareCurrentTime:model.publishtime];
    
    //更新内容高度
    CGFloat contentHeight = [_contentLab.text heightWithWidth:CGRectGetWidth(self.contentView.bounds) - 32 font:MomentFontSize];
    contentHeight += 10;
    [_contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(contentHeight);
    }];
    
    //获取图片数组
    self.imgArray = [model.contentImg componentsSeparatedByString:@","];
    
    NSInteger row = _imgArray.count / 3;// 多少行图片
    if (_imgArray.count %3 !=0) {
        ++row;
    }
    
    CGFloat bgH = _imgArray.count ? row * imgHeight + (row-1) * 10 :0;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(bgH);
    }];
    
    [self.collectionView reloadData];
  
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
    
    [self.replyCountView setTitle:replayCountText forState:UIControlStateNormal];


    //评论跳转
    [self.replyCountView addTarget:self action:@selector(gotoCommentView) forControlEvents:UIControlEventTouchUpInside];

    //点赞
    self.likeCountView.islike  = [model.ifpraise integerValue];
    self.likeCountView.requestID = model.userId;
    self.likeCountView.likeCount = model.praisecount;


    //关注
    _attentionBtn.hidden = NO;
    _attentionBtn.isAttention = [model.ifConcern integerValue];
    _attentionBtn.requestID = model.userId;
    UserInfo *user = [Utilities GetNSUserDefaults];
    //如果是自己发的 隐藏关注
    if([model.userId isEqualToString:[NSString stringWithFormat:@"%ld",user.id]]){
        _attentionBtn.hidden = YES;
    }
    
    _reportBtn.hidden = NO;
    _reportBtn.zoneModel = model;
    if([Utilities GetNSUserDefaults].id == [self.model.userId integerValue]){
        _reportBtn.hidden = YES;
    }
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
    commentView.ishiddenTitleView = YES;
    [[self myViewController].navigationController presentViewController:nav animated:YES completion:nil];
//    [commentView hiddenTitleView];
}

//时间显示过大了
+ (CGFloat)cellHeightWithStr:(NSString *)str imgs:(NSArray *)imgs{
    //内容高度
    CGFloat strH = [str heightWithWidth:CGRectGetWidth([UIScreen mainScreen].bounds) - 32 font:MomentFontSize];
//    16 + 40+16+strH+16
    CGFloat cellH = strH + 110 + 16 + 8;
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
- (replyCountView *)replyCountView {
    if (!_replyCountView) {
        
        replyCountView *btn = [[replyCountView alloc]init];
        
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        
        [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

        [self.contentView addSubview:btn];

        _replyCountView = btn;
    }
    
    return _replyCountView;
}

- (likeCountView *)likeCountView {
    if (!_likeCountView) {
        
        likeCountView *lcv = [[likeCountView alloc] init];
        
        [lcv setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        
        [lcv setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        
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

-(void)userLikeTarget{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    NSDictionary *dict = @{
                           @"typeId":_model.id,
                           @"userId":[UserInfoManager share].ID,
                           @"type":@"1"
                           };
    [manager POST:[ZZTAPI stringByAppendingString:@"great/praises"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//节
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//行
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imgArray.count;
}

//cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *imgStr = self.imgArray[indexPath.row];
    ZZTMaterialCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"wordImageCell" forIndexPath:indexPath];
    //显示一张图  然后给他一张图
    cell.imageStr = imgStr;
//    cell.selectImageView = self.groupImgArr[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
    
    browser.isFullWidthForLandScape = YES;
    
    browser.isNeedLandscape = YES;
    
    browser.currentImageIndex = [[NSString stringWithFormat:@"%ld",indexPath.row] intValue];
    
    browser.imageArray = self.imgArray;
    
    [browser show];
    
}
@end
