//
//  ZZTWordListCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/22.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTWordListCell.h"
#import "ZZTChapterlistModel.h"
@interface ZZTWordListCell()
@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UIImageView *headBounds;
@property (nonatomic,strong) UILabel *chapterLab;
@property (nonatomic,strong) UILabel *pageLab;
@property (nonatomic,strong) UIImageView *likeImg;
@property (nonatomic,strong) UILabel *likeNum;
@property (nonatomic,strong) UIButton *commentView;
@property (nonatomic,strong) UILabel *commentLab;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UILabel *xuHuaLab;
@property (nonatomic,strong) UIImageView *VIPChapterImg;
@end

@implementation ZZTWordListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    //漫画
    //图片
    //图片
    UIImageView *headImg = [[UIImageView alloc] init];
    [headImg setContentMode:UIViewContentModeScaleToFill];
    headImg.layer.cornerRadius = 8;
    headImg.layer.masksToBounds = YES;
    _headImg = headImg;
    [self.contentView addSubview:headImg];
    
    //bookname
    UILabel *chapterLab = [[UILabel alloc] init];
    _chapterLab = chapterLab;
    [self.contentView addSubview:chapterLab];

    //页数
    UILabel *pageLab = [[UILabel alloc] init];
    _pageLab = pageLab;
    [self.contentView addSubview:pageLab];
    
    //赞
    UIImageView *likeImg = [[UIImageView alloc] init];
    _likeImg = likeImg;
    [likeImg setImage:[UIImage imageNamed:@"catoonDetail_like"]];
    [self.contentView addSubview:likeImg];
    
    UILabel *likeNum = [[UILabel alloc] init];
    [likeNum setTextColor:[UIColor colorWithHexString:@"#F0F0F0"]];
    _likeNum = likeNum;
    [self.contentView addSubview:likeNum];
    
    //底线
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor grayColor];
    [bottomView setBackgroundColor:[UIColor colorWithHexString:@"#F0F1F2"]];
    _bottomView = bottomView;
    [self.contentView addSubview:bottomView];
    
    //VIP章节
    UIImageView *VIPChapterImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VIPChapterImage"]];
    _VIPChapterImg = VIPChapterImg;
    [self.contentView addSubview:VIPChapterImg];
    VIPChapterImg.hidden = YES;
}

-(void)goToCommentView{
    if(_gotoCommentViewBlock){
        self.gotoCommentViewBlock();
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(0);
        make.bottom.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(0);
        make.height.mas_equalTo(1);
    }];

    //如果是漫画
    if([self.model.type isEqualToString:@"1"]){
        
        [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(10);
            make.left.equalTo(self).with.offset(10);
            make.bottom.equalTo(self.bottomView.mas_top).with.offset(-10);
            make.height.mas_equalTo(100);
        }];
    }else{
        //表示有
        [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(10);
            make.left.equalTo(self).with.offset(0);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(1);
        }];
    }
    
    //VIP
    [self.VIPChapterImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self.mas_right).offset(-8);
        
    }];
    
    [self.chapterLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(10);
        make.left.equalTo(self.headImg.mas_right).with.offset(10);
//        make.right.equalTo(self).with.offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    [self.pageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chapterLab.mas_bottom).with.offset(10);
        make.left.equalTo(self.chapterLab.mas_left).with.offset(0);
//        make.right.equalTo(self).with.offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-8);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
//    [self.commentView.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.commentView.mas_left);
//        make.bottom.equalTo(self.commentView.mas_bottom);
//        make.height.mas_equalTo(20);
//    }];
    
    [self.likeNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.commentView.mas_left).with.offset(-5);
        make.bottom.equalTo(self.bottomView.mas_top).with.offset(-10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(50);
    }];
    
    [self.likeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.likeNum.mas_left).with.offset(-5);
        make.bottom.equalTo(self.bottomView.mas_top).with.offset(-11);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(16);
    }];
}

-(void)setModel:(ZZTChapterlistModel *)model{
    _model = model;
    
    if([model.type isEqualToString:@"1"]){
        //漫画
        //名字
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.chapterCover] placeholderImage:[UIImage imageNamed:@"chapterPlaceV"] options:0 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            //计算image的高度
            if(image){
                CGFloat proportion = image.size.height / (SCREEN_HEIGHT * 0.25 - 21);
                //            NSLog(@"proportion:%f",proportion);
                CGFloat imageViewW = image.size.width / proportion;
                //            NSLog(@"imageViewW:%f",imageViewW);
                [self.headImg mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(imageViewW);
                }];
            }
        }];
        [self.chapterLab setAttributedText:[NSString addStrSpace:[NSString stringWithFormat:@"第%@",model.chapterName]]];

    }else{
        //剧本
        [self.chapterLab setText:model.chapterName];
    }
    self.chapterLab.textColor = [UIColor blackColor];
    
    
    self.likeNum.text = [NSString stringWithFormat:@"%ld",model.praiseNum];
    self.likeNum.textColor = [UIColor grayColor];
    //如果是章节 显示页 漫画 显示画
    if([model.type isEqualToString:@"2"]){
        if(model.wordNum / 10000 > 0){
            self.pageLab.text = [NSString stringWithFormat:@"%zdw字",model.wordNum/10000];
        }else{
            self.pageLab.text = [NSString stringWithFormat:@"%zd字",model.wordNum];
        }
    }else{
        if(model.chapterPage)self.pageLab.text = [NSString stringWithFormat:@"%@画",model.chapterPage];
    }
    self.pageLab.textColor = [UIColor grayColor];
    
    NSString *replayCountText = [NSString makeTextWithCount:model.commentNum.integerValue];

    [self.commentView setTitle:replayCountText forState:UIControlStateNormal];
    
    CGFloat replyCountWidth = [replayCountText getTextWidthWithFont:self.commentView.titleLabel.font] + 30;
    //设置宽度
    [self.commentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(replyCountWidth));
    }];
    [self.likeImg setImage:[UIImage imageNamed:@"catoonDetail_like"]];
    
    //VIP章节
    if(model.ifrelease == 2){
        self.VIPChapterImg.hidden = NO;
    }
    
}

////点赞和评论跳转
//-(void)clickLike{
//    //反状态
//    NSInteger zanNum = [_likeNum.text integerValue];
//    UIImage *selZan = [UIImage imageNamed:@"正文-点赞-未点赞(灰色）"];
//    if (_ifrelease) {
//        _ifrelease = NO;
//        _likeImage.image = selZan;
//        --zanNum;
//        _likeNum.text = [NSString stringWithFormat:@"%ld",zanNum];
//    }else{
//        _ifrelease = YES;
//        _likeImage.image = [UIImage imageNamed:@"正文-点赞-已点赞"];
//        ++zanNum;
//        _likeNum.text = [NSString stringWithFormat:@"%ld",zanNum];
//    }
//    _model.praiseNum = zanNum;
//    _model.ifrelease = _ifrelease;
//    if (self.btnBlock) {
//        // 调用block传入参数
//        self.btnBlock(self,_model);
//    }
//}

- (UIButton *)commentView {
    if (!_commentView) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"commentImg"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(goToCommentView) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
        _commentView = btn;
    }
    
    return _commentView;
}
@end
