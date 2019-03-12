
//  ZZTDetailModel.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/24.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTDetailModel.h"

@implementation ZZTDetailModel

+(instancetype)initDetailModelWith:(NSString *)img flag:(NSInteger)flag ifCollect:(NSInteger)ifCollect{
    ZZTDetailModel *model = [[ZZTDetailModel alloc] init];
    model.img = img;
    model.flag = flag;
    model.ifCollect = ifCollect;
    return model;
}

@end
