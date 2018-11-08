//
//  ZZTCaiNiXiHuanView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/28.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^restartBtnBlock) (UIButton *sender);

@interface ZZTCaiNiXiHuanView : UITableViewHeaderFooterView

@property (nonatomic,copy) restartBtnBlock buttonAction;
//刷新按钮
@property (strong, nonatomic) UIButton *updataBtn;

@property (nonatomic,strong) NSArray *dataArray;

@end
