//
//  ZZTCommentImgView.h
//  ZiZaiTianProject
//
//  Created by mac on 2019/1/14.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZTCommentImgView : UIView


@property (nonatomic, copy) void(^heightBlock)(CGFloat height);

@property (nonatomic,strong) ZZTMyZoneModel *model;

@property (strong, nonatomic) NSArray *imgArray;


-(CGFloat)getIMGHeight:(NSInteger)imgNum;

-(void)reloadView;

@end
