//
//  ZZTAlertController.h
//  ZiZaiTianProject
//
//  Created by mac on 2019/4/23.
//  Copyright © 2019 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZTAlertController : UIAlertController

-(void)addDestructiveAction:(NSString *)title handler:(void (^)(void))handler;

-(void)addCancelAction:(NSString *)title handler:(void (^)(void))handler;

-(void)addDefaultAction:(NSString *)title handler:(void (^)(void))handler;

@end

NS_ASSUME_NONNULL_END
