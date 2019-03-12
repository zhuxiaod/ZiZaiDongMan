//
//  ZZTCartoonDetailRightBtnView.h
//  ZiZaiTianProject
//
//  Created by mac on 2019/2/25.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^likeBtnBlock) (void);

typedef void (^collectBtnBlock) (void);

typedef void (^attentionBtnBlock) (void);


@interface ZZTCartoonDetailRightBtnView : UIView

@property (nonatomic,strong)ZZTStoryModel *likeModel;

@property (nonatomic,weak) UIButton *rightCollectBtn;

@property (nonatomic,strong) NSString *likeStatus;

@property (nonatomic,strong) NSString *collectStatus;

@property (nonatomic,strong) NSString *attentionStatus;


//@property (nonatomic,strong) NSString *likeStatus;

@property (nonatomic, copy) void (^ likeBtnBlock)(void);

@property (nonatomic, copy) void (^ collectBtnBlock)(NSInteger tag);

@property (nonatomic, copy) void (^ attentionBtnBlock)(void);


@end
