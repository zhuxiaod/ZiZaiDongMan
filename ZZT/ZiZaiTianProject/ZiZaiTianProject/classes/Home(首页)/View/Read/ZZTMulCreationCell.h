//
//  ZZTMulCreationCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/28.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTChapterlistModel;

@interface ZZTMulCreationCell : UITableViewCell

@property (nonatomic,strong) ZZTChapterlistModel *xuHuaModel;

@property (nonatomic,strong) NSString *typeStr;

+(instancetype)mulCreationCellWith:(UITableView *)tableView NSString:(NSString *)string;

@end
