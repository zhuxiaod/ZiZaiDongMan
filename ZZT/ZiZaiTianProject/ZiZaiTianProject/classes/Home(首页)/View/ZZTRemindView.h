//
//  ZZTRemindView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/11.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnTureBlock) (UIButton *btn);

typedef void (^ReturnCannelBlock) (UIButton *btn);


@interface ZZTRemindView : UIWindow

@property (nonatomic,copy) ReturnTureBlock tureBlock;

@property (nonatomic,copy) ReturnCannelBlock cannelBlock;


@property (nonatomic,strong) NSString *viewTitle;

+(ZZTRemindView *)sharedInstance;

-(void)show;

@end
