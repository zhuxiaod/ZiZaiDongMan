//
//  AppDelegate.m
//  ZiZaiTianProject
//
//  Created by zxd on 2018/6/24.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "AppDelegate.h"
#import "ZZTNavigationViewController.h"
#import "ZZTHomeViewController.h"
#import "ZZTTabBarViewController.h"
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import <UMPush/UMessage.h>
#import <UserNotifications/UserNotifications.h>
#import <UMCommonLog/UMCommonLogManager.h>

#import <UMShare/UMShare.h>
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UMCommonLogManager setUpUMCommonLogManager];
    [UMConfigure setLogEnabled:YES];
    //5ba096a35b5a55a35f0001bb
    [MobClick setCrashReportEnabled:YES];
    [UMConfigure initWithAppkey:@"5ba096a35b5a55a35f0001bb" channel:@"App Store"];
    [MobClick setScenarioType:E_UM_GAME|E_UM_DPLUS];
    
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    UMessageRegisterEntity *entity = [[UMessageRegisterEntity alloc] init];
    entity.types = UMessageAuthorizationOptionAlert | UMessageAuthorizationOptionBadge | UMessageAuthorizationOptionSound;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if(granted){
            
        }else{
            
        }
    }];
    
    //1.创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //2.设置窗口根控制器
    ZZTTabBarViewController *tabBarVC = [[ZZTTabBarViewController alloc]init];
//    RTRootNavigationController *tabBarVC = [[RTRootNavigationController alloc]init];

    self.window.rootViewController = tabBarVC;
    
    //3.显示窗口
    [self.window makeKeyAndVisible];

    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx2fbe30919aa330fb" appSecret:@"b99a31c9ef09687175f5f1c13e768853" redirectURL:nil];
//     1107782397
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1107782397" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"2702055855" appSecret:@"3c88b3d25a1cdbcc0d5807a010c9b908" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    return YES;
}

void uncaughtExceptionHandler(NSException *exception) {
    
    NSLog(@"reason: %@", exception);
    
    // Internal error reporting
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(nonnull UNNotification *)notification withCompletionHandler:(nonnull void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary *userinfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]){
        [UMessage setAutoAlert:NO];
        [UMessage didReceiveRemoteNotification:userinfo];
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(nonnull UNNotificationResponse *)response withCompletionHandler:(nonnull void (^)(void))completionHandler{
    NSDictionary *userinfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]){
        [UMessage didReceiveRemoteNotification:userinfo];
    }
}
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}


@end