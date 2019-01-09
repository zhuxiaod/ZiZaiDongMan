//
//  ZZTSquareRoundView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/28.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

//定义枚举类型
//typedef enum ZZTSquareRoundViewType {NSInteger,
//    squareRoundViewTypeSquare  = 0,
//    squareRoundViewTypeRound
//
//} squareRoundViewType;


typedef NS_ENUM(NSInteger, squareRoundViewType) {
    squareRoundViewTypeSquare = 1,
    squareRoundViewTypeRound = 2
   
};

@class ZZTSquareRoundView;

@protocol ZZTSquareRoundViewDelegate <NSObject>

@optional

//将要被编辑
- (void)squareRoundViewWillEditorWithView:(ZZTSquareRoundView *)squareRoundView;
//编辑完成
- (void)squareRoundViewDidEditorWithView:(ZZTSquareRoundView *)squareRoundView;


@end

//变大缩小 处理
@class ZZTEditorBasisView;

@interface ZZTSquareRoundView : ZZTEditorBasisView

@property (nonatomic,assign) squareRoundViewType type;
//是否放大
@property (nonatomic,assign) BOOL isBig;

@property(nonatomic,weak)id<ZZTSquareRoundViewDelegate>   squareRounddelegate;

@property (nonatomic,strong) UIImageView *rightOne;//右上

@property (nonatomic,strong) ZZTEditorBasisView *currentView;


-(void)tapGestureTarget;

-(void)Editor_addSubView:(UIView *)view;

-(void)editorBtnHidden:(BOOL)isHidden;

-(void)SquareRound_moveCurrentImageViewToLastLayer;

-(void)SquareRound_moveCurrentImageViewToNextLayer;

@end
