//
//  ZZTVisitorPurchaseView.h
//  ZiZaiTianProject
//
//  Created by mac on 2019/1/8.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZTVisitorPurchaseView : UIAlertController

+ (instancetype)initVisitorPurchaseViewWithLogin:(void (^)(void))login visPurchase:(void (^)(void))visPurchase;

- (void)showVPAlert;

@end
