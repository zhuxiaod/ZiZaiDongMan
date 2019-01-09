//
//  ZZTLoginRegisterViewController.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/6/27.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^loginCompleteBlock)(void);

@interface ZZTLoginRegisterViewController : BaseViewController

@property (nonatomic, copy) loginCompleteBlock completeBlock;

+ (void)show;

@end
