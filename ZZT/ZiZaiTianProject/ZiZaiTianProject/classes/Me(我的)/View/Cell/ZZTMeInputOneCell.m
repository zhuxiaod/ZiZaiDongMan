//
//  ZZTMeInputOneCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/12.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTMeInputOneCell.h"

@interface ZZTMeInputOneCell ()<UITextViewDelegate>

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
    UITextView *textView = [[UITextView alloc] init];
    self.cellTextView = textView;
    textView.delegate = self;
    [self addSubview:textView];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:18], NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.typingAttributes = attributes;
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
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:self.placeHolderStr]) {
        self.cellTextView.text = @"";
        self.cellTextView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.cellTextView.text = self.placeHolderStr;
        self.cellTextView.textColor = [UIColor lightGrayColor];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 200) { // 限制5000字内
        textView.text = [textView.text substringToIndex:200];
    }
    static CGFloat maxHeight = 36 + 24 * 3;//初始高度为36，每增加一行，高度增加24
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height >= maxHeight) {
        size.height = maxHeight;
        textView.scrollEnabled = YES;   // 允许滚动
    } else {
        textView.scrollEnabled = NO;    // 不允许滚动
    }
    
//    if ((ceil(size.height) + 14) != self.kInputHeight) {
//        CGPoint offset = self.nowTableView.contentOffset;
//        CGFloat delta = ceil(size.height) + 14 - self.kInputHeight;
//        offset.y += delta;
//        if (offset.y < 0) {
//            offset.y = 0;
//        }
//        [self.nowTableView setContentOffset:offset animated:NO];
//        self.kInputHeight = ceil(size.height) + 14;
//        [self.kInputView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@(ceil(size.height) + 14));
//        }];
//    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if ([text isEqualToString:@"\n"]){
//        //大于0 才能发送信息
//        if (self.kTextView.text.length > 0) {     // send Text
//            //            [self sendMessage:self.kTextView.text];
//        }
//        [self.kInputView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@50);
//        }];
//        [self.kTextView setText:@""];
//        self.kInputHeight = 50;
//        return NO;
//    }
    return YES;
}



@end
