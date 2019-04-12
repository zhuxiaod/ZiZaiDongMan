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

-(void)screenShotAndShare:(UITableView *)tableView lbCover:(NSString *)lbCover;

@end

NS_ASSUME_NONNULL_END
