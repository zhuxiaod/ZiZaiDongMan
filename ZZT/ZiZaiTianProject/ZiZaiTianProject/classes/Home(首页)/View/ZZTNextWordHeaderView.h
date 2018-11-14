//
//  ZZTNextWordHeaderView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/10/22.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXDCartoonFlexoBtn.h"
#import "ImageLeftBtn.h"
@class ZZTChapterlistModel;

@class ZZTStoryModel;

typedef void (^centerBtnBlock) (void);

@interface ZZTNextWordHeaderView : UITableViewHeaderFooterView

//@property (nonatomic,strong) ZXDCartoonFlexoBtn *centerBtn;

//@property (nonatomic,strong) ImageLeftBtn *liftBtn;

//@property (nonatomic,strong) TypeButton *rightBtn;

@property (nonatomic,strong) UIButton *leftBtn;

@property (nonatomic,strong) UIButton *rightBtn;

@property (nonatomic,strong) ZZTStoryModel *likeModel;

@property (nonatomic,strong) centerBtnBlock block;

//总数
@property (nonatomic,assign) NSInteger listTotal;
//当前章节model
@property (nonatomic,assign) ZZTChapterlistModel *chapterModel;

//@property (nonatomic, copy) void (^ centerBtnBlock)(void);

@end
