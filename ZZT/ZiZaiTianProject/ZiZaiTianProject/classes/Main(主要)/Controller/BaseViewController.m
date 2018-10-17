//
//  BaseViewController.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/4/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import "BaseViewController.h"
#import "UIBarButtonItem+EXtension.h"
#import "ZZTTabBarViewController.h"
#import "UIView+Extension.h"
#import "CommonMacro.h"
//#import <UMMobClick/MobClick.h>

@interface BaseViewController ()<UINavigationControllerDelegate>

@end

@implementation BaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _statusBarHidden = NO;
        _statusBarStyle  = UIStatusBarStyleDefault;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
}

- (void)setBackItemWithImage:(NSString *)image pressImage:(NSString *)pressImage {
    
    UIBarButtonItem *back = [UIBarButtonItem barButtonItemWithImage:image pressImage:pressImage target:self action:@selector(back)];
    
    [self.navigationItem setLeftBarButtonItem:back];
    
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden {
    if (_statusBarHidden != statusBarHidden) {
        _statusBarHidden = statusBarHidden;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    if (_statusBarStyle != statusBarStyle) {
        _statusBarStyle = statusBarStyle;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)navigationController:(UINavigationController*)navigationController willShowViewController:(UIViewController*)viewController animated:(BOOL)animated {
    if(viewController == self){
        [navigationController setNavigationBarHidden:YES animated:YES];
        
    }else{
        //系统相册继承自 UINavigationController 这个不能隐藏 所有就直接return
        if ([navigationController isKindOfClass:[UIImagePickerController class]]) {
            return;
            
        } //不在本页时，显示真正的navbar
        [navigationController setNavigationBarHidden:NO animated:YES];
        //当不显示本页时，要么就push到下一页，要么就被pop了，那么就将delegate设置为nil，防止出现BAD ACCESS
        //之前将这段代码放在viewDidDisappear和dealloc中，这两种情况可能已经被pop了，self.navigationController为nil，这里采用手动持有navigationController的引用来解决
        if(navigationController.delegate == self){
            //如果delegate是自己才设置为nil，因为viewWillAppear调用的比此方法较早，其他controller如果设置了delegate就可能会被误伤
            navigationController.delegate = nil;
        }
    }
}

- (BOOL)prefersStatusBarHidden {
    return _statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return _statusBarStyle;
}

- (void)hideNavBar:(BOOL)ishide {
    
    _statusBarHidden = ishide;
    [self.navigationController setNavigationBarHidden:ishide animated:YES];
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithWhite:0.95 alpha:1]];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
    
    [super viewWillAppear:animated];

    ZZTTabBarViewController *main = (ZZTTabBarViewController *)self.tabBarController;
    //隐藏TabBar
    [main setHidesBottomBar:self.navigationController.viewControllers.count > 1];
//    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:NSStringFromClass([self class])];
}

@end
