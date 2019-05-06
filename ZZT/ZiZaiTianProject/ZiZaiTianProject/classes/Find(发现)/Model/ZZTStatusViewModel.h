//
//  ZZTStatusViewModel.h
//  ZiZaiTianProject
//
//  Created by mac on 2019/4/22.
//  Copyright © 2019 ZiZaiTian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZTStatusViewModel : NSObject

@property (nonatomic, strong) NSString *statusId; /**< 头像URL */

@property (nonatomic, strong) NSString *headImgUrl; /**< 头像URL */

@property (nonatomic, strong) NSString *nickName; /**< 用户名字 */

@property (nonatomic, assign) NSInteger ifConcern; /**< 是否关注 */

@property (nonatomic, strong) NSString *userId; /**< 用户Id */

@property (nonatomic, strong) NSString *content; /**< 内容 */

@property (nonatomic, strong) NSArray *imgArray; /**< 图片数组 */

@property (nonatomic, strong) NSString *dataText; /**< 发布时间 */

@property (nonatomic, strong) NSString *replyCount; /**< 回复数量 */

@property (nonatomic, assign) NSInteger ifPraise; /**< 点赞 */

@property (nonatomic, strong) NSString *praisecount; /**< 点赞数量 */

@property (nonatomic, strong) ZZTMyZoneModel *reportModel; /**< 举报模型 */

@property (nonatomic, assign) BOOL isUser; /**< 是不是用户本人 */

@property (nonatomic, assign) BOOL isVip; /**< 是不是Vip */

@property (nonatomic, assign) NSInteger modelIndex;

@property (nonatomic, strong) NSString *publishtime; /**< 时间戳 */


+(instancetype)initViewModel:(ZZTMyZoneModel *)model;

@end

NS_ASSUME_NONNULL_END
