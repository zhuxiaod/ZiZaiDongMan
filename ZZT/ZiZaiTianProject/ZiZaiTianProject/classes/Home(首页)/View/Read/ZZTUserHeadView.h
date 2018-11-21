//
//  ZZTUserHeadView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/8.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZTUserHeadView : UIView

@property (nonatomic,strong) UIImageView *headView;

@property (nonatomic,strong) UIImageView *headFrame;


@property (nonatomic,strong) NSString *userImg;

@property (nonatomic,strong) NSString *placeHeadImg;

@property (nonatomic,strong) UIButton *viewClick;

-(void)setupUserHeadImg:(NSString *)userImg placeHeadImg:(NSString *)placeHeadImg;

@end
