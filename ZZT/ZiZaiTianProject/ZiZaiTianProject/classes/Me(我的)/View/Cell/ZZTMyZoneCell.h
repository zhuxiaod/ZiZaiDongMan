//
//  ZZTMyZoneCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTStatusViewModel;

@interface ZZTMyZoneCell : UITableViewCell


@property (nonatomic,strong) ZZTStatusViewModel *model;

@property (weak, nonatomic) IBOutlet ZZTReportBtn *reportBtn;


@property (nonatomic,strong) void(^reloadDataBlock)(void);

@property (nonatomic,strong) void(^longPressBlock)(ZZTStatusViewModel *model);



+ (ZZTMyZoneCell *)dynamicCellWithTable:(UITableView *)table;

@end
