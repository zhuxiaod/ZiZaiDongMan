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

@property (nonatomic,strong) NSString *type;

@property (nonatomic,assign) BOOL isCircle;

@property (nonatomic,strong) UIColor *viewColor;

@property(nonatomic,assign) CGAffineTransform viewTransform;

+(instancetype)initWithViewFrame:(CGRect)viewFrame tagNum:(NSInteger)tagNum;

@end
