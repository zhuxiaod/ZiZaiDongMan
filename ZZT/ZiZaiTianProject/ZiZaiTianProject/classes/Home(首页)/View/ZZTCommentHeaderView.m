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

@interface ZZTCommentHeaderView ()

@property (nonatomic, strong) ZZTCircleModel *item;
@property (nonatomic, assign) NSUInteger section;
@property (nonatomic, strong) UIImageView *headImgV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) TTTAttributedLabel *contentLabel;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIView *imgBgView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIView *corner;

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
    
}

- (void)setContentData:(ZZTCircleModel *)circleItem section:(NSInteger)section{
    self.item = circleItem;
    
    self.section = section;
    
    [self.headImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(SectionHeaderHorizontalSpace));
        make.top.equalTo(@(SectionHeaderTopSpace));
        make.width.height.equalTo(@36);
    }];
    customer *user = circleItem.customer;
    
    [self.headImgV sd_setImageWithURL:[NSURL URLWithString:user.headimg]];
    
    //    名字的约束
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        //8
        make.left.equalTo(self.headImgV.mas_right).offset(SectionHeaderHorizontalSpace);
        //-8
        make.right.equalTo(@(-SectionHeaderHorizontalSpace));
        make.top.equalTo(self.headImgV);
        make.height.equalTo(@(SectionHeaderNameLabelHeight));
    }];
    self.nameLabel.text = user.nickName;
    
    //内容高度
    [self setContentLabelConstraint];
    
    [self setImgBgViewContent];

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
            make.top.equalTo(self.nameLabel.mas_bottom).offset(SectionHeaderVerticalSpace);
            make.left.right.equalTo(self.nameLabel);
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
                make.top.equalTo(self.nameLabel.mas_bottom).offset(SectionHeaderVerticalSpace);
                make.left.right.equalTo(self.nameLabel);
            }];
        } else {
            [self.moreBtn setTitle:@"全文" forState:UIControlStateNormal];
            [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(SectionHeaderMaxContentHeight));
                make.top.equalTo(self.nameLabel.mas_bottom).offset(SectionHeaderVerticalSpace);
                make.left.right.equalTo(self.nameLabel);
            }];
        }
        self.contentLabel.text = self.item.content;
        [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(SectionHeaderVerticalSpace);
            make.left.equalTo(self.nameLabel).offset(-3);
            make.width.equalTo(@40);
            make.height.equalTo(@(SectionHeaderMoreBtnHeight));
        }];
    }
}

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
