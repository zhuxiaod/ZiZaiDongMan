//
//  ZZTVisitorPurchaseView.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/1/8.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import "ZZTVisitorPurchaseView.h"

@interface ZZTVisitorPurchaseView ()

@end

@implementation ZZTVisitorPurchaseView

- (void)viewDidLoad {
    [super viewDidLoad];
 
}

+ (instancetype)initVisitorPurchaseViewWithLogin:(void (^)(void))login visPurchase:(void (^)(void))visPurchase
{
    ZZTVisitorPurchaseView *actionSheet = [ZZTVisitorPurchaseView alertControllerWithTitle:@"游客模式说明" message:@"游客模式下购买的会员,仅限当前设备使用,充值时无法享受优惠活动,APP卸载后权益肯能丢失。" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"登录账号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //登录
        if (login != nil) login();

    }];
    
    [action1 setValue:ZZTSubColor forKey:@"_titleTextColor"];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"游客模式购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (visPurchase != nil) visPurchase();
    }];
    [action2 setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    [action4 setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    //    [actionSheet addAction:action3];
    [actionSheet addAction:action4];
    return actionSheet;
}

- (void)showVPAlert
{
    [[self getCurrentVC] presentViewController:self animated:YES completion:nil];
}

//获取当前的VC
-(UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tempWindow in windows)
        {
            if (tempWindow.windowLevel == UIWindowLevelNormal)
            {
                window = tempWindow;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}

@end
