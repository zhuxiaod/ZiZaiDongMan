//
//  ZZTEditorImageView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/26.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTEditorImageView.h"

@interface ZZTEditorImageView()<ZZTEditorBasisViewDelegate>{
    CGFloat topValue;
    CGFloat leftValue;
    CGFloat bottomValue;
    CGFloat rightValue;
}


@end

@implementation ZZTEditorImageView

-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        //添加UI
        [self addUI];
        
        self.delegate = self;
        
        self.type = editorImageViewTypeNormal;
    }
    return self;
}

//这个View被点击了
-(void)setupViewForCurrentView:(ZZTEditorBasisView *)view{
    //修改Labframe的大小
    NSLog(@"lab:%@",NSStringFromCGRect(self.textLab.frame));
//    _closeImageView.hidden = NO;
    //将这个View传出去  告诉桌面是哪一个View
    if (self.imageViewDelegate && [self.imageViewDelegate respondsToSelector:@selector(sendCurrentViewToDeskView:)])
    {
        // 调用代理方法
        [self.imageViewDelegate sendCurrentViewToDeskView:self];
    }
}

-(void)addUI{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    _imageView = imageView;
    [self addSubview:imageView];
    
    UIButton *closeImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeImageView setImage:[UIImage imageNamed:@"deletMartarel"] forState:UIControlStateNormal];
    _closeImageView = closeImageView;
    [self addSubview:closeImageView];

    [closeImageView addTarget:self action:@selector(deleteSelf) forControlEvents:UIControlEventTouchUpInside];
}

-(void)deleteSelf{
    [self removeFromSuperview];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self);
    }];
    
    [self.closeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.height.width.mas_equalTo(20);
    }];
}
/*---------------------文本----------------------*/

-(void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

-(void)setType:(Editor_ImageViewType)type{
    _type = type;

    if(type == editorImageViewTypeDialogBox3){
        //1
        topValue = 40;
        leftValue = 54;
        bottomValue = -72;
        rightValue = -36;
    }else if (type == editorImageViewTypeDialogBox2){
        //2
        topValue = 44;
        leftValue = 54;
        bottomValue = -44;
        rightValue = -52;
    }else if (type == editorImageViewTypeDialogBox4){
        //3
        topValue = 82;
        leftValue = 40;
        bottomValue = -74;
        rightValue = -40;
    }else if(type == editorImageViewTypeDialogBoxCircle){
        //4
        topValue = 46;
        leftValue = 46;
        bottomValue = -48;
        rightValue = -46;
    }else if (type == editorImageViewTypeDialogBox1){
        //5
        topValue = 46;
        leftValue = 48;
        bottomValue = -50;
        rightValue = -46;
    }else if (type == editorImageViewTypeDialogBox5){
        //6
        topValue = 66;
        leftValue = 48;
        bottomValue = -50;
        rightValue = -46;
    }else if (type == editorImageViewTypeDialogBox6){
        //7
        topValue = 46;
        leftValue = 38;
        bottomValue = -46;
        rightValue = -36;
        
    }else if (type == editorImageViewTypeDialogBox7){
        //8
        topValue = 50;
        leftValue = 50;
        bottomValue = -55;
        rightValue = -36;
    }else if (type == editorImageViewTypeDialogBox8){
        //9
        topValue = 38;
        leftValue = 60;
        bottomValue = -50;
        rightValue = -46;
    }else if (type == editorImageViewTypeDialogBox9){
        //10
        topValue = 46;
        leftValue = 40;
        bottomValue = -56;
        rightValue = -48;
    }else if (type == editorImageViewTypeDialogBox10){
        //11
        topValue = 30;
        leftValue = 50;
        bottomValue = -38;
        rightValue = -48;
    }
    [self setupChatViewFrame];
    
    _textLab.frame = CGRectMake(leftValue, topValue, self.bounds.size.width - leftValue + rightValue, self.bounds.size.height - topValue + bottomValue);
//
//    CGFloat topValue1 = topValue;
//    CGFloat leftValue1 = leftValue;
//    CGFloat bottomValue1 = bottomValue;
//    CGFloat rightValue1 = rightValue;
    
//    _textLab.frame = CGRectMake(leftValue, topValue, );
//    [_textLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(topValue1);
//        make.left.equalTo(self).offset(leftValue1);
//        make.bottom.equalTo(self).offset(bottomValue1);
//        make.right.equalTo(self).offset(rightValue1);
//    }];
//    _textlab.frame = cgrm;
}

-(void)editorBasisViewWithPich:(UIPinchGestureRecognizer *)gesture{
//    _textLab.frame = CGRectMake(leftValue * gesture.scale, topValue * gesture.scale, self.bounds.size.width - leftValue + rightValue, self.bounds.size.height - topValue + bottomValue);

    self.textLab.transform = CGAffineTransformScale(self.textLab.transform,gesture.scale , gesture.scale);
//    self.textLab.center = self.center;
//    self.textLab.frame = CGRectMake(self.textLab.bounds.origin.x * gesture.scale, self.textLab.bounds.origin.y, self.textLab.bounds.size.width * gesture.scale, self.textLab.bounds.size.height * gesture.scale);

//    //如果是文字框
//    if(self.type != editorImageViewTypeChat && self.type != editorImageViewTypeNormal){
//
//        CGFloat topValue1 = topValue;
//        CGFloat leftValue1 = leftValue;
//        CGFloat bottomValue1 = bottomValue;
//        CGFloat rightValue1 = rightValue;
//
//        NSLog(@"topValue1:%f leftValue1:%f bottomValue1:%f rightValue1:%f  gesture.scale：%f",topValue1,leftValue1,bottomValue1,rightValue1, gesture.scale);
//
//        [_textLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).offset(topValue1 * gesture.scale);
//            make.left.equalTo(self).offset(leftValue1 * gesture.scale);
//            make.bottom.equalTo(self).offset(bottomValue1 * gesture.scale);
//            make.right.equalTo(self).offset(rightValue1 * gesture.scale);
//        }];
//    }
}

-(void)setupChatViewFrame{
    //点击可以添加文字
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editorText)];
    [self addGestureRecognizer:tapGesture];
    
    //添加显示文字的lab
    UILabel *textLab = [[UILabel alloc] init];
    textLab.numberOfLines = 0;
    
    textLab.font = [UIFont systemFontOfSize:40];

    textLab.adjustsFontSizeToFitWidth = YES;

    [textLab setTextAlignment:NSTextAlignmentCenter];
    
    _textLab = textLab;
    
    [self addSubview:textLab];
}

#pragma mark - 为视图添加文本
-(void)editorText{
    //传到桌面  为当前可以打字的 上去的图片
    //判断状态  被点击时  一直出现输入框
    //如果当前状态为输入状态   那么点击外面一下输入框移除
    //最多打24个字
    //写一个输入框
    if(self.type != editorImageViewTypeNormal && self.type != editorImageViewTypeChat){
        if (self.imageViewDelegate && [self.imageViewDelegate respondsToSelector:@selector(showInputViewWithEditorImageView:hiddenState:)])
        {
            // 调用代理方法
            [self.imageViewDelegate showInputViewWithEditorImageView:self hiddenState:NO];
        }
    }else{
        if (self.imageViewDelegate && [self.imageViewDelegate respondsToSelector:@selector(showInputViewWithEditorImageView:hiddenState:)])
        {
            // 调用代理方法
            [self.imageViewDelegate showInputViewWithEditorImageView:self hiddenState:YES];
        }
    }
}

-(void)setInputText:(NSString *)inputText{
    _inputText = inputText;
    
    _textLab.text = inputText;
}

//设置字体颜色
-(void)setFontColor:(NSString *)fontColor{
    _fontColor = fontColor;
    self.textLab.textColor = [UIColor colorWithHexString:fontColor];
}


@end
