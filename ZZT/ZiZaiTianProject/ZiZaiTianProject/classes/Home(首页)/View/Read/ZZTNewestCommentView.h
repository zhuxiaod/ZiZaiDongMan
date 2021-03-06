//
//  ZZTNewestCommentView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/5.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTCircleModel;

@protocol ZZTNewestCommentViewDelegate <NSObject>

-(void)commentView:(UITableView *)tableView sendReply:(ZZTCircleModel *)model;

-(void)commentView:(UITableView *)tableView sendCellReply:(ZZTCircleModel *)model indexRow:(NSInteger)indexRow;

-(void)longPressDeleteComment:(ZZTCircleModel *)circleItem;

-(void)reloadDataCommentView:(UITableView *)commentView;

@end

@interface ZZTNewestCommentView : UITableView

@property (nonatomic, weak) id <ZZTNewestCommentViewDelegate> adelegate;

@property (nonatomic,strong) NSString *chapterId;

@property (nonatomic,assign) NSInteger dataNum;

@property (nonatomic,assign) BOOL isFind;

- (void)update;

- (void)beginHeaderUpdate;

-(void)loadNewFindData;

@end
