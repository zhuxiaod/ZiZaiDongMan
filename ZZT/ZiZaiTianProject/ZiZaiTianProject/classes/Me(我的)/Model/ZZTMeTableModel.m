//
//  ZZTMeTableModel.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/2/27.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import "ZZTMeTableModel.h"

@implementation ZZTMeTableModel

+(instancetype)initModelWithTitle:(NSString *)title{
    ZZTMeTableModel *model = [[ZZTMeTableModel alloc] init];
    model.cellTitle = title;
    return model;
}

@end
