//
//  ZZTFreeBiModel.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/5.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTFreeBiModel.h"

@implementation ZZTFreeBiModel

+(instancetype)initZZTFreeBiWith:(NSString *)Btype ZZTBSpend:(NSString *)ZZTBSpend btnType:(NSString *)btnType productId:(NSString *)productId{
    ZZTFreeBiModel *freeB = [[ZZTFreeBiModel alloc] init];
    freeB.btnType = btnType;
    freeB.ZZTBtype = Btype;
    freeB.ZZTBSpend = ZZTBSpend;
    freeB.productId = productId;
    return freeB;
}

@end
