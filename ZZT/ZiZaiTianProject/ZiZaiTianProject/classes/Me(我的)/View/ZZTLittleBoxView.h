//
//  ZZTLittleBoxView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/13.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LittleBoxBlock) (BOOL isSelect);

@interface ZZTLittleBoxView : UIView

@property (nonatomic,strong) UIButton *button;

@property (nonatomic,assign) BOOL isSelect;

@property (nonatomic,copy) LittleBoxBlock LittleBoxBlock;

@end
