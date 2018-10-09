//
//  ZZTCartoonHistoryCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/27.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZTCartoonHistoryCell : UITableViewCell

@property (nonatomic,strong) ZZTCarttonDetailModel *model;
@property (nonatomic,strong) NSString *str;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
+ (CGFloat)cellHeightWithStr:(NSString *)str imgs:(NSArray *)imgs;

@end
