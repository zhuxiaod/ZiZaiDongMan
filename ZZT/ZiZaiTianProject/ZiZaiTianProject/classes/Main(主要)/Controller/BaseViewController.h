//
//  BaseViewController.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/4/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXDNavBar.h"

@interface BaseViewController : UIViewController<UINavigationControllerDelegate>

@property (nonatomic) BOOL statusBarHidden;

@property (nonatomic,strong) ZXDNavBar *viewNavBar;

@property (nonatomic) UIStatusBarStyle statusBarStyle;

@property (nonatomic,assign) BOOL viewNavBarHidden;

//如果该页面push
-(void)addBackBtn;

//隐藏自定义nav 默认显示
-(void)hiddenViewNavBar;

- (void)setBackItemWithImage:(NSString *)image pressImage:(NSString *)pressImage;

- (void)hideViewNavBar:(BOOL)ishide;

-(void)setupNavigationBarHidden:(BOOL)isHidden;

-(void)setMeNavBarStyle;

@end
