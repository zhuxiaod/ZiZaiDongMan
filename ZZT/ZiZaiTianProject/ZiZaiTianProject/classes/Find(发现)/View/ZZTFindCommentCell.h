//
//  ZZTFindCommentCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/29.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTMyZoneModel;
@class ZZTFindCommentCell;

typedef void (^ReValueBlock) (void);

typedef void (^LongPressBlock) (ZZTMyZoneModel *message);


@interface ZZTFindCommentCell : UITableViewCell

@property (nonatomic,strong) ZZTMyZoneModel *model;

@property (nonatomic,copy) ReValueBlock btnBlock;

@property (nonatomic,copy) LongPressBlock LongPressBlock;

//举报
@property (strong, nonatomic) ZZTReportBtn *reportBtn;

+ (ZZTFindCommentCell *)dynamicCellWithTable:(UITableView *)table;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
