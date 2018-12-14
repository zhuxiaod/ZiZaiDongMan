//
//  ZZTCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/6/26.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZTCell : NSObject

@property (nonatomic ,copy)NSString *cellTitle;

@property (nonatomic ,copy)NSString *cellDetail;

+(instancetype)initCellModelWithTitle:(NSString *)cellTitle cellDetail:(NSString *)cellDetail;

@end
