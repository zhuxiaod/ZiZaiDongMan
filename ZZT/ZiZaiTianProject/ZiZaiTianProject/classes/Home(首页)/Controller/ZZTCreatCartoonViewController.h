//
//  ZZTCreatCartoonViewController.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/20.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZTCreationEntranceModel;
@class ZZTCarttonDetailModel;

@interface ZZTCreatCartoonViewController : BaseViewController

@property (nonatomic,strong) ZZTCreationEntranceModel *model;

@property (nonatomic,strong) ZZTCarttonDetailModel *creationData;

@end
