//
//  ZZTNavBarTitleView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/5.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZTNavBarTitleView : UIView

@property (nonatomic,weak,readonly) UIButton *leftBtn;

@property (nonatomic,weak,readonly) UIButton *rightBtn;

@property (nonatomic,copy) void (^leftBtnOnClick)(UIButton *btn);

@property (nonatomic,copy) void (^rightBtnOnClick)(UIButton *btn);

@property (nonatomic,strong) UIColor *selBtnBackgroundColor;

@property (nonatomic,strong) UIColor *selBtnTextColor;

@property (nonatomic,strong) UIColor *btnBackgroundColor;

@property (nonatomic,strong) UIColor *btnTextColor;

- (void)selectBtn:(UIButton *)btn;


+ (instancetype)defaultTitleView;

- (void)selectBtn:(UIButton *)btn;

@end
