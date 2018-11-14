//
//  ZZTLikeCollectShareHeaderView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/1.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTStoryModel;

typedef void (^likeBtnBlock) (void);

typedef void (^collectBtnBlock) (void);

@interface ZZTLikeCollectShareHeaderView : UITableViewHeaderFooterView

@property (nonatomic,strong) ZZTStoryModel *likeModel;

@property (nonatomic,strong) ZZTCarttonDetailModel *collectModel;

@property (nonatomic,strong) UIButton *collectBtn;

@property (nonatomic,strong) UIButton *shareBtn;

@property (nonatomic, copy) void (^ likeBtnBlock)(void);

@property (nonatomic, copy) void (^ collectBtnBlock)(void);


@end
