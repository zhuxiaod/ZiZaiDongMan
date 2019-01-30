//
//  ZZTEditorBasisView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/26.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTEditorBasisView;

@protocol ZZTEditorBasisViewDelegate <NSObject>

@optional

//将当前View传给桌面
- (void)setupViewForCurrentView:(ZZTEditorBasisView *)view;

- (void)setupTapGesture;

- (void)editorBasisViewWithRotateGesture:(UIRotationGestureRecognizer *)gesture;

- (void)editorBasisViewWithCenter:(ZZTEditorBasisView *)view;

- (void)editorBasisViewWithPich:(UIPinchGestureRecognizer *)gesture isPinch:(BOOL)isPicnch;


@end

@interface ZZTEditorBasisView : UIView

//@property(nonatomic,strong) UIButton *deleteBtn;

@property(nonatomic,weak)id<ZZTEditorBasisViewDelegate>   delegate;

@property(nonatomic,assign) BOOL isImageView;

//禁止旋转
-(void)Editor_BasisViewCloseRotateGesture;

//禁止捏合
-(void)Editor_BasisViewClosePichGesture;

//禁止拖动
-(void)Editor_BasisViewClosePanGesture;

//允许拖动
-(void)Editor_BasisViewAddPanGesture;

@end
