//
//  ZZTChapterVipItemModel.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/10.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTChapterVipItemModel.h"

@implementation ZZTChapterVipItemModel

+(instancetype)initWithItemStr:(NSString *)itemStr discount:(NSString *)discount buyChapterNum:(NSInteger)buyChapterNum{
    ZZTChapterVipItemModel *model = [[ZZTChapterVipItemModel alloc] init];
    model.ItemStr = itemStr;
    model.discount = discount;
    model.buyChapterNum = buyChapterNum;
    return model;
}
@end
