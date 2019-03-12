//
//  ZZTSearchCartoonCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/20.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTCarttonDetailModel;
@class ZZTDetailModel;

@interface ZZTSearchCartoonCell : UITableViewCell

@property (nonatomic,strong) ZZTCarttonDetailModel *model;

@property (nonatomic,strong) ZZTDetailModel *materialModel;

@property (nonatomic,strong) id mModel;


+ (instancetype)cellWithTableView:(UITableView *)tableView identify:(NSString *)identify;

+ (instancetype)materialCellWithTableView:(UITableView *)tableView identify:(NSString *)identify;

@end
