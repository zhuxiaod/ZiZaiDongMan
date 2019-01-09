//
//  ZZTEditorImageView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/26.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTEditorImageView.h"

@interface ZZTEditorImageView()<ZZTEditorBasisViewDelegate>

@property(nonatomic,strong) UILabel *textLab;

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
    _closeImageView.hidden = NO;
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
        make.top.right.equalTo(self);
        make.height.width.mas_equalTo(20);
    }];
}



/*---------------------文本----------------------*/

-(void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
//    [self.imageView setImage:[UIImage imageNamed:@"临时对话框"]];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    CGPoint redBtnPoint = [self convertPoint:point toView:self.imageView];
//    if ([self.imageView pointInside:redBtnPoint withEvent:event]) {
//        return self;
//    }
//
    return [super hitTest:point withEvent:event];
}

-(void)setType:(Editor_ImageViewType)type{
    _type = type;
    if(type == editorImageViewTypeChat){
        //点击可以添加文字
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editorText)];
        [self addGestureRecognizer:tapGesture];
        
        //添加显示文字的lab
        UILabel *textLab = [[UILabel alloc] init];
        textLab.numberOfLines = 0;
        textLab.font = [UIFont systemFontOfSize:12];
        _textLab = textLab;
        [self addSubview:textLab];
        
        [textLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(15);
            make.right.bottom.equalTo(self).offset(-15);
        }];
    }
}

#pragma mark - 为视图添加文本
-(void)editorText{
    //传到桌面  为当前可以打字的 上去的图片
    //判断状态  被点击时  一直出现输入框
    //如果当前状态为输入状态   那么点击外面一下输入框移除
    //最多打24个字
    //写一个输入框
    NSLog(@"添加文本添加文本添加文本添加文本添加文本添加文本添加文本");
    if (self.imageViewDelegate && [self.imageViewDelegate respondsToSelector:@selector(showInputViewWithEditorImageView:)])
    {
        // 调用代理方法
        [self.imageViewDelegate showInputViewWithEditorImageView:self];
    }
}

-(void)setInputText:(NSString *)inputText{
    _inputText = inputText;
    _textLab.text = inputText;
}

#pragma mark - 旁白


@end
