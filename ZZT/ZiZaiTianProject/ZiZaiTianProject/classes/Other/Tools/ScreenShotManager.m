//
//  ScreenShotManager.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/4/12.
//  Copyright © 2019 ZiZaiTian. All rights reserved.
//

#import "ScreenShotManager.h"
#import "TJLongImgCut.h"
#import <UShareUI/UShareUI.h>

@implementation ScreenShotManager

+ (instancetype)manager
{
    static id instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ScreenShotManager alloc] init];
    });

    return instance;
}

-(void)openSharePlatformWithbookDetail:(ZZTCarttonDetailModel *)bookDetail{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self shareTextToPlatform:platformType bookDetail:bookDetail];
    }];
}

//分享
-(void)shareTextToPlatform:(UMSocialPlatformType)plaform bookDetail:(ZZTCarttonDetailModel *)bookDetail{
    
    UIImage *shareBannerImage = [UIImage addImage:@"shareImg" withImage:bookDetail.lbCover];
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    
    [shareObject setShareImage:shareBannerImage];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:plaform messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
        if(error){
            //failed
        }else{
            //success
        }
    }];
}



-(void)shareTextToPlatform:(UMSocialPlatformType)plaform lbCover:(NSString *)lbCover{
    
    UIImage *shareBannerImage = [UIImage addImage:@"shareImg" withImage:lbCover];
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    [shareObject setShareImage:shareBannerImage];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:plaform messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
        if(error){
            //failed
        }else{
            //success
        }
    }];
}
@end
