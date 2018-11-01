//
//  ZZTLikeCollectShareHeaderView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/1.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTStoryModel;

typedef void (^centerBtnBlock) (void);

@interface ZZTLikeCollectShareHeaderView : UITableViewHeaderFooterView

@property (nonatomic,strong) ZZTStoryModel *likeModel;


@property (nonatomic,strong) UIButton *collectBtn;

@property (nonatomic,strong) UIButton *shareBtn;

@property (nonatomic, copy) void (^ centerBtnBlock)(void);

@end
