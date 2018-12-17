//
//  ZZTCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/6/26.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZTCell : NSObject

@property (nonatomic ,copy)NSString *cellTitle;

@property (nonatomic ,copy)NSString *cellDetail;
//价格属性
@property (nonatomic ,copy) NSString *chapterMoney;

@property (nonatomic ,copy) NSString *id;

+(instancetype)initCellModelWithTitle:(NSString *)cellTitle cellDetail:(NSString *)cellDetail;


+(instancetype)initPriceItemModelWithChapterMoney:(NSString *)chapterMoney id:(NSString *)id;

@end
