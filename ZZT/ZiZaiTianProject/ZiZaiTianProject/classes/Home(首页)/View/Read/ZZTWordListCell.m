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
@property (nonatomic,strong) UIImageView *commentView;
@property (nonatomic,strong) UILabel *commentLab;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UILabel *xuHuaLab;

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
//    headImg.backgroundColor = [UIColor yellowColor];
    _headImg = headImg;
    [self.contentView addSubview:headImg];
    //bookname
    UILabel *chapterLab = [[UILabel alloc] init];
//    chapterLab.backgroundColor = [UIColor yellowColor];
    _chapterLab = chapterLab;
    [self.contentView addSubview:chapterLab];

    //页数
    UILabel *pageLab = [[UILabel alloc] init];
//    pageLab.backgroundColor = [UIColor yellowColor];
    _pageLab = pageLab;
    [self.contentView addSubview:pageLab];
    //赞
    UIImageView *likeImg = [[UIImageView alloc] init];
//    likeImg.backgroundColor = [UIColor yellowColor];
    _likeImg = likeImg;
    [likeImg setImage:[UIImage imageNamed:@"正文-点赞-已点赞"]];
    [self.contentView addSubview:likeImg];
    
    UILabel *likeNum = [[UILabel alloc] init];
    [likeNum setTextColor:[UIColor colorWithHexString:@"#F0F0F0"]];
    _likeNum = likeNum;
    [self.contentView addSubview:likeNum];
    //评论
    UIImageView *commentView = [[UIImageView alloc] init];
//    commentView.backgroundColor = [UIColor yellowColor];
    _commentView = commentView;
    [commentView setImage:[UIImage imageNamed:@"作品-作品信息-评论(灰色）"]];
    [self.contentView addSubview:commentView];
    
    UILabel *commentLab = [[UILabel alloc] init];
    [commentLab setTextColor:[UIColor grayColor]];
//    commentLab.backgroundColor = [UIColor yellowColor];
    _commentLab = commentLab;
    [self.contentView addSubview:commentLab];
    
    //底线
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor grayColor];
    [bottomView setBackgroundColor:[UIColor colorWithHexString:@"#F0F1F2"]];
    _bottomView = bottomView;
    [self.contentView addSubview:bottomView];
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
            make.width.mas_equalTo(80);
        }];
    }else{
        //表示有
        [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(10);
            make.left.equalTo(self).with.offset(0);
            //            make.bottom.equalTo(self.bottomView.mas_top).with.offset(-10);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(1);
        }];
    }
    
    [self.chapterLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(10);
        make.left.equalTo(self.headImg.mas_right).with.offset(10);
        make.right.equalTo(self).with.offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    [self.pageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chapterLab.mas_bottom).with.offset(10);
        make.left.equalTo(self.chapterLab.mas_left).with.offset(0);
        make.right.equalTo(self).with.offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    [self.commentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(self).with.offset(10);
        make.right.equalTo(self).with.offset(-10);
        make.bottom.equalTo(self.bottomView.mas_top).with.offset(-10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(50);
    }];
    
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(self).with.offset(10);
        make.right.equalTo(self.commentLab.mas_left).with.offset(-5);
        make.bottom.equalTo(self.bottomView.mas_top).with.offset(-11);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(18);
    }];
    
    [self.likeNum mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(self).with.offset(10);
        make.right.equalTo(self.commentView.mas_left).with.offset(-5);
        
        make.bottom.equalTo(self.bottomView.mas_top).with.offset(-10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(50);
    }];
    
    [self.likeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(self).with.offset(10);
        make.right.equalTo(self.likeNum.mas_left).with.offset(-5);
        make.bottom.equalTo(self.bottomView.mas_top).with.offset(-11);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(18);
    }];
    
}

-(void)setModel:(ZZTChapterlistModel *)model{
    _model = model;
    
    if([model.type isEqualToString:@"1"]){
        //漫画
        //名字
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.chapterCover]];
        [self.chapterLab setText:model.chapterName];
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
    self.commentLab.text = model.commentNum;

    [self.likeImg setImage:[UIImage imageNamed:@"正文-点赞-已点赞"]];
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

@end
