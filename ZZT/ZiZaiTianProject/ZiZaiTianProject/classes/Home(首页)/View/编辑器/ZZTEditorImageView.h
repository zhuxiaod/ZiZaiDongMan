//
//  ZZTEditorImageView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/26.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTEditorBasisView.h"

typedef NS_ENUM(NSInteger, Editor_ImageViewType) {
    
    editorImageViewTypeChat = 0 ,
    
    editorImageViewTypeDialogBox3  ,//九边形  当前0
    
    editorImageViewTypeDialogBox2 ,
    
    editorImageViewTypeDialogBox4 ,
    
    editorImageViewTypeDialogBoxCircle ,
    
    editorImageViewTypeDialogBox1 ,
    
    editorImageViewTypeDialogBox5 ,
    
    editorImageViewTypeDialogBox6 ,
    
    editorImageViewTypeDialogBox7 ,
    
    editorImageViewTypeDialogBox8 ,
    
    editorImageViewTypeDialogBox9 ,
    
    editorImageViewTypeDialogBox10 ,
    
    editorImageViewTypeNormal
    
    
};

@class ZZTEditorImageView;

@protocol ZZTEditorImageViewDelegate <NSObject>

@optional

- (void)sendCurrentViewToDeskView:(ZZTEditorBasisView *)imageView;

- (void)showInputViewWithEditorImageView:(ZZTEditorImageView *)imageView hiddenState:(BOOL)state;

- (void)hiddenInputView;

- (void)EditorImageViewCannelCurrentView;

@end

@class ZZTEditorBasisView;

@interface ZZTEditorImageView : ZZTEditorBasisView
//文本
@property(nonatomic,strong) UILabel *textLab;
//设置数据
@property (nonatomic,strong) NSString *imageUrl;

@property (nonatomic,assign) Editor_ImageViewType type;
//文本框中的文字
@property (nonatomic,copy) NSString *inputText;

@property(nonatomic,weak)id<ZZTEditorImageViewDelegate> imageViewDelegate;

@property(nonatomic,strong) UIImageView *imgView;

@property(nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) NSString *fontColor;

@property (nonatomic,strong) NSString *isLoad;

@property (nonatomic,strong) NSString *imgId;

@property (nonatomic,strong) NSString *ifCollect;

@property (nonatomic,assign) NSInteger fodderId;

@property (nonatomic,strong) NSString *kindIndex;

@property (nonatomic,strong) NSString *modelType;

//亮度 brightness
@property (nonatomic,assign) CGFloat brightness;
//对比度 Contrast
@property (nonatomic,assign) CGFloat contrast;
//饱和度 Saturation
@property (nonatomic,assign) CGFloat saturation;
//透明度
@property (nonatomic,assign) CGFloat alpha;
//色调
@property (nonatomic,assign) CGFloat hue;

@property (nonatomic,strong) NSString *isCollectOpen;

@property (nonatomic,strong) CIImage *originalImg;

-(void)draw;

@end
