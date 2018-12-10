//
//  ZZTReportModel.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/7.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTReportModel.h"

@implementation ZZTReportModel

+(ZZTReportModel *)initWithName:(NSString *)name Content:(NSString *)content Index:(NSInteger)index{

    ZZTReportModel *model = [[ZZTReportModel alloc] init];
    model.name = name;
    model.content = content;
    model.index = index;
    return model;
    
}
@end
