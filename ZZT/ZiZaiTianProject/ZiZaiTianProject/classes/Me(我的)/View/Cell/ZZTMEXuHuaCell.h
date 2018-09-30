//
//  ZZTMEXuHuaCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/30.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^xuHuaBtnBlock) (UIButton *sender);

@interface ZZTMEXuHuaCell : UITableViewCell

@property (nonatomic,copy) xuHuaBtnBlock buttonAction;

@end
