//
//  ZZTChapterPriceModel.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/17.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTChapterPriceModel.h"

@implementation ZZTChapterPriceModel

+(instancetype)initPriceItemModelWithChapterMoney:(NSString *)chapterMoney id:(NSString *)id{
    ZZTChapterPriceModel *priceItemModel = [[ZZTChapterPriceModel alloc] init];
    priceItemModel.chapterMoney = chapterMoney;
    priceItemModel.id = id;
    return priceItemModel;
}

@end
