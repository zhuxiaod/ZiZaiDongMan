//
//  ScreenShotManager.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/4/12.
//  Copyright © 2019 ZiZaiTian. All rights reserved.
//

#import "ScreenShotManager.h"
#import "TJLongImgCut.h"

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

-(void)screenShotAndShare:(UITableView *)tableView lbCover:(NSString *)lbCover{
    UIImage *imageView = [[TJLongImgCut manager] screenShotForTableView:tableView screenRect:UIEdgeInsetsMake(0, 0, 88, 40) imageKB:1024 * 10];//获取图片小于等于1M
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"imageView.png"];
    //    NSLog(@"filePath%@",filePath);
    [UIImagePNGRepresentation(imageView) writeToFile:filePath atomically:YES];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        __weak typeof(self) ws = self;

        [ws shareTextToPlatform:platformType lbCover:lbCover];
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
