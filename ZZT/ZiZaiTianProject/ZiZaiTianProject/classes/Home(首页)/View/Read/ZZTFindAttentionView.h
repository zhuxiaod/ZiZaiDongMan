//
//  ZZTFindAttentionView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/8.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^gotoUserViewBlock) (void);

@interface ZZTFindAttentionView : UITableViewHeaderFooterView

@property (nonatomic,strong) UserInfo *model;

@property (nonatomic,copy) gotoUserViewBlock gotoViewBlock;


@end
