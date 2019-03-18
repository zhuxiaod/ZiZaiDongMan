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
#import "ZZTMeHomeViewController.h"
#import "MCTabBar.h"

@interface ZZTTabBarViewController ()<UITabBarControllerDelegate>

@property (nonatomic,weak) MainTabbar *mainTabbar;

@property (nonatomic, strong) MCTabBar *mcTabbar;
//判断是不是第二模块
@property (nonatomic, assign) BOOL isSelectFind;
//发现
@property (nonatomic, strong) UINavigationController *nav1;

@end

@implementation ZZTTabBarViewController

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    //中间的按钮
    [self seatupCenterBar];
    //样式
    [self setupItem];
    
    [self setupAllChildViewController];
    
    [self setupAllTittleButton];
    
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    self.delegate = self;
    
    self.isSelectFind = NO;
}

#pragma mark - 设置中间的tabBar
-(void)seatupCenterBar{
    _mcTabbar = [[MCTabBar alloc] init];
    [_mcTabbar.centerBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    //利用KVC 将自己的tabbar赋给系统tabBar
    [self setValue:_mcTabbar forKeyPath:@"tabBar"];
    self.delegate = self;
    
    //选中时的颜色
    self.mcTabbar.tintColor = [UIColor colorWithRed:251.0/255.0 green:199.0/255.0 blue:115/255.0 alpha:1];
    //透明设置为NO，显示白色，view的高度到tabbar顶部截止，YES的话到底部
    self.mcTabbar.translucent = YES;
    _mcTabbar.centerBtn.hidden = YES;
    self.mcTabbar.position = MCTabBarCenterButtonPositionBulge;
    self.mcTabbar.centerImage = [UIImage imageNamed:@"editorTabbar"];
}

//发现 按钮点击事件
- (void)buttonAction:(UIButton *)button{
    NSInteger count = self.viewControllers.count;
    self.selectedIndex = count/2;//关联中间按钮
    [self tabBarController:self didSelectViewController:self.viewControllers[self.selectedIndex]];
}

// 点击按钮
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    [self showTabbarBtn];

    //进来就是
    _mcTabbar.centerBtn.selected = (tabBarController.selectedIndex == self.viewControllers.count/2);
    
    [self findTarget];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog(@"item:%ld",item.tag);
    self.isSelectFind = NO;
    
    _nav1.tabBarItem.image = [UIImage imageOriginalWithName:@"tabbar_find"];
    
    _mcTabbar.centerBtn.hidden = YES;

    if(item.tag == 0){
        [self showTabbarBtn];
    }
}

-(void)showTabbarBtn{
    _nav1.tabBarItem.image = [UIImage imageOriginalWithName:@""];
    
    _mcTabbar.centerBtn.hidden = NO;
    
//    [self findTarget];

}

-(void)findTarget{
    if(self.isSelectFind){
        //弹出编辑
        NSLog(@"打开编辑器");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addMomentTaget" object:nil];
    }else{
        self.isSelectFind = YES;
    }
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
    ZZTMeHomeViewController *meVC = [[ZZTMeHomeViewController alloc] init];
    ZZTNavigationViewController *nac3 = [[ZZTNavigationViewController alloc] initWithRootViewController:meVC];
    [self addChildViewController:nac3];
    
//    ZZTMeViewController *meVC = [[ZZTMeViewController alloc] init];
//    ZZTNavigationViewController *nac3 = [[ZZTNavigationViewController alloc] initWithRootViewController:meVC];
//    [self addChildViewController:nac3];
}

//设置所有button上的内容
-(void)setupAllTittleButton
{
    //2.2设置tabBar上按钮内容 ->由对应的子控制器
    //0:nav
    UINavigationController *nav = self.childViewControllers[0];
    nav.tabBarItem.tag = 0;

//    nav.tabBarItem.title = @"作品";
    nav.tabBarItem.image = [UIImage imageOriginalWithName:@"tabBar_reader"];
    UIImage *image = [UIImage imageOriginalWithName:@"tabBar_reader_select"];
    nav.tabBarItem.selectedImage = image;
    nav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    //发现 凸起
    UINavigationController *nav1 = self.childViewControllers[1];
    nav.tabBarItem.tag = 1;

//    nav1.tabBarItem.title = @"发现";
    nav1.tabBarItem.image = [UIImage imageOriginalWithName:@"tabbar_find"];
//    nav1.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabbar_find_select"];
    nav1.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    _nav1 = nav1;

    //2:nav2
    UINavigationController *nav2 = self.childViewControllers[2];
    nav2.tabBarItem.tag = 2;
//    nav2.tabBarItem.title = @"我的";
    nav2.tabBarItem.image = [UIImage imageOriginalWithName:@"me_me"];
    nav2.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"me_me_select"];
    nav2.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

}

- (void)setHidesBottomBar:(BOOL)hidesBottomBar {
    
    if (hidesBottomBar) {
        
//        [UIView animateWithDuration:0.25 animations:^{
//            [self.mainTabbar setY:SCREEN_HEIGHT + 44];
//        }];
        self.tabBar.hidden = YES;
    
    }else {
        
        self.tabBar.hidden = NO;

//        [UIView animateWithDuration:0.25 delay:0.5 usingSpringWithDamping:0.8f initialSpringVelocity:15.0f options:UIViewAnimationOptionTransitionNone animations:^{
//
//            [self.mainTabbar setY:SCREEN_HEIGHT - 44];
//
//        } completion:^(BOOL finished) {
//
//        }];
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
