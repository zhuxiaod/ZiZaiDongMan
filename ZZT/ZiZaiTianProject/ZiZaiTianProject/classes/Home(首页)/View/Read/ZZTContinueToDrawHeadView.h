//
//  ZZTContinueToDrawHeadView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/23.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZTCartoonModel;

typedef void (^xuHuaBtnBlock) (UIButton *sender);

@interface ZZTContinueToDrawHeadView : UIView

@property (nonatomic,copy) xuHuaBtnBlock buttonAction;

@property (nonatomic,strong) NSArray *array;

+(instancetype)ContinueToDrawHeadView;

@end
