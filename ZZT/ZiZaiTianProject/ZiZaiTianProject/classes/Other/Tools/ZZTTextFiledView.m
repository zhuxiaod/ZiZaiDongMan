//
//  ZZTTextFiledView.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/4/12.
//  Copyright © 2019 ZiZaiTian. All rights reserved.
//

#import "ZZTTextFiledView.h"
@interface ZZTTextFiledView ()<UITextViewDelegate>


@end

@implementation ZZTTextFiledView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    //创建输入View
    self.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    
    //输入View
    UITextView *kTextView = [GlobalUI initTextViewWithBgColor:[UIColor whiteColor] fontSize:MomentFontSize text:@"赶紧评论秀才华~" textColor:[UIColor grayColor]];
    _kTextView = kTextView;
    kTextView.delegate = self;
    [self addSubview:kTextView];
    
    [kTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@7);
        make.bottom.equalTo(@(-7));
        make.left.equalTo(@7);
        make.right.equalTo(@(-(SCREEN_WIDTH / 5)));
    }];
    
    //发布按钮
    UIButton *publishBtn = [GlobalUI createButtonWithTopImg:nil title:@"发布" titleColor:[UIColor whiteColor]];
    publishBtn.enabled = NO;
    _publishBtn = publishBtn;
    publishBtn.backgroundColor = ZZTSubColor;
    [self addSubview:publishBtn];
    
    [publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@(-0));
        make.left.equalTo(kTextView.mas_right).offset(4);
        make.width.mas_equalTo(SCREEN_WIDTH / 5);
    }];
    
    
}

#pragma mark - UITextViewDelegate
// 1.显示没问题
- (void)textViewDidChange:(UITextView *)textView {
    _publishBtn.enabled = textView.text.length>0? YES : NO;

    if (textView.text.length > 5000) { // 限制5000字内
        textView.text = [textView.text substringToIndex:5000];
    }
    static CGFloat maxHeight = 36 + 24 * 2;//初始高度为36，每增加一行，高度增加24
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height >= maxHeight) {
        size.height = maxHeight;
        textView.scrollEnabled = YES;   // 允许滚动
    } else {
        textView.scrollEnabled = NO;    // 不允许滚动
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {

    if([textView.text isEqualToString:@"赶紧评论秀才华~"]){
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
//    if(self.isReply == NO){
//        self.commentId = @"0";
//    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
//    self.isReply = NO;
    if(textView.text.length < 1){
        textView.text = @"赶紧评论秀才华~";
        textView.textColor = [UIColor grayColor];
    }
}

@end
