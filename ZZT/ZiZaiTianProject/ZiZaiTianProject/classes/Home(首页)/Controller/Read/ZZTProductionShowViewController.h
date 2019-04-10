//
//  ZZTProductionShowViewController.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/21.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTHomeTableViewModel;

@interface ZZTProductionShowViewController : BaseViewController

@property (nonatomic,strong) NSArray *array;

@property (nonatomic,strong) NSString *viewTitle;

@property (nonatomic,strong) ZZTHomeTableViewModel *model;

@end
