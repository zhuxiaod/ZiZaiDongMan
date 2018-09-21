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

@interface ZZTFindCommentCell ()

@property (strong, nonatomic)  UIImageView *headBtn;
@property (strong, nonatomic)  UILabel *userName;
@property (strong, nonatomic)  UIButton *vipLab;
@property (strong, nonatomic)  UIButton *attentionBtn;
@property (strong, nonatomic)  UILabel *contentLab;
@property (strong, nonatomic)  UIImageView *contentImg;
@property (strong, nonatomic)  UIImageView *zanImg;
@property (strong, nonatomic)  UIImageView *commentImg;
@property (strong, nonatomic)  UILabel *dataLab;
@property (strong, nonatomic)  UILabel *likeNum;
@property (strong, nonatomic)  UILabel *commentNum;
@property (strong, nonatomic)  UIView *bgImgsView;
@property (strong, nonatomic)  UIView *bottomView;
@property (nonatomic,strong) NSMutableArray * groupImgArr;
@property (nonatomic,strong) NSArray *imgArray;
@property (nonatomic,assign) BOOL isZan;

@end

@implementation ZZTFindCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    //头像
    _headBtn = [GlobalUI createImageViewbgColor:[UIColor grayColor]];
    //用户名
    _userName = [GlobalUI createLabelFont:18 titleColor:[UIColor purpleColor] bgColor:[UIColor clearColor]];
    //vip
    _vipLab = [GlobalUI createButtonWithImg:nil title:@"VIP" titleColor:[UIColor whiteColor]];
    _vipLab.layer.cornerRadius = 2.0f;
    _vipLab.backgroundColor = [UIColor purpleColor];
    //关注
    _attentionBtn = [GlobalUI createButtonWithImg:nil title:@"+关注" titleColor:[UIColor whiteColor]];
    _attentionBtn.backgroundColor = [UIColor purpleColor];
    //内容
    _contentLab = [GlobalUI createLabelFont:14 titleColor:[UIColor blackColor] bgColor:[UIColor whiteColor]];

    //图片
    _bgImgsView = [[UIView alloc]init];

    //时间
    _dataLab = [GlobalUI createLabelFont:14 titleColor:[UIColor grayColor] bgColor:[UIColor whiteColor]];

    //点赞
    _zanImg = [GlobalUI createImageViewbgColor:[UIColor whiteColor]];
    _zanImg.image = [UIImage imageNamed:@"zan_icon"];
    _zanImg.userInteractionEnabled = YES;
    //注意测
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapZanBtn)];
    [_zanImg  addGestureRecognizer:tap];
    _likeNum = [GlobalUI createLabelFont:14 titleColor:[UIColor blackColor] bgColor:[UIColor whiteColor]];
    [_likeNum  addGestureRecognizer:tap];
    //评论
    _commentImg = [GlobalUI createImageViewbgColor:[UIColor whiteColor]];
    _commentImg.image = [UIImage imageNamed:@"zan_icon"];
    _commentImg.userInteractionEnabled = YES;
    _commentNum = [GlobalUI createLabelFont:14 titleColor:[UIColor blackColor] bgColor:[UIColor whiteColor]];
    [self.contentView addSubview:_headBtn];
    [self.contentView addSubview:_userName];
    [self.contentView addSubview:_vipLab];
    [self.contentView addSubview:_attentionBtn];
    [self.contentView addSubview:_contentLab];
    [self.contentView addSubview:_bgImgsView];
    [self.contentView addSubview:_dataLab];
    [self.contentView addSubview:_zanImg];
    [self.contentView addSubview:_likeNum];
    [self.contentView addSubview:_commentImg];
    [self.contentView addSubview:_commentNum];
    _groupImgArr = [NSMutableArray array];
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_bottomView];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _headBtn.frame = CGRectMake(10, 10, 40, 40);
    _attentionBtn.frame = CGRectMake(SCREEN_WIDTH - 70, _userName.center.y-15, 60, 30);
    _attentionBtn.layer.cornerRadius = 10.0f;
    CGFloat contentHeight = [_contentLab.text heightWithWidth:CGRectGetWidth(self.contentView.bounds) - 40 font:14];
    _contentLab.frame = CGRectMake(10, CGRectGetMaxY(_headBtn.frame) + 10, CGRectGetWidth(self.contentView.bounds) - 20, contentHeight);
    NSInteger row = _imgArray.count / 3;// 多少行图片
    //还有多的 就最加一行  未做  9个以上的话加号
    if (_imgArray.count %3 !=0) {
        ++row;
    }
    CGFloat bgH = _imgArray.count ? row * imgHeight + (row-1) * 10 :0;
    _bgImgsView.frame = CGRectMake(10, CGRectGetMaxY(_contentLab.frame) + 10, CGRectGetWidth([UIScreen mainScreen].bounds) - 20, bgH);
    _dataLab.frame = CGRectMake(10, CGRectGetMaxY(_bgImgsView.frame)+10, 100, 20);
    
    _commentNum.frame = CGRectMake(SCREEN_WIDTH - 60, CGRectGetMaxY(_bgImgsView.frame)+10 , 50, 20);
    _commentImg.frame = CGRectMake(SCREEN_WIDTH - 85, CGRectGetMaxY(_bgImgsView.frame)+10, 20, 20);
    _likeNum.frame = CGRectMake(SCREEN_WIDTH - 140, CGRectGetMaxY(_bgImgsView.frame)+10 , 50, 20);
    _zanImg.frame = CGRectMake(SCREEN_WIDTH - 165, CGRectGetMaxY(_bgImgsView.frame)+10, 20, 20);
    _bottomView.frame = CGRectMake(0, self.height - 1, SCREEN_WIDTH, 1);
}

- (void)setModel:(ZZTMyZoneModel *)model{
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

    _contentLab.text = model.content;

    //时间戳显示
//    NSString *time = [NSString timeWithStr:[NSString stringWithFormat:@"%f",model.publishtime]];
//    [NSDate ];
#warning 这里有问题
    _dataLab.text = [NSString compareCurrentTime:[NSString stringWithFormat:@"%f",model.publishtime]];
    
//    NSDate *nowDate = [NSDate date];
//    // 当前日期
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd HH-mm-ss";
//    NSDate *creat = [formatter dateFromString:time];
//    // 将传入的字符串转化成时间
//    NSTimeInterval delta = [nowDate timeIntervalSinceDate:creat];
//    NSLog(@"%f",delta);

    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [_headBtn sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:[UIImage imageNamed:@"peien"]];
    //名字位置刷新 vip的位置也刷新
    _userName.text = model.nickName;
    CGFloat replyCountWidth = [_userName.text getTextWidthWithFont:self.userName.font];
    _userName.frame = CGRectMake(CGRectGetMaxX(_headBtn.frame)+10, _headBtn.center.y - 15, replyCountWidth, 30);
    _vipLab.frame = CGRectMake(CGRectGetMaxX(_userName.frame) + 10, _headBtn.center.y - 7.5, 30, 15);
    
    _likeNum.text = [NSString stringWithFormat:@"%ld",model.praisecount];
    //判断是否点赞
    _zanImg.image = [UIImage imageNamed:@"正文-点赞-已点赞"];
    _commentNum.text = [NSString stringWithFormat:@"%ld",model.replycount];
    _commentImg.image = [UIImage imageNamed:@"作品-作品信息-评论(灰色）"];
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
        [img sd_setImageWithURL:[NSURL URLWithString:_imgArray[i]]];
        //        img.image = [UIImage imageNamed:_imgArray[i]];
        img.backgroundColor = [UIColor greenColor];
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
    CGFloat cellH = strH + 120;
    NSInteger row = imgs.count / 3;
    if (imgs.count) {
        if (imgs.count % 3 !=0) {
            row += 1;
        }
        cellH +=  row * imgHeight  + (row-1) * 10; // 图片高度 + 间隙
    }
    return  cellH;
}

+(ZZTFindCommentCell *)dynamicCellWithTable:(UITableView *)table{
    ZZTFindCommentCell * cell = [table dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (!cell) {
        cell = [[ZZTFindCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(self)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
//
//-(void)tapZanBtn{
//    _isZan = !_isZan;
//    UIImage *selZan = [UIImage imageNamed:@"zan_icon"];
//    if (_isZan) {
//        _zanImg.image = selZan;
//        NSInteger zanNum = [_likeNum.text integerValue];
//        ++zanNum;
//        _likeNum.text = [NSString stringWithFormat:@"%ld",zanNum];
//    }else{
//        _zanImg.image = [UIImage imageNamed:@"zan_icon"];
//        NSInteger zanNum = [_likeNum.text integerValue];
//        --zanNum;
//        _likeNum.text = [NSString stringWithFormat:@"%ld",zanNum];
//    }
//}

@end
