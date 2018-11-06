//
//  ZZTStatusFooterView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/6.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTCircleModel;

@protocol ZZTStatusFooterViewDelegate <NSObject>

- (void)didClickCommentButton:(ZZTCircleModel *)model;

@end

@interface ZZTStatusFooterView : UITableViewHeaderFooterView

@property (nonatomic, weak) id <ZZTStatusFooterViewDelegate> delegate;

@property (nonatomic,strong) ZZTCircleModel *model;

@end
