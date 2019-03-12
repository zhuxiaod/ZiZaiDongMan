//
//  ZZTMallFooterModel.h
//  ZiZaiTianProject
//
//  Created by mac on 2019/3/7.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZTMallFooterModel : NSObject
//页数
@property (nonatomic,assign) NSInteger pageNum;

//url
@property (nonatomic,strong) NSString *footerUrl;

//数组
@property (nonatomic,strong) NSArray *footerArray;

+(instancetype)initWithPageNum:(NSInteger)pageNum footerUrl:(NSString *)footerUrl footerArray:(NSArray *)footerArray;

@end
