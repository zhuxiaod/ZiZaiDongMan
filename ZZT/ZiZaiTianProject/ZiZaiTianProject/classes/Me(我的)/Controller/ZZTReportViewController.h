//
//  ZZTReportViewController.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/3.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTReportModel.h"

@class ZZTMyZoneModel;
@class ZZTCircleModel;

@interface ZZTReportViewController : BaseViewController

@property (nonatomic,strong) ZZTMyZoneModel *reportData;

@property (nonatomic,strong) ZZTCircleModel *replyData;

@property (nonatomic,strong) ZZTReportModel *model;

@end
