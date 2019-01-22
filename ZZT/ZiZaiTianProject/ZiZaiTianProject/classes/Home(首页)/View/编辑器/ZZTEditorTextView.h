//
//  ZZTEditorTextView.h
//  ZiZaiTianProject
//
//  Created by mac on 2019/1/9.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, editorTextViewType) {
    editorTextViewTypeBGClear = 0,//背景透明
    editorTextViewTypeBGWhite = 1,//背景不透明
    editorTextViewTypeNoBoder = 2 //无边框
};

@class ZZTEditorBasisView;
@class ZZTEditorTextView;

@protocol ZZTEditorTextViewDelegate <NSObject>

@optional

-(void)textViewShowInputView:(ZZTEditorTextView *)textView;

-(void)textViewForCurrentView:(ZZTEditorBasisView *)textView;

@end

@interface ZZTEditorTextView : ZZTEditorBasisView

@property (nonatomic,assign) editorTextViewType type;

@property (nonatomic,weak)id<ZZTEditorTextViewDelegate> textViewDelegate;

@property (nonatomic,strong) NSString *inputText;

@property (nonatomic,assign) CGFloat fontSize;

@property (nonatomic,strong) UIButton *closeImageView;

@property (nonatomic,strong) NSString *fontColor;

@property (nonatomic,strong) NSString *imageUrl;

@end
