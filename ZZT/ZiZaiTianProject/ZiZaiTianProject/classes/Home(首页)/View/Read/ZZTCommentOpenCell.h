//
//  ZZTCommentOpenCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/6.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^openBtnBlock) (void);

@interface ZZTCommentOpenCell : UITableViewCell

@property (nonatomic, copy) void (^ openBtnBlock)(void);

@property (nonatomic,assign) NSInteger cellNum;

@end
