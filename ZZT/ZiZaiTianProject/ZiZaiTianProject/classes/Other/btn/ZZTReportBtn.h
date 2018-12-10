//
//  ZZTReportBtn.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/7.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTMyZoneModel;
@class ZZTCircleModel;

@protocol ZZTReportBtnDelegate <NSObject>

@optional

-(void)shieldingMessage:(NSInteger)index;

@end

@interface ZZTReportBtn : UIButton

@property(nonatomic,weak)id<ZZTReportBtnDelegate>   delegate;

@property (nonatomic,strong)ZZTMyZoneModel *zoneModel;

@property (nonatomic,strong)ZZTCircleModel *circleModel;

@end
