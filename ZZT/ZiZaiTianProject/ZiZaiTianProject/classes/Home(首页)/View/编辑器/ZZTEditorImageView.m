//
//  ZZTEditorImageView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/26.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTEditorImageView.h"

@interface ZZTEditorImageView()<ZZTEditorBasisViewDelegate>

@property(nonatomic,strong) UIImageView *imageView;

@end

@implementation ZZTEditorImageView

-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        //添加UI
        [self addUI];
        
        self.delegate = self;
        
    }
    return self;
}

//这个View被点击了
-(void)setupViewForCurrentView:(ZZTEditorBasisView *)view{
    //将这个View传出去  告诉桌面是哪一个View
    if (self.imageViewDelegate && [self.imageViewDelegate respondsToSelector:@selector(sendCurrentViewToDeskView:)])
    {
        // 调用代理方法
        [self.imageViewDelegate sendCurrentViewToDeskView:self];
    }
    
}

-(void)addUI{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = NO;
    _imageView = imageView;
    [self addSubview:imageView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self);
    }];
}

-(void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint redBtnPoint = [self convertPoint:point toView:self.imageView];
    if ([self.imageView pointInside:redBtnPoint withEvent:event]) {
        return self;
    }
    //如果希望严谨一点，可以将上面if语句及里面代码替换成如下代码
    //UIView *view = [_redButton hitTest: redBtnPoint withEvent: event];
    //if (view) return view;
    return [super hitTest:point withEvent:event];
}

@end
