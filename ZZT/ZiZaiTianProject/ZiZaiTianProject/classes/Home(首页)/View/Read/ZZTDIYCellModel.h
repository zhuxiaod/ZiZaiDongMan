//
//  ZZTDIYCellModel.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/27.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZTDIYCellModel : NSObject

@property (nonatomic,assign)CGFloat height;

@property (nonatomic,assign)BOOL isSelect;

@property (nonatomic,strong) NSMutableArray *imageArray;
//背景颜色
@property (nonatomic,assign) CGRect colorFrame;

@property (nonatomic,assign) CGPoint colorPoint;

@property (nonatomic,assign) CGFloat brightness;

@property (nonatomic,assign) CGFloat alpha;

+(instancetype)initCellWith:(CGFloat )height isSelect:(BOOL)isSelect;

@end
