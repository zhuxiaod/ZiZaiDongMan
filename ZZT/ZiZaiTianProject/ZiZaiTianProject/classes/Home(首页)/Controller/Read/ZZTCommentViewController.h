//
//  ZZTCommentViewController.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/5.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTChapterlistModel;

@interface ZZTCommentViewController : BaseViewController

@property (nonatomic,strong) NSString *chapterId;

@property (nonatomic,strong) NSString *cartoonType;

@property (nonatomic,strong) ZZTChapterlistModel *model;
//世界评论页
@property (nonatomic,assign) BOOL isFind;

@property (nonatomic,assign) BOOL hiddenTitleView;

@property (nonatomic,assign) BOOL ishiddenTitleView;

//-(void)hiddenTitleView;

@end
