//
//  ZZTPayTureView.h
//  ZiZaiTianProject
//
//  Created by mac on 2019/2/21.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PayTureBlock)(NSString *zbNum);//给block重命名,方便调用

typedef void (^GotoTopupView)(void);//给block重命名,方便调用

@interface ZZTPayTureView : UIView

@property (nonatomic,strong) NSString *zbNum;

@property (nonatomic, copy) PayTureBlock payTureBlock;//声明一个block属性
@property (nonatomic, copy) GotoTopupView GotoTopupViewBlock;//声明一个block属性

@property (nonatomic,strong) NSString *originalPrice;

+(instancetype)payTureView;

@end
