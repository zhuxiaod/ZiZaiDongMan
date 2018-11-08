//
//  AttentionButton.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/8.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttentionButton : UIButton

@property (nonatomic) BOOL isAttention;                  //当前状态

@property (nonatomic,copy) NSString *requestID;     //点赞请求ID

@property (nonatomic,copy) void (^onClick)(AttentionButton *btn);

@end
