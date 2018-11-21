//
//  ZZTSearchCartoonCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/20.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTCarttonDetailModel;

@interface ZZTSearchCartoonCell : UITableViewCell

@property (nonatomic,strong) ZZTCarttonDetailModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
