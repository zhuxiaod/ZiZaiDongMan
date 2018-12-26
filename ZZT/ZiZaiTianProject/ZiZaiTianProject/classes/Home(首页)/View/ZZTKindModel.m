//
//  ZZTKindModel.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/24.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTKindModel.h"

@implementation ZZTKindModel

+(instancetype)initKindModelWith:(NSString *)kindTitle isSelect:(NSString *)isSelect{
    ZZTKindModel *model = [[ZZTKindModel alloc] init];
    model.kindTitle = kindTitle;
    model.isSelect = isSelect;
    return model;
}
@end
