//
//  ZZTInputView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/27.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMInputView.h"

@class ZZTEditorImageView;

@interface ZZTInputView : UIView

@property (nonatomic,strong) UIButton *publishBtn;

@property (nonatomic,strong) CMInputView *textView;

@property (nonatomic,strong) ZZTEditorImageView *curImageView;


@end
