//
//  ZZTChapterPayViewController.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/30.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZZTChapterPayViewController.h"

@class ZZTChapterlistModel;

@protocol ZZTChapterPayViewDelegate <NSObject>

@optional

- (void)chapterPayViewDismissLastViewController;

@end

@interface ZZTChapterPayViewController : BaseViewController

@property(nonatomic,weak)id<ZZTChapterPayViewDelegate>   delegate;

@property (nonatomic,strong) ZZTChapterlistModel *model;



@end
