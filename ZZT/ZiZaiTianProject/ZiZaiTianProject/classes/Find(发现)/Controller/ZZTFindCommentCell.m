//
//  ZZTFindCommentCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/29.
//  Copyright © 2018年 zxd. All rights reserved.
//

#define imgHeight  (CGRectGetWidth([UIScreen mainScreen].bounds) - 80)/3

#import "ZZTFindCommentCell.h"
//#import <XHImageViewer.h>
#import "ZZTMyZoneModel.h"
#import "AttentionButton.h"
#import "ZZTMaterialCell.h"
#import "XHImageViewer.h"
#import "HZPhotoBrowser.h"

@interface ZZTFindCommentCell ()<UIGestureRecognizerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,XHImageViewerDelegate>

@property (strong, nonatomic)  UIButton *headBtn;
@property (strong, nonatomic)  UILabel *userName;
@property (strong, nonatomic)  UIButton *vipLab;
@property (strong, nonatomic)  AttentionButton *attentionBtn;
@property (strong, nonatomic)  UILabel *contentLab;
@property (strong, nonatomic)  UIImageView *contentImg;
@property (strong, nonatomic)  UILabel *dataLab;
//@property (strong, nonatomic)  UIView *bgImgsView;
@property (strong, nonatomic)  UIView *bottomView;
@property (nonatomic,strong) NSMutableArray * groupImgArr;
@property (nonatomic,strong) NSArray *imgArray;
@property (nonatomic,assign) BOOL isZan;
@property (nonatomic,assign) BOOL isAttention;
@property (nonatomic,strong) NSMutableArray * downImageArray;

//评论
@property (strong, nonatomic) UIButton *replyCountView;
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

//-(NSMutableArray *)groupImgArr{
//    if(!_groupImgArr){
//        _groupImgArr = [NSMutableArray array];
//        for (int i = 0; i < self.imgArray.count; i++) {
//            UIImageView * img = [[UIImageView alloc]init];
//
//            [img setContentMode:UIViewContentModeScaleAspectFill];
//
//            img.clipsToBounds = YES;
//
//            [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.cdn.zztian.cn/%@",_imgArray[i]]] placeholderImage:[UIImage createImageWithColor:[UIColor whiteColor]] options:0];
//
////            img.userInteractionEnabled = YES;
//
////            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(browerImage:)];
////
////            [img addGestureRecognizer:tap];
//
//            [self.groupImgArr addObject:img];
//        }
//    }
//    return _groupImgArr;
//}

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
    _contentLab = [GlobalUI createLabelFont:14 titleColor:[UIColor blackColor] bgColor:[UIColor whiteColor]];
    _contentLab.numberOfLines = 0;
    
    
    //图片
//    _bgImgsView = [[UIView alloc]init];

    //使用collectionView
    UICollectionViewFlowLayout *layout = [self setupCollectionViewFlowLayout];
    
    [self setupCollectionView:layout];
    
    
    //关注
    _attentionBtn = [[AttentionButton alloc] init];

    //时间
    _dataLab = [GlobalUI createLabelFont:14 titleColor:[UIColor grayColor] bgColor:[UIColor whiteColor]];
    
    [self.contentView addSubview:_headBtn];
    [self.contentView addSubview:_userName];
    [self.contentView addSubview:_vipLab];
    [self.contentView addSubview:_attentionBtn];
    [self.contentView addSubview:_contentLab];
//    [self.contentView addSubview:_bgImgsView];
    [self.contentView addSubview:_dataLab];
    
//    self.groupImgArr = [NSMutableArray array];
    
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
//    [collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 30)];
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
    CGFloat space = 8;
    CGFloat distance = 4;
    //头像
    [_headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(space);
        make.height.width.mas_equalTo(40);
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
//        make.height.mas_equalTo(contentHeight);
        
//        make.height.mas_equalTo(0);
    }];
    
    NSInteger row = _imgArray.count / 3;// 多少行图片
    if (_imgArray.count %3 !=0) {
        ++row;
    }
    
    //这里是没有数据的
    CGFloat collectionW = imgHeight * 3 + 20;
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLab.mas_bottom).offset(space);
//        make.right.equalTo(self.attentionBtn.mas_right);
        make.width.mas_equalTo(collectionW);
        make.left.equalTo(self.headBtn.mas_left);
//        make.height.mas_equalTo(1);
    }];
    
    [_dataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headBtn.mas_left);
        make.top.equalTo(self.collectionView.mas_bottom).offset(space);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(100);
    }];
    
    [self.replyCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.dataLab);
        make.right.equalTo(self.contentView.mas_right).offset(-8);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(70);
    }];
    
//    [self.replyCountView.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.replyCountView.mas_top).offset(1);
//        make.left.equalTo(self.replyCountView.mas_left).offset(2);
//        make.bottom.equalTo(self.replyCountView.mas_bottom).offset(-1);
//        make.width.mas_equalTo(18);
//    }];
//
//    self.replyCountView.imageView.contentMode = UIViewContentModeCenter;
//
//    [self.replyCountView.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.replyCountView.imageView.mas_top);
//        make.left.equalTo(self.replyCountView.imageView.mas_right).offset(4);
//        make.bottom.equalTo(self.replyCountView.mas_bottom);
//        make.width.mas_equalTo(70 - 22);
//    }];
    
    
    
    
    [self.likeCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.replyCountView);
        make.right.equalTo(self.replyCountView.mas_left).offset(-space);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(70);
    }];
    
//    [self.likeCountView.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.likeCountView.mas_top).offset(0);
//        make.left.equalTo(self.likeCountView.mas_left).offset(2);
//        make.bottom.equalTo(self.likeCountView.mas_bottom).offset(0);
//        make.width.mas_equalTo(18);
//    }];
//    
//    self.likeCountView.imageView.contentMode = UIViewContentModeCenter;
//    
//    [self.likeCountView.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.likeCountView.imageView.mas_top);
//        make.left.equalTo(self.likeCountView.imageView.mas_right).offset(4);
//        make.bottom.equalTo(self.likeCountView.mas_bottom);
//        make.width.mas_equalTo(70 - 22);
//    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}

- (void)setModel:(ZZTMyZoneModel *)model{
    _model = model;

//    // 处理耗时操作的代码块...
//    for (int i = 0; i < self.imgArray.count; i++) {
//
//        UIImageView * img = [[UIImageView alloc]init];
//
//        [img setContentMode:UIViewContentModeScaleAspectFill];
//
//        img.clipsToBounds = YES;
//
//        [img sd_setImageWithURL:[NSURL URLWithString:_imgArray[i]] placeholderImage:[UIImage createImageWithColor:[UIColor whiteColor]] options:0];
//
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(browerImage:)];
//
//        [img addGestureRecognizer:tap];
//
//        [self.groupImgArr addObject:img];
//    }
    
    
    //更新时间
    [_dataLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(8);
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
    
    // 处理耗时操作的代码块...
    self.groupImgArr = [NSMutableArray array];
    for (int i = 0; i < self.imgArray.count; i++) {
        UIImageView * img = [[UIImageView alloc]init];
        
        [img setContentMode:UIViewContentModeScaleAspectFill];
        
        img.clipsToBounds = YES;
        
        [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.cdn.zztian.cn/%@",self.imgArray[i]]] placeholderImage:[UIImage createImageWithColor:[UIColor whiteColor]] options:0];
        
        [self.groupImgArr addObject:img];
    }
  
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

//    //设置宽度
//    [self.replyCountView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@(replyWidth));
//    }];
    
   
    
    //评论跳转
    [self.replyCountView addTarget:self action:@selector(gotoCommentView) forControlEvents:UIControlEventTouchUpInside];

    //点赞
    self.likeCountView.islike  = [model.ifpraise integerValue];
    self.likeCountView.requestID = model.userId;
    self.likeCountView.likeCount = model.praisecount;
//    self.likeCountView.likeCount = 10000;

   

    //关注
    _attentionBtn.isAttention = [model.ifConcern integerValue];
    _attentionBtn.requestID = model.userId;
    UserInfo *user = [Utilities GetNSUserDefaults];
    //如果是自己发的 隐藏关注
    if([model.userId isEqualToString:[NSString stringWithFormat:@"%ld",user.id]]){
        _attentionBtn.hidden = YES;
    }
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
        
//        [img sd_setImageWithURL:[NSURL URLWithString:_imgArray[i]]];
        
        [img sd_setImageWithURL:[NSURL URLWithString:_imgArray[i]] placeholderImage:[UIImage createImageWithColor:[UIColor whiteColor]] options:0];
        
        //        img.image = [UIImage imageNamed:_imgArray[i]];
//        img.backgroundColor = [UIColor greenColor];
        img.frame = CGRectMake(x, y, w, h);
        
        img.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(browerImage:)];
        
        [img addGestureRecognizer:tap];
        
//        [_bgImgsView addSubview:img];
        
        [_groupImgArr addObject:img];
    }
}

//#pragma mark - brower image
- (void)browerImage:(UITapGestureRecognizer *)gest{
//    UIImageView *tapView = (UIImageView *)gest.view;
//    XHImageViewer *brower  = [[XHImageViewer alloc]init];
//    [brower showWithImageViews:self.groupImgArr selectedView:tapView];
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
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [btn setTitleColor:[self.likeCountView titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"wordDetail_comment"] forState:UIControlStateNormal];
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
//    NSString *imgStr = self.imgArray[indexPath.row];
    ZZTMaterialCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"wordImageCell" forIndexPath:indexPath];
    //显示一张图  然后给他一张图
//    cell.imageStr = imgStr;
    cell.selectImageView = self.groupImgArr[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
    browser.isFullWidthForLandScape = YES;
    browser.isNeedLandscape = YES;
    
    browser.currentImageIndex = [[NSString stringWithFormat:@"%ld",indexPath.row] intValue];
    browser.imageArray = self.imgArray;
    
    [browser show];
    
    
//    ZZTMaterialCell *cell = (ZZTMaterialCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    NSLog(@"indexPath:%ld",indexPath.row);
//    UIImageView *tapView = (UIImageView *)cell.selectImageView;
//    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
////    imageViewer.delegate = self;
//    imageViewer.disableTouchDismiss = NO;
//
////    XHImageViewer *brower  = [[XHImageViewer alloc]init];
////    _imageViewer.disableTouchDismiss = NO;
////    [self layoutIfNeeded];
//    [imageViewer showWithImageViews:self.groupImgArr selectedView:tapView];
}
@end
