//
//  ZZTTopUpView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/27.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^xuHuaBtnBlock) (UIButton *sender);

@interface ZZTTopUpView : UIView

@property (nonatomic,copy) xuHuaBtnBlock buttonAction;

+(instancetype)TopUpView;

@end
