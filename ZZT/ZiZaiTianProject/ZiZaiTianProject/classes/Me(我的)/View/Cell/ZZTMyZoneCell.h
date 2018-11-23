//
//  ZZTMyZoneCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTMyZoneModel;

@interface ZZTMyZoneCell : UITableViewCell

@property (nonatomic,strong) ZZTMyZoneModel *model;

@property (nonatomic,copy) void (^update)(void);

+ (CGFloat)cellHeightWithStr:(NSString *)str imgs:(NSArray *)imgs;

+ (ZZTMyZoneCell *)dynamicCellWithTable:(UITableView *)table;


@end
