//
//  ZZTUserReplyModel.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/10/12.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "customer.h"
@class customer;

@interface ZZTUserReplyModel : NSObject

@property (nonatomic,strong) NSString *contentId;

@property (nonatomic,strong) NSString *content;

@property (nonatomic,strong) customer *replyCustomer;

@property (nonatomic,strong) NSString *id;

@property (nonatomic,assign) NSInteger praiseNum;

@property (nonatomic,strong) NSString *parentCommentId;

@property (nonatomic,strong) NSString *customerId;

@property (nonatomic,strong) NSString *type;

@property (nonatomic,strong) customer *customer;

@property (nonatomic,assign) NSInteger state;

@property (nonatomic,strong) NSString *commentDate;

@end
