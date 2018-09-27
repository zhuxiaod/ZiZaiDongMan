//
//  ZZTFangKuangModel.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/8.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZTFangKuangModel : NSObject

@property (nonatomic,assign) CGRect viewFrame;

@property (nonatomic,strong) NSMutableArray *viewArray;

@property (nonatomic,assign) NSInteger tagNum;

@property (nonatomic,strong) UIColor *modelColor;

@property (nonatomic,assign) BOOL isBlack;
//颜色
@property (nonatomic,assign) CGFloat colorF;

@property (nonatomic,assign) CGPoint colorPoint;

@property (nonatomic,assign) CGRect colorFrame;

@property (nonatomic,assign) CGFloat colorB;
//明度
@property (nonatomic,assign) CGFloat brightness;
//透明度
@property (nonatomic,assign) CGFloat alpha;

@property (nonatomic,strong) NSString *type;

@property (nonatomic,assign) BOOL isCircle;

+(instancetype)initWithViewFrame:(CGRect)viewFrame tagNum:(NSInteger)tagNum;

@end
