//
//  CircleCell.m
//  WeChat1
//
//  Created by Topsky on 2018/5/11.
//  Copyright © 2018年 Topsky. All rights reserved.
//

#import "CircleCell.h"
#import <TTTAttributedLabel.h>
#import <Masonry.h>
#import "ZZTUserReplyModel.h"
#import <UIColor+SKYExtension.h>
#import <UIImageView+WebCache.h>
#import "ZZTCommentHeaderView.h"
#import "ZZTCircleModel.h"

//#import "SectionHeaderView.h"

@interface CircleCell () <TTTAttributedLabelDelegate>

//@property (nonatomic, strong) TTTAttributedLabel *commentLabel;

@end

@implementation CircleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup {
    //背景
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [self.contentView addSubview:bgView];

    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-SectionHeaderHorizontalSpace);
        make.left.equalTo(@(36 + SectionHeaderHorizontalSpace * 2));
    }];
    //评论
    TTTAttributedLabel *commentLabel = [TTTAttributedLabel new];
    commentLabel.numberOfLines = 0;
    commentLabel.lineSpacing = SectionHeaderLineSpace;
//    commentLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    commentLabel.font = [UIFont systemFontOfSize:15];
    commentLabel.delegate = self;
    self.commentLabel = commentLabel;
    [self.contentView addSubview:commentLabel];
    [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(3);
        make.bottom.equalTo(self.contentView).offset(-3);
        make.right.equalTo(self.contentView).offset(-SectionHeaderHorizontalSpace);
        make.left.equalTo(@(36 + SectionHeaderHorizontalSpace * 2 + 5));
    }];
    [self linkStyles];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
//点击样式
- (void)linkStyles {
    UIColor *linkColor = [UIColor colorWithRGB:@"54,71,121"];
    CTUnderlineStyle linkUnderLineStyle = kCTUnderlineStyleNone;
    UIColor *activeLinkColor = [UIColor colorWithRGB:@"54,71,121"];
    CTUnderlineStyle activelinkUnderLineStyle  = kCTUnderlineStyleNone;

    // 没有点击时候的样式
    self.commentLabel.linkAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
                                         (NSString *)kCTForegroundColorAttributeName: linkColor,
                                        (NSString *)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:linkUnderLineStyle]};
    // 点击时候的样式
    self.commentLabel.activeLinkAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
                                               (NSString *)kCTForegroundColorAttributeName: activeLinkColor,
                                               (NSString *)kTTTBackgroundFillColorAttributeName:[UIColor lightGrayColor],
                                        (NSString *)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:activelinkUnderLineStyle]};
}

//事件
- (void)setContentData:(ZZTCircleModel *)item index:(NSInteger)index{
    //取出数据源
    ZZTUserReplyModel *model = item.replyComment[index];
    //回复人
    customer *replyer = model.replyCustomer;
    //说话的人
    customer *plyer = model.customer;
    //发布者
    customer *customer = item.customer;    //初始化字符串
    NSString *text = nil;
    //如果用户名为空 用户名字数小于0 数据ID 相同
    //如果是用户说。那么走这个
    //没有回复其他人 自己和自己说话
    if(replyer.nickName == nil || [replyer.nickName length] <= 0 || [replyer.ID isEqualToString:customer.ID]){
        text = [NSString stringWithFormat:@"%@: %@",plyer.nickName,model.content];
        self.commentLabel.text = text;
    }else{
        text = [NSString stringWithFormat:@"%@回复%@: %@",plyer.nickName,replyer.nickName,model.content];
        self.commentLabel.text = text;
    }
    
    //添加url
    //对文字添加跳转
    NSRange boldRange0 = NSMakeRange(0, [plyer.nickName length]);
    NSRange boldRange1 = NSMakeRange([plyer.nickName length] + 2, [replyer.nickName length]);

    [self.commentLabel addLinkToTransitInformation:@{@"user_name":plyer.nickName} withRange:boldRange0];
    //如果回复人为空 回复人名字少于0 或者回复人ID 为
    if(replyer.nickName == nil || [replyer.nickName length] <= 0 || [replyer.ID isEqualToString:customer.ID]){

    } else {
        [self.commentLabel addLinkToTransitInformation:@{@"user_name":replyer} withRange:boldRange1];
    }
}

#pragma mark - TTTAttributedLabelDelegate - 点击跳转
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components {
    if ([_delegate respondsToSelector:@selector(didSelectPeople:)]) {
        [_delegate didSelectPeople:components];
    }
}
@end
