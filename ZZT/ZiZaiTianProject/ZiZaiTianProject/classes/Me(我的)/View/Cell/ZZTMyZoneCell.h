//
//  ZZTMyZoneCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTMyZoneModel;

typedef void (^LongPressBlock) (ZZTMyZoneModel *message);

@interface ZZTMyZoneCell : UITableViewCell

@property (nonatomic,copy) LongPressBlock LongPressBlock;

@property (nonatomic,assign) NSInteger indexRow;

@property (nonatomic,strong) ZZTMyZoneModel *model;

@property (nonatomic,copy) void (^update)(void);

+ (ZZTMyZoneCell *)dynamicCellWithTable:(UITableView *)table;

//举报
@property (strong, nonatomic) ZZTReportBtn *reportBtn;

@end
