//
//  ZZTStatusCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/6.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTCircleModel;

@protocol ZZTStatusCellDelegate <NSObject>

-(void)longPressDeleteReply:(ZZTCircleModel *)model;

@end


static NSString * const statusCellReuseIdentifier = @"StatusCell";

static NSString * const statusHeaderReuseIdentifier = @"StatusHeader";

static NSString * const statusOpenReuseIdentifier = @"StatusOpen";


@interface ZZTStatusCell : UITableViewHeaderFooterView

@property (nonatomic, weak) id <ZZTStatusCellDelegate> delegate;

@property (nonatomic,strong) ZZTCircleModel *model;

@property (nonatomic,copy) void (^needReloadHeight)(void);

- (CGFloat)myHeight;


@end
