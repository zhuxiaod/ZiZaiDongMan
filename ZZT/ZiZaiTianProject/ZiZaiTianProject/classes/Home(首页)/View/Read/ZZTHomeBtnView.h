//
//  ZZTHomeBtnView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/12.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZTHomeBtnView : UICollectionReusableView

@property (nonatomic,copy) void (^homeBtnClick)(UIButton *btn);

@end
