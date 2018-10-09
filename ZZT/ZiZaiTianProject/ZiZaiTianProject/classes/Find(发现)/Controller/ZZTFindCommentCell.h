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
typedef void (^ReValueBlock) (ZZTFindCommentCell *cell,ZZTMyZoneModel *model,BOOL yesOrNo);

@interface ZZTFindCommentCell : UITableViewCell

@property (nonatomic,strong) ZZTMyZoneModel *model;

@property (nonatomic,copy) ReValueBlock btnBlock;

+ (CGFloat)cellHeightWithStr:(NSString *)str imgs:(NSArray *)imgs;

+ (ZZTFindCommentCell *)dynamicCellWithTable:(UITableView *)table;

@end
