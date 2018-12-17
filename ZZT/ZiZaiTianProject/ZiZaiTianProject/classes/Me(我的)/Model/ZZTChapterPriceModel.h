//
//  ZZTChapterPriceModel.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/17.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZTChapterPriceModel : NSObject

//价格属性
@property (nonatomic ,copy) NSString *chapterMoney;

@property (nonatomic ,copy) NSString *id;

+(instancetype)initChapterPriceModelWithTitle:(NSString *)chapterMoney cellDetail:(NSString *)id;

@end
