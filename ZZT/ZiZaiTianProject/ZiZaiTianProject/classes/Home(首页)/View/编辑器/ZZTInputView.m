//
//  ZZTInputView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/27.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTInputView.h"
#import "ZZTEditorImageView.h"

@interface ZZTInputView ()<UITextViewDelegate>

@property (nonatomic, assign) CGFloat InputHeight;

@property (nonatomic, assign) NSInteger textMaxNum;

@end

@implementation ZZTInputView

-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        //添加UI
        [self addUI];
        self.InputHeight = 50;
        self.textMaxNum = 999;
    }
    return self;
}

-(void)addUI{
    
    self.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];

    //输入框
    CMInputView *textView = [CMInputView new];
    textView.delegate = self;
    _textView = textView;
    textView.backgroundColor = [UIColor whiteColor];
    textView.textViewFont = [UIFont systemFontOfSize:MomentFontSize];
    textView.maxNumberOfLines = 2;
    textView.placeholderFont = [UIFont systemFontOfSize:MomentFontSize];
    textView.placeholderColor = [UIColor lightGrayColor];
    textView.placeholder = @"请点击输入文字";

    textView.textChangedBlock = ^(NSString *text, CGFloat textHeight) {
        
  
    };
    
    textView.layer.cornerRadius = 5;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    textView.typingAttributes = attributes;
    textView.returnKeyType = UIReturnKeySend;
    textView.delegate = self;
    [self addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@7);
        make.bottom.equalTo(@(-7));
        make.left.equalTo(@7);
        make.right.equalTo(@(-(SCREEN_WIDTH / 5)));
    }];
    
    //发布按钮
    UIButton *publishBtn = [[UIButton alloc] init];
    _publishBtn = publishBtn;
    [publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    [publishBtn setBackgroundColor:ZZTSubColor];
    [publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:publishBtn];
    [publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@(-0));
        make.left.equalTo(textView.mas_right).offset(4);
        make.width.mas_equalTo(SCREEN_WIDTH / 5);
    }];
    
    
    //点击会发生什么事情
//    [publishBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];

}

//输入20个字 文字变为红色  不能继续输入
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //如果是删除减少字数，都返回允许修改
    if ([text isEqualToString:@""]) {
        return YES;
    }
    if (range.location >= self.textMaxNum)
    {
      return NO;
    }
    else
    {
       return YES;
   }
}

-(void)setCurImageView:(ZZTEditorImageView *)curImageView{
    _curImageView = curImageView;
    if(curImageView.type == editorImageViewTypeChat){
//        self.textMaxNum = 19;
    }
}



@end
