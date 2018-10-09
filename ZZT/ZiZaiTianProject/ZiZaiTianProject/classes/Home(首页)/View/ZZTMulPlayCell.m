//
//  ZZTMulPlayCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/29.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTMulPlayCell.h"
#import "ZZTChapterlistModel.h"

@interface ZZTMulPlayCell()

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

@implementation ZZTMulPlayCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    //头像框
    UIImageView *headBounds = [[UIImageView alloc] init];
//    headBounds.backgroundColor = [UIColor redColor];
    _headBounds = headBounds;
    [self.contentView addSubview:headBounds];
    
    //图片
    UIImageView *headImg = [[UIImageView alloc] init];
//    headImg.backgroundColor = [UIColor yellowColor];
    _headImg = headImg;
    [self.contentView addSubview:headImg];
    
    //章节名
    UILabel *chapterLab = [[UILabel alloc] init];
//    chapterLab.backgroundColor = [UIColor yellowColor];
    _chapterLab = chapterLab;

    [self.contentView addSubview:chapterLab];
    
    //页数
    UILabel *pageLab = [[UILabel alloc] init];
//    pageLab.backgroundColor = [UIColor yellowColor];
    _pageLab = pageLab;
    [self.contentView addSubview:pageLab];
    
    //点赞图片
    UIImageView *likeImg = [[UIImageView alloc] init];
//    likeImg.backgroundColor = [UIColor yellowColor];
    _likeImg = likeImg;
    [likeImg setImage:[UIImage imageNamed:@"正文-点赞-已点赞"]];
    [self.contentView addSubview:likeImg];
    
    //点赞数量
    UILabel *likeNum = [[UILabel alloc] init];
    [likeNum setTextColor:[UIColor colorWithHexString:@"#F0F0F0"]];
    _likeNum = likeNum;
    [self.contentView addSubview:likeNum];

    //评论图
    UIImageView *commentView = [[UIImageView alloc] init];
//    commentView.backgroundColor = [UIColor yellowColor];
    _commentView = commentView;
    [commentView setImage:[UIImage imageNamed:@"作品-作品信息-评论(灰色）"]];
    [self.contentView addSubview:commentView];
    
    //评论数量
    UILabel *commentLab = [[UILabel alloc] init];
    [commentLab setTextColor:[UIColor colorWithHexString:@"#F0F1F2"]];

//    commentLab.backgroundColor = [UIColor yellowColor];
    _commentLab = commentLab;
    [self.contentView addSubview:commentLab];
    
    //底线
    UIView *bottomView = [[UIView alloc] init];
//    bottomView.backgroundColor = [UIColor grayColor];
    [bottomView setBackgroundColor:[UIColor colorWithHexString:@"#F0F1F2"]];
    _bottomView = bottomView;
    [self.contentView addSubview:bottomView];
    
    //评论数量
    UILabel *xuHuaLab = [[UILabel alloc] init];
//    xuHuaLab.backgroundColor = [UIColor redColor];
    _xuHuaLab = xuHuaLab;
    [self.bottomView addSubview:xuHuaLab];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if(_isHave == YES){
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(0);
            make.bottom.equalTo(self.contentView).with.offset(0);
            make.right.equalTo(self.contentView).with.offset(0);
            make.height.mas_equalTo(20);
        }];
        
        [self.xuHuaLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomView).with.offset(10);
            make.bottom.equalTo(self.bottomView).with.offset(-2);
            make.top.equalTo(self.bottomView).with.offset(2);
            make.width.mas_equalTo(100);
        }];
        
    }else{
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(0);
            make.bottom.equalTo(self.contentView).with.offset(0);
            make.right.equalTo(self.contentView).with.offset(0);
            make.height.mas_equalTo(1);
        }];
    }
    
    //如果是漫画
    if([_str isEqualToString:@"1"]){
        [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(10);
            make.left.equalTo(self).with.offset(10);
            make.bottom.equalTo(self.bottomView.mas_top).with.offset(-10);
            make.width.mas_equalTo(80);
        }];
    }else{
        [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(10);
            make.left.equalTo(self).with.offset(10);
//            make.bottom.equalTo(self.bottomView.mas_top).with.offset(-10);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(80);
        }];
        //头像框
        [self.headBounds mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(7);
            make.left.equalTo(self).with.offset(7);
            //            make.bottom.equalTo(self.bottomView.mas_top).with.offset(-10);
            make.width.mas_equalTo(86);
            make.height.mas_equalTo(86);
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
        make.left.equalTo(self.headImg.mas_right).with.offset(10);
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

-(void)setStr:(NSString *)str{
    _str = str;
    //1是漫画  2是剧本
    
//    [_headImg ];
}

-(void)setIsHave:(BOOL)isHave{
    _isHave = isHave;
}

-(void)setXuHuaModel:(ZZTChapterlistModel *)xuHuaModel{
    [_headBounds setImage:[UIImage imageNamed:@"我的-头像框"]];

    [_headImg sd_setImageWithURL:[NSURL URLWithString:xuHuaModel.chapterCover] placeholderImage:[UIImage imageNamed:@"peien"]];
    
    [_chapterLab setText:xuHuaModel.chapterName];
    
    [_pageLab setText:xuHuaModel.chapterPage];
    
    [_likeNum setText:[NSString stringWithFormat:@"%ld",xuHuaModel.praiseNum]];
    
    [_commentLab setText:xuHuaModel.commentNum];
    
    [_xuHuaLab setText:[NSString stringWithFormat:@"%@人续画",xuHuaModel.xuhuaNum]];
}
@end
