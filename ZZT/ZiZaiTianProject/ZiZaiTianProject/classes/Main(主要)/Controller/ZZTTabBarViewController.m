//
//  ZZTTabBarViewController.m
//  ZiZaiTianProject
//
//  Created by zxd on 2018/6/24.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTTabBarViewController.h"
#import "ZZTHomeViewController.h"
#import "ZZTFindViewController.h"
#import "ZZTMeViewController.h"
#import "ZZTNavigationViewController.h"
#import "UIImage+ZZTimage.h"
//#import "BaseModel.h"
#import "MainTabbar.h"

@interface ZZTTabBarViewController ()

@property (nonatomic,weak) MainTabbar *mainTabbar;

@end

@implementation ZZTTabBarViewController
//
//+(void)load
//{
//    //获取那个类中的UITabBarItem
//    UITabBarItem *item = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[[UIView class]]];
//    //设置按钮选中标题的颜色
//    //创建一个描述文字属性的字典
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    [item setTitleTextAttributes:attrs forState:UIControlStateSelected];
//    
//    //字体只能在正常状态下设置
//    NSMutableDictionary *attrsNor = [NSMutableDictionary dictionary];
//    attrsNor[NSFontAttributeName] = [UIFont systemFontOfSize:20];
//    
//    [item setTitleTextAttributes:attrsNor forState:UIControlStateNormal];
//    [item setTitlePositionAdjustment:UIOffsetMake(0, -10)];
//   
//}

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupItem];
    
    [self setupAllChildViewController];
    
    [self setupAllTittleButton];
    
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
}

#pragma mark - 添加所有子控制器
-(void)setupAllChildViewController
{
    //首页
    ZZTHomeViewController *homeVC = [[ZZTHomeViewController alloc] init];
    ZZTNavigationViewController *nac1 = [[ZZTNavigationViewController alloc] initWithRootViewController:homeVC];
//    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"漫画" image:nil selectedImage:nil];
    [self addChildViewController:nac1];
    
    //发现
    ZZTFindViewController *findVC = [[ZZTFindViewController alloc] init];
    ZZTNavigationViewController *nac2 = [[ZZTNavigationViewController alloc] initWithRootViewController:findVC];
    [self addChildViewController:nac2];
    
    //我的
    ZZTMeViewController *meVC = [[ZZTMeViewController alloc] init];
    ZZTNavigationViewController *nac3 = [[ZZTNavigationViewController alloc] initWithRootViewController:meVC];
    [self addChildViewController:nac3];
}

//设置所有button上的内容
-(void)setupAllTittleButton
{
    //2.2设置tabBar上按钮内容 ->由对应的子控制器
    //0:nav
    UINavigationController *nav = self.childViewControllers[0];
//    nav.tabBarItem.title = @"作品";
    nav.tabBarItem.image = [UIImage imageOriginalWithName:@"tabBar_reader"];
    UIImage *image = [UIImage imageOriginalWithName:@"tabBar_reader_select"];
    nav.tabBarItem.selectedImage = image;
    nav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    //1:nav1
    UINavigationController *nav1 = self.childViewControllers[1];
//    nav1.tabBarItem.title = @"发现";
    nav1.tabBarItem.image = [UIImage imageOriginalWithName:@"tabbar_find"];
    nav1.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabbar_find_select"];
    nav1.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

    //2:nav2
    UINavigationController *nav2 = self.childViewControllers[2];
//    nav2.tabBarItem.title = @"我的";
    nav2.tabBarItem.image = [UIImage imageOriginalWithName:@"me_me"];
    nav2.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"me_me_select"];
    nav2.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

}

- (void)setHidesBottomBar:(BOOL)hidesBottomBar {
    
    if (hidesBottomBar) {
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.mainTabbar setY:SCREEN_HEIGHT];
        }];
        
    }else {
        
        [UIView animateWithDuration:0.25 delay:0.5 usingSpringWithDamping:0.8f initialSpringVelocity:15.0f options:UIViewAnimationOptionTransitionNone animations:^{
            
            [self.mainTabbar setY:SCREEN_HEIGHT - 44];
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

/**
* 设置item属性
*/
- (void)setupItem
{
    // UIControlStateNormal状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    // 文字颜色
    normalAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    // 文字大小
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    // UIControlStateSelected状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    // 文字颜色
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRGB:@"94,80,175"];
    
    // 统一给所有的UITabBarItem设置文字属性
    // 只有后面带有UI_APPEARANCE_SELECTOR的属性或方法, 才可以通过appearance对象来统一设置
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}
@end
