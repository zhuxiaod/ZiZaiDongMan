//
//  ZZTMeInputOneCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/12.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTMeInputOneCell.h"
#import "CMInputView.h"

@interface ZZTMeInputOneCell ()<UITextViewDelegate>

@property (nonatomic,assign) CGFloat kInputHeight;

@property (nonatomic,strong) UIView *bottomView;

@end

@implementation ZZTMeInputOneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    //title
    UILabel *titleLab = [[UILabel alloc] init];
    self.titleLab = titleLab;
    [self addSubview:titleLab];
    
    //介绍信息
    CMInputView *textView = [[CMInputView alloc] init];
    textView.textViewFont = [UIFont systemFontOfSize:18];
//    textView.maxTextNum = 200;
    self.cellTextView = textView;
    textView.maxNumberOfLines = 4;
    textView.placeholderFont = [UIFont systemFontOfSize:18];
    textView.textChangedBlock = ^(NSString *text, CGFloat textHeight) {

        if (self.delegate && [self.delegate respondsToSelector:@selector(changeCellHeight:textHeight:index:)])
        {
            // 调用代理方法
            [self.delegate changeCellHeight:self textHeight:textHeight + 40 index:self.index];
        }
        
    };
    textView.contentChangedBlock = ^(NSString *text) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(contentChange:content:index:)])
        {
            // 调用代理方法
            [self.delegate contentChange:self content:text index:self.index];
        }
    };
    
    [self addSubview:textView];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:18], NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.typingAttributes = attributes;
    
    //bottomView
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
    _bottomView = bottomView;
    [self addSubview:bottomView];
}

- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self);
        make.height.mas_offset(40);
    }];
    
    [self.cellTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom);
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-1);
        make.right.left.equalTo(self);
        make.height.mas_offset(1);
    }];
}

-(void)setPlaceHolderStr:(NSString *)placeHolderStr{
    _placeHolderStr = placeHolderStr;
    self.cellTextView.placeholderColor = [UIColor lightGrayColor];
    self.cellTextView.placeholder = placeHolderStr;
}

- (CGFloat)myHeight {
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    return 40 + self.kInputHeight;
}

-(void)setHiddenBottomView:(BOOL)hiddenBottomView{
    _hiddenBottomView = hiddenBottomView;
    self.bottomView.hidden = YES;
}

@end
