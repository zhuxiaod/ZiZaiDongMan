//
//  ZZTChapterChooseView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/10/30.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZTChapterChooseModel;
@class ZZTChapterChooseView;
//代理
@protocol ZZTChapterChooseViewDelegate <NSObject>

-(void)chapterChooseView:(ZZTChapterChooseView *)chapterChooseView didItemWithModel:(ZZTChapterChooseModel *)model;

@end


@interface ZZTChapterChooseView : UITableViewHeaderFooterView

@property (nonatomic,copy) void (^needReloadHeight)(void);

@property (nonatomic, weak) id <ZZTChapterChooseViewDelegate> delegate;

@property (nonatomic,assign) NSInteger total;

- (CGFloat)myHeight;

@end
