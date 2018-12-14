//
//  ZZTCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/6/26.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTCell.h"

@implementation ZZTCell

+(instancetype)initCellModelWithTitle:(NSString *)cellTitle cellDetail:(NSString *)cellDetail{
    ZZTCell *cell = [[ZZTCell alloc] init];
    cell.cellTitle = cellTitle;
    cell.cellDetail = cellDetail;
    return cell;
}
@end
