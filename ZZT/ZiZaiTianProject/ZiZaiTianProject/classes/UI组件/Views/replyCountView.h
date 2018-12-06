//
//  replyCountView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/6.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface replyCountView : UIButton


@property (nonatomic,copy) void (^onClick)(replyCountView *btn);


@end
