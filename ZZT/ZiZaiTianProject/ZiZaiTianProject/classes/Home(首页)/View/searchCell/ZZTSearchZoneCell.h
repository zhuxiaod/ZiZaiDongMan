//
//  ZZTSearchZoneCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/20.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZTSearchZoneCell : UITableViewCell

@property (nonatomic, strong) UserInfo *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
