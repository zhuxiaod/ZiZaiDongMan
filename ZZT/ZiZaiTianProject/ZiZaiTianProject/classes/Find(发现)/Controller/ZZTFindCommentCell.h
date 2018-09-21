//
//  ZZTFindCommentCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/29.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTMyZoneModel;

@interface ZZTFindCommentCell : UITableViewCell

@property (nonatomic,strong) ZZTMyZoneModel *model;

+ (CGFloat)cellHeightWithStr:(NSString *)str imgs:(NSArray *)imgs;

+ (ZZTFindCommentCell *)dynamicCellWithTable:(UITableView *)table;

@end
