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
@property (nonatomic,assign)BOOL isFirst;

@end

@implementation ZZTEditorImageView

-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        //添加UI
        [self addUI];
        
        self.delegate = self;
        
        self.type = editorImageViewTypeNormal;
        
        topValue = 0;
        leftValue = 0;
        bottomValue = 0;
        rightValue = 0;
        
        _isFirst = YES;
    }
    return self;
}

//这个View被点击了
-(void)setupViewForCurrentView:(ZZTEditorBasisView *)view{
    //修改Labframe的大小
    NSLog(@"lab:%@",NSStringFromCGRect(self.textLab.frame));
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
    if (self.imageViewDelegate && [self.imageViewDelegate respondsToSelector:@selector(EditorImageViewCannelCurrentView)])
    {
        // 调用代理方法
        [self.imageViewDelegate EditorImageViewCannelCurrentView];
    }
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
        leftValue = 40;
        bottomValue = -46;
        rightValue = -38;
    }else if (type == editorImageViewTypeDialogBox2){
        //2
        topValue = 34;
        leftValue = 44;
        bottomValue = -34;
        rightValue = -44;
    }else if (type == editorImageViewTypeDialogBox4){
        //3
        topValue = 34;
        leftValue = 44;
        bottomValue = -44;
        rightValue = -40;
    }else if(type == editorImageViewTypeDialogBoxCircle){
        //4
        topValue = 44;
        leftValue = 45;
        bottomValue = -38;
        rightValue = -40;
    }else if (type == editorImageViewTypeDialogBox1){
        //5
        topValue = 46;
        leftValue = 46;
        bottomValue = -46;
        rightValue = -46;
    }else if (type == editorImageViewTypeDialogBox5){
        //6
        topValue = 46;
        leftValue = 44;
        bottomValue = -36;
        rightValue = -40;
    }else if (type == editorImageViewTypeDialogBox6){
        //7
        topValue = 36;
        leftValue = 36;
        bottomValue = -36;
        rightValue = -38;
        
    }else if (type == editorImageViewTypeDialogBox7){
        //8
        topValue = 47;
        leftValue = 45;
        bottomValue = -36;
        rightValue = -34;
    }else if (type == editorImageViewTypeDialogBox8){
        //9 从这开始改
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
        topValue = 40;
        leftValue = 40;
        bottomValue = -48;
        rightValue = -40;
    }
    [self setupChatViewFrame];
    
    _textLab.frame = CGRectMake(leftValue, topValue, self.bounds.size.width - leftValue + rightValue, self.bounds.size.height - topValue + bottomValue);
}

-(void)editorBasisViewWithPich:(UIPinchGestureRecognizer *)gesture isPinch:(BOOL)isPicnch{
    if(isPicnch == YES){
        self.textLab.frame = CGRectMake(self.textLab.frame.origin.x * gesture.scale, self.textLab.frame.origin.y * gesture.scale, self.textLab.bounds.size.width * gesture.scale, self.textLab.bounds.size.height * gesture.scale);
    }
}

-(void)setupChatViewFrame{
    //点击可以添加文字
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editorText)];
    
    [self addGestureRecognizer:tapGesture];
    
    //添加显示文字的lab
    UILabel *textLab = [[UILabel alloc] init];
    textLab.numberOfLines = 0;
    
    textLab.font = [UIFont systemFontOfSize:100];

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

//初始化值
-(CGFloat)alpha{
    if(_alpha == 0 && _isFirst == YES){
        _alpha = 0.5;
    }
    return _alpha;
}

-(CGFloat)saturation{
    if(_saturation == 0 && _isFirst == YES){
        _saturation = 1;
    }
    return _saturation;
}

@end
