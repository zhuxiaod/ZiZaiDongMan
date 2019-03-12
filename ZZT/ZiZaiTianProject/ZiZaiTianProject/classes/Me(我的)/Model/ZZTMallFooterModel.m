//
//  ZZTMallFooterModel.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/3/7.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import "ZZTMallFooterModel.h"

@implementation ZZTMallFooterModel

+(instancetype)initWithPageNum:(NSInteger)pageNum footerUrl:(NSString *)footerUrl footerArray:(NSArray *)footerArray{
    ZZTMallFooterModel *model = [[ZZTMallFooterModel alloc] init];
    model.pageNum = pageNum;
    model.footerUrl = footerUrl;
    model.footerArray = footerArray;
    return model;
}


@end
