//
//  MLIAPManager.h
//  MLIAPurchaseManager
//
//  Created by mali on 16/5/14.
//  Copyright © 2016年 mali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol MLIAPManagerDelegate <NSObject>

@optional

- (void)receiveProduct:(SKProduct *)product;

- (void)successedWithReceipt:(NSData *)transactionReceipt transactionId:(NSString *)transactionId;

- (void)failedPurchaseWithError:(NSString *)errorDescripiton;


@end


@interface MLIAPManager : NSObject

@property (nonatomic, assign)id<MLIAPManagerDelegate> delegate;


+ (instancetype)sharedManager;
//通过商品ID发送购买请求
- (BOOL)requestProductWithId:(NSString *)productId;
//购买产品
- (BOOL)purchaseProduct:(SKProduct *)skProduct;
//恢复购买
- (BOOL)restorePurchase;
//刷新收据
- (void)refreshReceipt;
//完成交易
- (void)finishTransaction;

@end




