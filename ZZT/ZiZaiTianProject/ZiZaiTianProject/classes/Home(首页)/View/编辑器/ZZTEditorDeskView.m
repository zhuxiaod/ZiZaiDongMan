//
//  ZZTEditorDeskView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/26.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTEditorDeskView.h"

@interface ZZTEditorDeskView ()

@end

@implementation ZZTEditorDeskView

-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        //添加UI
        [self addUI];
    }
    return self;
}

-(void)addUI{
    
    self.backgroundColor = [UIColor colorWithRed:244 green:244 blue:244 alpha:1];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}

//添加新的视图
-(void)Editor_addSubView:(UIView *)view{
    
    [self addSubview:view];
}

//上一层 -- 普通视图
-(void)Editor_moveCurrentImageViewToLastLayer{
    //得到桌面上的所有View
//    NSArray *array = self.subviews;
    //知道当前view的索引
    NSInteger index = [self getCurrentViewIndex:self.currentView];
    //对换位置
    //判断是不是最后一层
    if(index == self.subviews.count - 1){
        NSLog(@"不能上一层了");
    }else{
        [self exchangeSubviewAtIndex:index withSubviewAtIndex:index + 1];
    }
}

//下一层 -- 普通视图
-(void)Editor_moveCurrentImageViewToNextLayer{
    //得到桌面上的所有View
    //    NSArray *array = self.subviews;
    //知道当前view的索引
    NSInteger index = [self getCurrentViewIndex:self.currentView];
    //对换位置
    //判断是不是最后一层
    if(index == 0){
        NSLog(@"不能下一层了");
    }else{
        [self exchangeSubviewAtIndex:index withSubviewAtIndex:index - 1];
    }
}

-(NSInteger)getCurrentViewIndex:(ZZTEditorBasisView *)view{
    NSInteger index = 0;
    for(NSInteger i = 0; i < self.subviews.count;i++){
        UIView *subview = self.subviews[i];
        ZZTEditorBasisView *currentView = (ZZTEditorBasisView *)subview;
        if (currentView == view) {
            index = i;
        }
    }
    return index;
}

-(void)Editor_removeAllView{
    for(UIView *view in self.subviews){
        view.hidden = YES;
        [view removeFromSuperview];
    }
    self.backgroundColor = [UIColor whiteColor];
    [self layoutIfNeeded];
}

//in every view .m overide those methods
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView * view = [super hitTest:point withEvent:event];
    
    if(view == self){
        //点击了本View
        if (self.delegate && [self.delegate respondsToSelector:@selector(tapEditorDeskView)])
        {
            // 调用代理方法
            [self.delegate tapEditorDeskView];
        }
        return self;
    }
    
    return view;
}

@end
