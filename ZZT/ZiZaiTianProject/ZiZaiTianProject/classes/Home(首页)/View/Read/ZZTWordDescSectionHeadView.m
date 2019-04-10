//
//  ZZTWordDescSectionHeadView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/12.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTWordDescSectionHeadView.h"
@interface ZZTWordDescSectionHeadView ()

@property (nonatomic,weak) UILabel  *descLabel;

@property (nonatomic,weak) UIButton *openUpBtn;

@property (nonatomic,assign) CGFloat textHeight;

@property (nonatomic,weak) UILabel *wordLabel;

@property (nonatomic,weak) UIView *backView;

@property (nonatomic,weak) UIView *topView;

@property (nonatomic,weak) UIView *bottomView;

@property (nonatomic,weak)UIView *bottomLine;



@end

static CGFloat const spaceing = 8;

static CGFloat const tbSpaceing = 12;

@implementation ZZTWordDescSectionHeadView

- (void)setDesc:(NSString *)desc {
    _desc = desc;
    if(desc){
        //行距 边距
        NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:desc];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:5.f];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [desc length])];
        self.descLabel.attributedText = attributedString1;
    }
    
    //如果大于2行
    if (self.textHeight > self.descLabel.font.lineHeight * 2) {
//        //流出放button的位置
//        [self.descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.backView.mas_bottom).offset(-tbSpaceing * 2);
//
//        }];
        
        //设置打开按钮
        self.openUpBtn.hidden = NO;
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
//    self.backgroundColor = [UIColor whiteColor];
    UIView *backView = [UIView new];
    _backView = backView;
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    UIView *topView = [UIView new];
    _topView = topView;
    topView.backgroundColor = [UIColor colorWithHexString:@"#F0F1F2"];
    [backView addSubview:topView];
    
    UIView *bottomView = [UIView new];
    _bottomView = bottomView;
    bottomView.backgroundColor = [UIColor colorWithHexString:@"#F0F1F2"];
    [backView addSubview:bottomView];
    
    UILabel *wordLabel = [UILabel new];
    _wordLabel = wordLabel;
    wordLabel.text = @"作品简介";
    [backView addSubview:wordLabel];
    
    //显示内容
    UILabel *descLabel = [UILabel new];
    _descLabel = descLabel;
    descLabel.numberOfLines = 2;
    descLabel.font = [UIFont systemFontOfSize:14];
    descLabel.textColor = [UIColor colorWithHexString:@"#A7A8A9"];
    descLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - spaceing * 2;
    [backView addSubview:descLabel];
    
    self.descLabel = descLabel;
    //底线
    UIView *bottomLine = [UIView new];
    
    _bottomLine = bottomLine;
    
    bottomLine.backgroundColor = [UIColor colorWithRGB:@"239,239,239"];

    [backView addSubview:bottomLine];
    
    UIButton *openUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [openUpBtn setImage:[UIImage imageNamed:@"wordsDetail_open"] forState:UIControlStateNormal];
    [openUpBtn setImage:[UIImage imageNamed:@"wordsDetail_close"] forState:UIControlStateSelected];
    
    [openUpBtn addTarget:self action:@selector(openOrClose:) forControlEvents:UIControlEventTouchUpInside];
    _openUpBtn = openUpBtn;
    self.openUpBtn.hidden = YES;
    [backView addSubview:openUpBtn];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
    }];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_top).offset(0);
        make.right.equalTo(self.backView.mas_right).offset(0);
        make.left.equalTo(self.backView.mas_left).offset(0);
        make.height.mas_equalTo(4);
    }];
    
    [_wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(spaceing);
        make.top.equalTo(self.topView.mas_bottom).offset(5);
        make.width.mas_equalTo(SCREEN_WIDTH - 16);
        make.height.mas_equalTo(30);
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(spaceing);
        make.top.equalTo(self.wordLabel.mas_bottom).offset(5);
        make.right.equalTo(self.backView.mas_right).offset(-spaceing);
        make.bottom.equalTo(self.backView.mas_bottom).offset(-tbSpaceing);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backView).offset(0);
        make.right.equalTo(self.backView).offset(0);
        make.left.equalTo(self.backView).offset(0);
        make.height.mas_equalTo(4);
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.backView);
        make.height.mas_equalTo(SINGLE_LINE_WIDTH);
    }];
    
    [_openUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.wordLabel.mas_centerY);
        make.right.equalTo(self).offset(-8);
        make.width.height.mas_equalTo(30);
    }];
}

- (CGFloat)myHeight {
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    return [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

//文字高度
- (CGFloat)textHeight {
    //如果文字高度大于1
    if (_textHeight < 1) {
        _textHeight = [self getDescTextHeight];
    }
    return _textHeight;
}

//获得文字高度
- (CGFloat)getDescTextHeight {
    //最大尺寸
    CGSize maxSize = CGSizeMake(self.width - spaceing * 2,self.height * 2);
    
    return  [self.descLabel.text boundingRectWithSize:maxSize
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:self.descLabel.font}
                                              context:nil].size.height;
}

//- (UIButton *)openUpBtn {
//    if (!_openUpBtn) {
//
//        UIButton *openUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//
////        openUpBtn.titleLabel.font = [UIFont systemFontOfSize:10];
////
////        openUpBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
////        openUpBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
//
////        [openUpBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//
////        [openUpBtn setTitle:@"全部" forState:UIControlStateNormal];
////        [openUpBtn setTitle:@"收起" forState:UIControlStateSelected];
//        [openUpBtn setImage:[UIImage imageNamed:@"wordsDetail_open"] forState:UIControlStateNormal];
//        [openUpBtn setImage:[UIImage imageNamed:@"wordsDetail_close"] forState:UIControlStateSelected];
//
//        [openUpBtn addTarget:self action:@selector(openOrClose:) forControlEvents:UIControlEventTouchUpInside];
//
//        [self addSubview:openUpBtn];
//
//        [openUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.wordLabel.mas_bottom);
//            make.top.equalTo(self.wordLabel.mas_top);
//            make.right.equalTo(self).offset(-8);
//            make.width.height.mas_equalTo(30);
//        }];
//        _openUpBtn = openUpBtn;
//    }
//    return _openUpBtn;
//}
//开关状态
- (void)openOrClose:(UIButton *)btn {
    btn.selected = !btn.selected;
    
    if (self.needReloadHeight) {
        self.descLabel.numberOfLines = btn.selected ? 0 : 2;
        self.needReloadHeight();
    }
}
@end
