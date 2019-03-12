//
//  ZZTTabBarViewController.h
//  ZiZaiTianProject
//
//  Created by zxd on 2018/6/24.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZZTTabBarViewControllerDelegate<UITabBarControllerDelegate>

// 重写了选中方法，主要处理中间item选中事件
- (void)ZZTTabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
@end

@interface ZZTTabBarViewController : UITabBarController

@property (nonatomic, weak) id<ZZTTabBarViewControllerDelegate> barDelegate;

- (void)setHidesBottomBar:(BOOL)hidesBottomBar;

@end
