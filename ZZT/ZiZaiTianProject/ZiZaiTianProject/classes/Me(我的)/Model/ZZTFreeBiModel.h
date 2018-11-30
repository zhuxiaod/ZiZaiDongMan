//
//  ZZTFreeBiModel.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/5.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZTFreeBiModel : NSObject

@property (nonatomic,strong) NSString *goodsDetaill;//商品详情

@property (nonatomic,strong) NSString *goodsName;//商品名称

@property (nonatomic,strong) NSString *goodsOrder;//商品编号

@property (nonatomic,assign) NSInteger id;

@property (nonatomic,assign) NSInteger goodsJifen;//商品积分

@property (nonatomic,assign) NSInteger goodsType;//商品类型 1.ZB 2.会员

@property (nonatomic,assign) NSInteger goodsMoney;//商品金额






//+(instancetype)initZZTFreeBiWith:(NSString *)Btype ZZTBSpend:(NSString *)ZZTBSpend btnType:(NSString *)btnType productId:(NSString *)productId;


@end
