//
//  ZZTChapterVipItemModel.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/10.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZTChapterVipItemModel : NSObject

@property (nonatomic,strong) NSString *ItemStr;

@property (nonatomic,strong) NSString *discount;

@property (nonatomic,assign) NSInteger buyChapterNum;

+(instancetype)initWithItemStr:(NSString *)itemStr discount:(NSString *)discount buyChapterNum:(NSInteger)buyChapterNum;

@end
