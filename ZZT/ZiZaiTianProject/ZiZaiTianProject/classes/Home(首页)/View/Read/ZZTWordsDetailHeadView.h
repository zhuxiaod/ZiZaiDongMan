//
//  ZZTWordsDetailHeadView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/11.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTWordsDetailModel.h"
#import "ZZTCarttonDetailModel.h"

#define wordsDetailHeadViewHeight  250

@interface ZZTWordsDetailHeadView : UIView

typedef void(^ButtonClick)(ZZTCarttonDetailModel * detailModel);

@property (nonatomic,copy) ButtonClick buttonAction;

@property (nonatomic,strong) ZZTCarttonDetailModel *detailModel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;


+ (instancetype)wordsDetailHeadViewWithFrame:(CGRect)frame scorllView:(UIScrollView *)sc;




@end
