//
//  ZZTCommentHeaderView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/10/12.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTCommentHeaderView.h"
#import "ZZTCircleModel.h"
#import "customer.h"
#import "ImageLeftBtn.h"
//距离
const CGFloat SectionHeaderHorizontalSpace = 8; //水平方向控件之间的间隙距离
const CGFloat SectionHeaderVerticalSpace = 8; //竖直方向控件之间的间隙距离
const CGFloat SectionHeaderTopSpace = 12; //顶部的空白距离
const CGFloat SectionHeaderBottomSpace = 5; //底部的空白距离
const CGFloat SectionHeaderPictureSpace = 5; //图片之间的间隙距离
const CGFloat SectionHeaderLineSpace = 2; //文本行间距
const CGFloat SectionHeaderBigFontSize = 16;
const CGFloat SectionHeaderSmallFontSize = 13;
const CGFloat SectionHeaderMoreBtnHeight = 25; //全文按钮高度
const CGFloat SectionHeaderNameLabelHeight = 20; //名字label高度
const CGFloat SectionHeaderTimeLabelHeight = 20; //时间label高度
const CGFloat SectionHeaderMaxContentHeight = 104; //文本最大高度
const CGFloat SectionHeaderOnePictureHeight = 100; //只有一张图片时的图片高度
const CGFloat SectionHeaderSomePicturesHeight = 70; //有多张图片时的单张图片高度

@interface ZZTCommentHeaderView ()<TTTAttributedLabelDelegate>

@property (nonatomic, strong) ZZTCircleModel *item;
@property (nonatomic, assign) NSUInteger section;
@property (nonatomic, strong) UIImageView *headImgV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) TTTAttributedLabel *contentLabel;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIView *imgBgView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) ImageLeftBtn *likeBtn;
@property (nonatomic, strong) NSString *isPraise;
@property (nonatomic, strong) UIView *corner;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation ZZTCommentHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    //背景色
    self.contentView.backgroundColor = [UIColor whiteColor];
    //头像图
    self.headImgV = [UIImageView new];
    //一种形式
    self.headImgV.contentMode = UIViewContentModeScaleAspectFill;
    //只显示中间的部分
    self.headImgV.clipsToBounds = YES;
    
    //名字
    self.nameLabel = [UILabel new];
    //16号字体
    self.nameLabel.font = [UIFont boldSystemFontOfSize:SectionHeaderBigFontSize];
    //颜色
    self.nameLabel.textColor = [UIColor colorWithRGB:@"54,71,121"];
    //  可以点击
    self.nameLabel.userInteractionEnabled = YES;
    //点击名字的事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapName:)];
    [self.nameLabel addGestureRecognizer:tap];
    
    //内容lab
    self.contentLabel = [TTTAttributedLabel new];
    
    self.contentLabel.delegate = self;
    //16号字体
    self.contentLabel.font = [UIFont systemFontOfSize:SectionHeaderBigFontSize];
    //不限制行数
    self.contentLabel.numberOfLines = 0;
    //行距2
    self.contentLabel.lineSpacing = SectionHeaderLineSpace;
    //省略号的样式
    self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    //宽度
    self.contentLabel.preferredMaxLayoutWidth = SCREEN_MIN_LENGTH - 3 * SectionHeaderHorizontalSpace - 36;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCommentLab:)];
    [self.contentLabel addGestureRecognizer:tapGesture];
    
    //更多按钮
    self.moreBtn = [UIButton new];
    //字体颜色
    [self.moreBtn setTitleColor:[UIColor colorWithRGB:@"92,140,193"] forState:UIControlStateNormal];
    [self.moreBtn setTitle:@"全文" forState:UIControlStateNormal];
    self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:SectionHeaderBigFontSize];
    //点击事件
    [self.moreBtn addTarget:self action:@selector(clickMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    //图片
    self.imgBgView = [UIView new];
    
    //时间
    self.timeLabel = [UILabel new];
    self.timeLabel.font = [UIFont systemFontOfSize:SectionHeaderSmallFontSize];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    
    //评论按钮
    self.commentBtn = [UIButton new];
    [self.commentBtn setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
    [self.commentBtn addTarget:self action:@selector(clickCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //评论按钮
    self.likeBtn = [[ImageLeftBtn alloc] init];
    [self.likeBtn setImage:[UIImage imageNamed:@"正文-点赞-已点赞"] forState:UIControlStateNormal];
    [self.likeBtn setTitle:@"100" forState:UIControlStateNormal];
    [self.likeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.likeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.likeBtn addTarget:self action:@selector(didClickLikeBtn:) forControlEvents:UIControlEventTouchUpInside];
    // 左图右字
   
//    [self.likeBtn setImagePosition:LXMImagePositionLeft spacing:0];

    // 左图右字
//    self.likeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
//    self.likeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0 , 0);
//    self.likeBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);

    self.corner = [UIView new];
    self.corner.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    //x改成你要的角度 順時針90就用90 逆時針90就用-90 无论是M_PI还是-M_PI都是逆时针旋转
    CGAffineTransform transform = CGAffineTransformMakeRotation(45 * M_PI/180.0);
    [self.corner setTransform:transform];
    
//    self.menuView = [CommentMenuView new];
//    __weak typeof(self) weakSelf = self;
//    //菜单 赞的事件。评论的事件
//    [self.menuView setLikeButtonClickedBlock:^{
//        if ([weakSelf.delegate respondsToSelector:@selector(didClickLikeButton:)]) {
//            [weakSelf.delegate didClickLikeButton:weakSelf.section];
//        }
//    }];
//    [self.menuView setCommentButtonClickedBlock:^{
//        if ([weakSelf.delegate respondsToSelector:@selector(didClickCommentButton:)]) {
//            [weakSelf.delegate didClickCommentButton:weakSelf.section];
//        }
//    }];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor grayColor];
    
    [self.contentView addSubview:bottomView];
    [self.contentView addSubview:self.headImgV];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.moreBtn];
    [self.contentView addSubview:self.imgBgView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.commentBtn];
    [self.contentView addSubview:self.corner];
    [self.contentView addSubview:self.likeBtn];

//    [self.contentView addSubview:self.menuView];
    
}

-(void)didClickLikeBtn:(ImageLeftBtn *)btn{
    if ([self.delegate respondsToSelector:@selector(didClickLikeButton:)]) {
        [self.delegate didClickLikeButton:self.section];
    }
    NSInteger num = [self.likeBtn.titleLabel.text integerValue];

    if([self.isPraise isEqualToString:@"0"]){
        self.isPraise = @"1";
        num++;
        [self.likeBtn setImage:[UIImage imageNamed:@"正文-点赞-已点赞"] forState:UIControlStateNormal];
    }else{
        self.isPraise = @"0";
        num--;
        [self.likeBtn setImage:[UIImage imageNamed:@"正文-点赞-未点赞(灰色）"] forState:UIControlStateNormal];
    }
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%ld",num] forState:UIControlStateNormal];
}

-(void)tapName:(UITapGestureRecognizer *)gesture{
    
}

-(void)clickMoreBtn:(UIButton *)button{
    NSLog(@"self.item.isSpread:%d",self.item.isSpread);
    if (self.item.isSpread) {
        [button setTitle:@"收起" forState:UIControlStateNormal];
    } else {
        [button setTitle:@"全文" forState:UIControlStateNormal];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(spreadContent:section:)]) {
        [self.delegate spreadContent:!self.item.isSpread section:self.section];
    }
}

-(void)clickCommentLab:(UITapGestureRecognizer *)gesture{
    if ([_delegate respondsToSelector:@selector(didCommentLabelReply:)]) {
        [_delegate didCommentLabelReply:self.section];
    }
}

- (void)setContentData:(ZZTCircleModel *)circleItem section:(NSInteger)section{
    self.item = circleItem;
    
    self.section = section;
    
    [self.headImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(SectionHeaderHorizontalSpace));
        make.top.equalTo(@(SectionHeaderTopSpace));
        make.width.height.equalTo(@50);
    }];
    
    customer *user = circleItem.customer;
    
    [self.headImgV sd_setImageWithURL:[NSURL URLWithString:user.headimg]];
    
    //    名字的约束
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        //8
        make.left.equalTo(self.headImgV.mas_right).offset(SectionHeaderHorizontalSpace);
        //-8
        make.right.equalTo(@(-80));
        make.top.equalTo(self.headImgV);
        make.height.equalTo(@(SectionHeaderNameLabelHeight));
    }];
    self.nameLabel.text = user.nickName;
    
    //    名字的约束
    [self.likeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        //8
//        make.left.equalTo(self.nameLabel.mas_right).offset(SectionHeaderHorizontalSpace);
        make.width.equalTo(@(50));

        //-8
        make.right.equalTo(@(-SectionHeaderHorizontalSpace));
        make.top.equalTo(self.headImgV);
        make.height.equalTo(@(SectionHeaderNameLabelHeight));
    }];
    
    //点赞
    if([circleItem.ifPraise isEqualToString:@"0"]){
        [self.likeBtn setImage:[UIImage imageNamed:@"正文-点赞-未点赞(灰色）"] forState:UIControlStateNormal];
    }else{
        [self.likeBtn setImage:[UIImage imageNamed:@"正文-点赞-已点赞"] forState:UIControlStateNormal];
    }
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%ld",circleItem.praiseNum] forState:UIControlStateNormal];
    self.isPraise = circleItem.ifPraise;

    //    名字的约束
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        //8
        make.left.equalTo(self.headImgV.mas_right).offset(SectionHeaderHorizontalSpace);
        //-8
        make.right.equalTo(@(-SectionHeaderHorizontalSpace));
        make.top.equalTo(self.nameLabel.mas_bottom).offset(SectionHeaderHorizontalSpace);
        make.height.equalTo(@(SectionHeaderNameLabelHeight));
    }];
    
    self.timeLabel.text = circleItem.commentDate;

    //点赞
    //内容高度
    [self setContentLabelConstraint];
    
    [self setImgBgViewContent];
    
    if(circleItem.replyComment.count == 0){
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            //8
            make.left.equalTo(self.contentView).offset(0);
            //-8
            make.right.equalTo(self.contentView).offset(0);
            make.bottom.equalTo(self.contentView).offset(0);
            make.height.equalTo(@(1));
        }];
    }
}

- (void)setContentLabelConstraint {
    self.contentLabel.text = nil;
    //如果内容高度为0
    if (self.item.contentLabelHeight <= 0) {
        //全文不显示
        [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        //内容不显示
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        self.contentLabel.hidden = YES;
        self.moreBtn.hidden = YES;
        //如果高度小于104
    } else if (self.item.contentLabelHeight <= SectionHeaderMaxContentHeight){
        [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        self.contentLabel.hidden = NO;
        //更多
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.item.contentLabelHeight));
            make.top.equalTo(self.timeLabel.mas_bottom).offset(SectionHeaderVerticalSpace);
            make.left.right.equalTo(self.timeLabel);
        }];
        self.moreBtn.hidden = YES;
        self.contentLabel.text = self.item.content;
    } else {
        self.contentLabel.hidden = NO;
        self.moreBtn.hidden = NO;
        if (self.item.isSpread) {
            [self.moreBtn setTitle:@"收起" forState:UIControlStateNormal];
            [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(self.item.contentLabelHeight));
                make.top.equalTo(self.timeLabel.mas_bottom).offset(SectionHeaderVerticalSpace);
                make.left.right.equalTo(self.timeLabel);
            }];
        } else {
            [self.moreBtn setTitle:@"全文" forState:UIControlStateNormal];
            [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(SectionHeaderMaxContentHeight));
                make.top.equalTo(self.timeLabel.mas_bottom).offset(SectionHeaderVerticalSpace);
                make.left.right.equalTo(self.timeLabel);
            }];
        }
        self.contentLabel.text = self.item.content;
        
       

        [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(SectionHeaderVerticalSpace);
            make.left.equalTo(self.timeLabel).offset(-3);
            make.width.equalTo(@40);
            make.height.equalTo(@(SectionHeaderMoreBtnHeight));
        }];
    }
    //加事件
//    NSRange boldRange0 = NSMakeRange(0, self.item.content.length);
//
//    [self.contentLabel addLinkToTransitInformation:@{@"contentLabel":self.item.content} withRange:boldRange0];
//    //正常状态下的属性
//    _contentLabel.linkAttributes = @{
//                                       (NSString *)kCTForegroundColorAttributeName:[UIColor blackColor],
//                                       (NSString *)kCTUnderlineStyleAttributeName: @(YES)
//                                       };
    

}

//-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components{
//    if ([_delegate respondsToSelector:@selector(didCommentLabelReply:)]) {
//        [_delegate didCommentLabelReply:components];
//    }
//}



- (void)setImgBgViewContent{
    [self.imgBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //如果小图小于0
    if (self.item.imageArray <= 0) {
        self.imgBgView.hidden = YES;
    } else {
        //显示
        self.imgBgView.hidden = NO;
        //设置约束
        [self setImgBgViewConstraint:self.item.imgBgViewHeight];
        
        [self addPictures];
    }
}

- (void)setImgBgViewConstraint:(CGFloat)height {
    //如果更多隐藏了
    if (self.moreBtn.hidden) {
        //        如果没有内容
        if (self.contentLabel.hidden) {
            //            那么图片约束
            [self.imgBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.nameLabel.mas_bottom);
                make.left.right.equalTo(self.nameLabel);
                make.height.equalTo(@(height));
            }];
        } else {
            //            如果有内容
            [self.imgBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentLabel.mas_bottom);
                make.left.right.equalTo(self.nameLabel);
                make.height.equalTo(@(height));
            }];
        }
    } else {
        //如果有更多按钮
        [self.imgBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.moreBtn.mas_bottom);
            make.left.right.equalTo(self.nameLabel);
            make.height.equalTo(@(height));
        }];
    }
}

//添加图片
- (void)addPictures {
    //如果有图
    if (self.item.imageArray.count > 0) {
        //如果只有一张图
        if (self.item.imageArray.count == 1) {
            //创建一张imageView
            UIImageView *imgV = [self createImgV:self.item.imageArray[0]];
            [self.imgBgView addSubview:imgV];
            //设置约束
            [imgV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(SectionHeaderVerticalSpace));
                make.left.equalTo(self.imgBgView);
                make.height.equalTo(@(SectionHeaderOnePictureHeight));
                make.width.equalTo(@(SectionHeaderOnePictureHeight + 40));
            }];
        } else {
            //不为一
            for (int i = 0; i < self.item.imageArray.count; i++) {
                //如果有三张图片
                if (i == 3) {
                    break;
                }
                UIImageView *imgV = [self createImgV:self.item.imageArray[i]];
                [self.imgBgView addSubview:imgV];
                [imgV mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(@(SectionHeaderVerticalSpace));
                    make.left.equalTo(@((SectionHeaderPictureSpace + SectionHeaderSomePicturesHeight) * i));
                    make.width.height.equalTo(@(SectionHeaderSomePicturesHeight));
                }];
            }
            //如果行数大于3
            if (self.item.imageArray.count > 3) {
                for (int i = 3; i < self.item.imageArray.count; i++) {
                    //如果有6张图片
                    if (i == 6) {
                        break;
                    }
                    UIImageView *imgV = [self createImgV:self.item.imageArray[i]];
                    [self.imgBgView addSubview:imgV];
                    [imgV mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(@(SectionHeaderVerticalSpace + SectionHeaderPictureSpace + SectionHeaderSomePicturesHeight));
                        make.left.equalTo(@((SectionHeaderPictureSpace + SectionHeaderSomePicturesHeight) * (i - 3)));
                        make.width.height.equalTo(@(SectionHeaderSomePicturesHeight));
                    }];
                }
            }
            if (self.item.imageArray.count > 6) {
                for (int i = 6; i < self.item.imageArray.count; i++) {
                    //如果有九张图片
                    if (i == 9) {
                        break;
                    }
                    UIImageView *imgV = [self createImgV:self.item.imageArray[i]];
                    [self.imgBgView addSubview:imgV];
                    [imgV mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(@(SectionHeaderVerticalSpace + SectionHeaderPictureSpace * 2 + SectionHeaderSomePicturesHeight * 2));
                        make.left.equalTo(@((SectionHeaderPictureSpace + SectionHeaderSomePicturesHeight) * (i - 6)));
                        make.width.height.equalTo(@(SectionHeaderSomePicturesHeight));
                    }];
                }
            }
        }
    }
}

- (UIImageView *)createImgV:(NSString *)urlStr {
    UIImageView *imgV = [UIImageView new];
    imgV.backgroundColor = [UIColor lightGrayColor];
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    imgV.clipsToBounds = YES;
    [imgV sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    return imgV;
}
@end
