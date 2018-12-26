//
//  SBIAPManager.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/21.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>


@protocol SBIAPManagerDelegate <NSObject>

- (void)successDonePurchase;

@end

@interface SBIAPManager : NSObject

@property (nonatomic, weak)id<SBIAPManagerDelegate>delegate;

+(instancetype)manager;

/**
 启动工具
 */
- (void)startManager;

/**
 结束工具
 */
- (void)stopManager;

/**
 请求商品列表
 */
- (void)requestProductWithId:(NSString *)productId;

@end
