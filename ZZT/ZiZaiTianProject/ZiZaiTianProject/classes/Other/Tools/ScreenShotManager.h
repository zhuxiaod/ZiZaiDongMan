//
//  ScreenShotManager.h
//  ZiZaiTianProject
//
//  Created by mac on 2019/4/12.
//  Copyright © 2019 ZiZaiTian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScreenShotManager : NSObject

+(instancetype)manager;

-(void)openSharePlatformWithbookDetail:(ZZTCarttonDetailModel *)bookDetail;

-(void)shareTextToPlatform:(UMSocialPlatformType)plaform bookDetail:(ZZTCarttonDetailModel *)bookDetail;

@end

NS_ASSUME_NONNULL_END
